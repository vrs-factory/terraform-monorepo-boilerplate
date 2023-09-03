locals {
  general_state = data.terraform_remote_state.general.outputs

  aws_region  = "eu-central-1"
  environment = "dev"
}
