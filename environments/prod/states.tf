terraform {
  backend "s3" {
    bucket         = "vrs-terraform-states"
    key            = "state-prod.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "vrs-terraform-locks"

    encrypt    = true
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}
