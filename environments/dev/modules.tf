module "local-module" {
  source = "../../modules/local-module"
}

module "remote-module" {
  source = "git::https://github.com/vrs-factory/terraform-aws-vpc?ref=v1.0.0"

  env = local.environment
}
