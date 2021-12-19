WORKSPACE ?= dev
PROJECT ?= ava-ai-322720
REGION ?= us-central1
REBUILD ?=

define header
  $(info $(START)▶▶▶ $(1)$(END))
endef

set-project:
	$(call header, "Setting project to $(PROJECT)...")
	gcloud config set project $(PROJECT)

tf-init:
	$(call header, Initializing terraform for $(WORKSPACE)...)
	(cd infrastructure && terraform workspace select $(WORKSPACE) && terraform init)

tf-plan:
	$(call header, Creating plan for $(WORKSPACE)...)
	(cd infrastructure && terraform workspace select $(WORKSPACE) && terraform plan)

tf-apply:
	$(call header, Applying plan for $(WORKSPACE)...)
	(cd infrastructure && terraform apply)

build-containers:
	$(call header, Building containers...)
	(cd containers/api && tsc)

docker-compose:
	$(call header, Running containers...)
	(cd containers && docker compose up $(if $(REBUILD), --build))

unit-tests:
	$(call header, Running unit tests...)
	(cd containers/api && npx jest)

deploy-api: set-project
	$(call header, Deploy api for project $(PROJECT) in workspace $(WORKSPACE)...)
	docker build containers/api -t gcr.io/$(PROJECT)/$(WORKSPACE)-api && \
	docker push gcr.io/$(PROJECT)/$(WORKSPACE)-api && \
	gcloud run deploy $(WORKSPACE)-api --image=gcr.io/$(PROJECT)/$(WORKSPACE)-api --region $(REGION) --platform managed --allow-unauthenticated

run-migrations-api:
	$(call header, Running migrations for api for project $(PROJECT) in workspace $(WORKSPACE)...)
	cd containers/api && npx prisma migrate dev

decrypt-sops-api:
	$(call header, Decrypting sops files for api for project $(PROJECT) in workspace $(WORKSPACE)...)
	(sops -d ./secrets/$(WORKSPACE).yaml -> ./containers/api/.env-f)