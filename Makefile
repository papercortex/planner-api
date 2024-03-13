.PHONY: build deploy destroy load-infra-env download-logs

install:
	@echo "Installing Planner Api..."
	npm install

dev:
	@echo "Running Planner Api in development mode..."
	docker compose up mongo -d
	concurrently "mongo-gui" "npm run dev"

build: install
	@echo "Building Planner Api..."
	@rm -rf tmp && mkdir -p tmp/planner-api-package
	npm run build
	@cp -R ./dist/ tmp/planner-api-package/dist/
	@cp ./package.json tmp/planner-api-package/package.json
	@cp ./package-lock.json tmp/planner-api-package/package-lock.json
	cd tmp/planner-api-package && zip -r ../planner-api-$(PLANNER_ARTIFACT_VERSION).zip .

deploy: build
	@echo "Deploying Planner Api..."
	aws s3 cp tmp/planner-api-$(PLANNER_ARTIFACT_VERSION).zip s3://papercortex-prod-planner-api-artifacts/$(PLANNER_ARTIFACT_VERSION).zip
	cd terraform && terraform init && terraform apply -var-file=./terraform.tfvars -var="artifact_version=$(PLANNER_ARTIFACT_VERSION)"

destroy:
	@echo "Destroying Planner Api Infrastructure..."
	cd terraform && terraform destroy

load-planner-api-env:
	@echo "Loading Infrastructure Environment Variables..."
	$(eval export EB_ENVIRONMENT_NAME=$(shell cd terraform && terraform output -raw eb_environment_name 2>/dev/null))

download-logs: load-planner-api-env
	@echo "Downloading logs for environment: $(EB_ENVIRONMENT_NAME)..."
	@aws elasticbeanstalk request-environment-info --environment-name $(EB_ENVIRONMENT_NAME) --info-type tail
	@sleep 10 # Wait for the log bundle to be ready
	$(eval export LOG_URL := $(shell aws elasticbeanstalk retrieve-environment-info --environment-name $(EB_ENVIRONMENT_NAME) --info-type tail --query "EnvironmentInfo[0].Message" --output text))
	@mkdir -p ./logs
	@rm -f ./logs/$(EB_ENVIRONMENT_NAME)-logs.zip
	curl -o ./logs/$(EB_ENVIRONMENT_NAME)-logs.zip "$(LOG_URL)"
	@echo "Logs downloaded to ./logs/"
