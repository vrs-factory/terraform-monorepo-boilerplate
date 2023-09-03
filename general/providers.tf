terraform {
  backend "s3" {
    bucket         = "vrs-terraform-states"
    key            = "state-${local.environment}.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "vrs-terraform-locks"

    encrypt    = true
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }

  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.15"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = local.aws_region
}

# Uncomment after the state creation
# data "terraform_remote_state" "general" {
#   backend = "s3"
#   config = {
#     bucket     = "vrs-terraform-states"
#     key        = "state-general.tfstate"
#     region     = "eu-central-1"
#     access_key = var.aws_access_key
#     secret_key = var.aws_secret_key
#   }

#   # `data.terraform_remote_state.general.outputs`
# }

# Uncomment after the state creation
# data "terraform_remote_state" "dev" {
#   backend = "s3"
#   config = {
#     bucket     = "vrs-terraform-states"
#     key        = "state-dev.tfstate"
#     region     = "eu-central-1"
#     access_key = var.aws_access_key
#     secret_key = var.aws_secret_key
#   }

#   # `data.terraform_remote_state.dev.outputs`
# }
