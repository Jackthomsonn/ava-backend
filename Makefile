ENVIRONMENT ?= dev
PROJECT ?= ava-ai-322720

define header
  $(info $(START)▶▶▶ $(1)$(END))
endef

set-project:
	$(call header, "Setting project to $(PROJECT)...")
	gcloud config set project $(PROJECT)

tf-plan:
	$(call header, Creating plan for $(ENVIRONMENT)...)
	(cd infrastructure && terraform workspace select $(ENVIRONMENT) && terraform plan)

tf-apply:
	$(call header, Applying plan for $(ENVIRONMENT)...)
	(cd infrastructure && terraform apply)

build-containers:
	$(call header, Building containers...)
	(cd containers/api && tsc)

docker-compose:
	$(call header, Running containers...)
	(cd containers && docker compose build && docker compose up)

deploy-api: set-project
	$(call header, Deploy api for project $(PROJECT) in environment $(ENVIRONMENT)...)
	docker build containers/api -t gcr.io/$(PROJECT)/$(ENVIRONMENT)-api && \
	docker push gcr.io/$(PROJECT)/$(ENVIRONMENT)-api && \
	gcloud run deploy $(ENVIRONMENT)-api --image=gcr.io/$(PROJECT)/$(ENVIRONMENT)-api --region us-central1 --platform managed --allow-unauthenticated