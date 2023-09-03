# Terraform Monorepo

## Structure

```shell
├── environments
│   ├── dev/
│   │   ├── locals.tf
│   │   ├── modules.tf
│   │   ├── outputs.tf -> ../outputs.tf
│   │   ├── providers.tf -> ../../general/providers.tf
│   │   ├── terraform.tfvars -> ../terraform.tfvars
│   │   └── variables.tf -> ../variables.tf
│   ├── prod/
│   │   ├── locals.tf
│   │   ├── modules.tf
│   │   ├── outputs.tf -> ../outputs.tf
│   │   ├── providers.tf -> ../../general/providers.tf
│   │   ├── terraform.tfvars -> ../terraform.tfvars
│   │   └── variables.tf -> ../variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   ├── terraform.tfvars.dist
│   └── variables.tf
├── general/
│   ├── ecr_repositories.tf
│   ├── locals.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   ├── terraform.tfvars.dist
│   └── variables.tf
├── modules/
│   └── local-module
│       ├── main.tf
│       └── ...
```

## Configuration

### Makefile

#### Prepare backend storage

1. Copy `.env.dist` to `.env`
2. Fill the envs with your AWS credentials and desired names.
3. Run:

```shell
make init-backend
```

#### Init general / environment

1. Copy `terraform.tfvars.dist` to `terraform.tfvars`
2. Run:

```shell
make init-state-{env}
```

### Manual

#### S3 bucket preparation

```shell
export BUCKET_NAME=vrs-terraform-states
export REGION=eu-central-1
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION \
  --create-bucket-configuration LocationConstraint=$REGION
aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption \
  --bucket $BUCKET_NAME \
  --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
```

#### DynamoDB table preparation

```shell
export TABLE_NAME=vrs-terraform-locks
aws dynamodb create-table \
  --table-name $TABLE_NAME \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --deletion-protection-enabled
```

#### Init environment

```shell
export TF_ENV=dev
terraform init \
  -backend-config="access_key=ACCESS_KEY_ID" \
  -backend-config="secret_key=SECRET_ACCESS_KEY_ID"
  -backend-config="key=state-$TF_ENV.tfstate"
```
