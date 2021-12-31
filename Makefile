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

docker-compose: decrypt-sops-api
	$(call header, Running containers...)
	node scripts/sed.js
	(cd containers && docker compose up $(if $(REBUILD), --build))

unit-tests:
	$(call header, Running unit tests...)
	(cd containers/api && npx jest)

deploy-api: set-project decrypt-sops-api
	$(call header, Deploy api for project $(PROJECT) in workspace $(WORKSPACE)...)
	node scripts/sed.js
ifeq ($(WORKSPACE), dev)
	docker build containers/api -f ./containers/api/Dockerfile.dev -t gcr.io/$(PROJECT)/$(WORKSPACE)-api
else
	docker build containers/api -t gcr.io/$(PROJECT)/$(WORKSPACE)-api
endif
	docker push gcr.io/$(PROJECT)/$(WORKSPACE)-api && \
	gcloud run deploy $(WORKSPACE)-api --image=gcr.io/$(PROJECT)/$(WORKSPACE)-api --region $(REGION) --platform managed --allow-unauthenticated
decrypt-sops-api:
	$(call header, Decrypting sops files for api for project $(PROJECT) in workspace $(WORKSPACE)...)
	(sops -d ./secrets/$(WORKSPACE).yaml -> ./containers/api/.env-temp)
run-migrations-api:
	$(call header, Running migrations for api for project $(PROJECT) in workspace $(WORKSPACE)...)
	@if [ "$(WORKSPACE)" = "dev" ]; then\
		cd containers/api && npx prisma migrate dev;\
	fi
	@if [ "$(WORKSPACE)" = "prod" ]; then\
		cd containers/api && npx prisma migrate deploy;\
	fi