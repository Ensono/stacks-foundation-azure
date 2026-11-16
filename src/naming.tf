
module "azure_naming" {

  for_each = var.project

  source = "Azure/naming/azurerm"

  unique-seed = random_string.random_seed.result

  # Build up the suuffix that is used for the naming
  suffix = compact(tolist(
    [
      var.suffix_include_company_name ? local.company_name_short : "",
      var.suffix_include_project_name ? substr(each.key, 0, var.short_name_length) : "",
      var.suffix_include_location ? module.azure_regions.regions_by_name[var.location].geo_code : "",
      var.suffix_include_workspace ? terraform.workspace : ""
    ]
  ))
}
