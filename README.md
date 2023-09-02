# Terraform Monorepo


## Pre-configuration

### S3 bucket preparation

```
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

### DynamoDB table preparation

```
export TABLE_NAME=vrs-terraform-locks
aws dynamodb create-table \
  --table-name $TABLE_NAME \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --deletion-protection-enabled
```

## Init environment

```shell
terraform init \
  -backend-config="access_key=ACCESS_KEY_ID" \
  -backend-config="secret_key=SECRET_ACCESS_KEY_ID"
```
