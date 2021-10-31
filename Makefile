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

build-functions:
	$(call header, Building functions...)
	(cd functions/test && tsc)

docker-compose:
	$(call header, Running functions...)
	(cd functions && docker compose build && docker compose up)

deploy-test: build-functions
	$(call header, Deploy test function...)
	(docker build functions/test -t gcr.io/ava-ai-322720/test-function && docker push gcr.io/ava-ai-322720/test-function)