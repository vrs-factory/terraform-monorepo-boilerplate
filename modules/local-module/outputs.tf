output "data" {
  value = "local-module-value: ${data.aws_caller_identity.current.arn}"
}
