locals {
  general_state = data.terraform_remote_state.general.outputs

  aws_region  = "eu-west-1"
  environment = "prod"
}
