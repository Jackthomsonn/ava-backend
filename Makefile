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

tf-init-deploy:
	$(call header, Initializing terraform for deploy in $(WORKSPACE)...)
	(cd infrastructure/deploy && terraform workspace select $(WORKSPACE) && terraform init)

tf-plan-deploy:
	$(call header, Creating plan for deploy $(WORKSPACE)...)
	(cd infrastructure/deploy && terraform workspace select $(WORKSPACE) && terraform plan)

tf-apply-deploy:
	$(call header, Applying plan for deploy in $(WORKSPACE)...)
	(cd infrastructure/deploy && terraform apply)

tf-init-core:
	$(call header, Initializing terraform for core...)
	(cd infrastructure/core && terraform workspace select core && terraform init)

tf-plan-core:
	$(call header, Creating plan for core...)
	(cd infrastructure/core && terraform workspace select core && terraform plan)

tf-apply-core:
	$(call header, Applying plan for core...)
	(cd infrastructure/core && terraform apply)

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

run-migrations-api-dev:
	$(call header, Running migrations for api for project $(PROJECT) in workspace $(WORKSPACE)...)
	cd containers/api && npx prisma migrate dev
	@if [ "$(WORKSPACE)" = "dev" ]; then\
		sops -d ./secrets/$(WORKSPACE).yaml -> ./containers/api/.env-f && cd containers/api && npx prisma migrate deploy;\
	fi

run-migrations-api-prod:
	$(call header, Running migrations for api for project $(PROJECT) in workspace $(WORKSPACE)...)
	@if [ "$(WORKSPACE)" = "prod" ]; then\
		sops -d ./secrets/$(WORKSPACE).yaml -> ./containers/api/.env-f && cd containers/api && npx prisma migrate deploy;\
	fi