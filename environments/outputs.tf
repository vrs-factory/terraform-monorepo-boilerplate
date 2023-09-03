output "local_module" {
  value = module.local-module.data
}

output "general_state" {
  value = local.general_state
}
