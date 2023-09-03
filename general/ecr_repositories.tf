module "project_api" {
  source = "git::https://github.com/vrs-factory/terraform-aws-ecr?ref=v1.0.0"

  namespace        = "vrs-factory/project"
  name             = "api"
  max_images_count = 30
}
