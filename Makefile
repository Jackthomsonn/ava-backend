ENVIRONMENT ?= dev
TARGET ?= rpi4

define header
  $(info $(START)▶▶▶ $(1)$(END))
endef

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

deploy-api: build-containers
	$(call header, Deploy api...)
	(docker build containers/api -t gcr.io/ava-ai-322720/api && docker push gcr.io/ava-ai-322720/api)