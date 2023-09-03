include .env
.PHONY: help
.DEFAULT_GOAL := help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'


configure-s3: export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY)
configure-s3: export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_KEY)
configure-s3: export AWS_DEFAULT_REGION=$(BACKEND_REGION)
configure-s3: ## Creates a S3 bucket for states storing
	@echo "Creating and configuring a S3 bucket..."
	@aws s3api create-bucket \
  --bucket $(BACKEND_BUCKET_NAME) \
  --region $(BACKEND_REGION) \
  --create-bucket-configuration LocationConstraint=$(BACKEND_REGION)
	@aws s3api put-bucket-versioning \
  --bucket $(BACKEND_BUCKET_NAME) \
  --versioning-configuration Status=Enabled
	@aws s3api put-bucket-encryption \
  --bucket $(BACKEND_BUCKET_NAME) \
  --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'


configure-ddb: export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY)
configure-ddb: export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_KEY)
configure-ddb: export AWS_DEFAULT_REGION=$(BACKEND_REGION)
configure-ddb: ## Creates a DynamoDB table for state locks
	@echo "Creating and configuring a DynamoDB table..."
	@aws dynamodb create-table \
	--table-name $(BACKEND_TABLE_NAME) \
	--attribute-definitions AttributeName=LockID,AttributeType=S \
	--key-schema AttributeName=LockID,KeyType=HASH \
	--billing-mode PAY_PER_REQUEST \
	--deletion-protection-enabled


init-backend: configure-s3 configure-ddb ## Inits backend configuration
	@echo ">> Ready to go! :)"


init-state-general: ## Inits "general" terraform state
	@echo "Initializing GENERAL state ..."
	@cd general && terraform init \
	-reconfigure \
	-backend-config="access_key=$(AWS_ACCESS_KEY_ID)" \
	-backend-config="secret_key=$(AWS_SECRET_ACCESS_KEY)" \
	-backend-config="key=state-general.tfstate"


init-state-dev: ## Inits "dev" terraform state
	@echo "Initializing DEVELOPMENT state ..."
	@cd environments/dev && terraform init \
	-reconfigure \
	-backend-config="access_key=$(AWS_ACCESS_KEY_ID)" \
	-backend-config="secret_key=$(AWS_SECRET_ACCESS_KEY)" \
	-backend-config="key=state-dev.tfstate"


init-state-prod: ## Inits "prod" terraform state
	@echo "Initializing PRODUCTION state ..."
	@cd environments/prod && terraform init \
	-reconfigure \
	-backend-config="access_key=$(AWS_ACCESS_KEY_ID)" \
	-backend-config="secret_key=$(AWS_SECRET_ACCESS_KEY)" \
	-backend-config="key=state-prod.tfstate"
