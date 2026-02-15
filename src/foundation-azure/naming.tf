
module "azure_naming" {

  for_each = var.project

  source = "Azure/naming/azurerm"

  unique-seed = random_string.random_seed.result

  suffix = tolist(
    [
      local.company_name_short,
      substr(each.key, 0, var.short_name_length),
      module.azure_regions.regions_by_name[var.location].geo_code,
      terraform.workspace
    ]
  )
}
