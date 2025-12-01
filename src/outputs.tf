
output "names" {
  value = module.azure_naming
}

output "extended_names" {
  value = local.extended_naming_map
}

output "regions" {
  value = module.azure_regions
}

output "computed_outputs" {
  value = local.outputs
}

output "state_time" {
  value = time_static.state_time
}

output "seed" {
  value = random_string.random_seed.result
}
