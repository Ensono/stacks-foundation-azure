variables {
  company_name = "TestCompany"
  location     = "uksouth"
  project      = ["webapp", "backend"]
  stage_name   = "foundation"
  environment  = "dev"
  outputs = jsonencode({
    dev = {
      test_output = "test_value"
    }
  })
}

run "default_suffix" {
  command = apply

  assert {
    condition     = output.names["webapp"].resource_group.name == "rg-Test-weba-uks-${terraform.workspace}"
    error_message = "The default suffix should include company, project, location, and workspace in order."
  }

  assert {
    condition     = output.names["backend"].resource_group.name_unique == "rg-Test-back-uks-${terraform.workspace}-${output.seed}"
    error_message = "Unique names should use the project's default suffix followed by the seed."
  }
}

run "exclude_company" {
  command = apply

  variables {
    suffix_include_company_name = false
  }

  assert {
    condition     = output.names["webapp"].resource_group.name == "rg-weba-uks-${terraform.workspace}"
    error_message = "Disabling the company should remove only the company component."
  }
}

run "exclude_project" {
  command = apply

  variables {
    suffix_include_project_name = false
  }

  assert {
    condition     = output.names["webapp"].resource_group.name == "rg-Test-uks-${terraform.workspace}" && output.names["backend"].resource_group.name == "rg-Test-uks-${terraform.workspace}"
    error_message = "Disabling the project should remove the project component for every project."
  }
}

run "exclude_location" {
  command = apply

  variables {
    suffix_include_location = false
  }

  assert {
    condition     = output.names["webapp"].resource_group.name == "rg-Test-weba-${terraform.workspace}"
    error_message = "Disabling the location should remove only the location component."
  }
}

run "exclude_workspace" {
  command = apply

  variables {
    suffix_include_workspace = false
  }

  assert {
    condition     = output.names["webapp"].resource_group.name == "rg-Test-weba-uks"
    error_message = "Disabling the workspace should remove only the workspace component."
  }
}

run "combined_flags_and_short_names" {
  command = apply

  variables {
    short_name_length        = 3
    suffix_include_location  = false
    suffix_include_workspace = false
  }

  assert {
    condition     = output.names["webapp"].resource_group.name == "rg-Tes-web" && output.names["backend"].resource_group.name == "rg-Tes-bac"
    error_message = "Combined flags should preserve the configured short names for each project."
  }

  assert {
    condition     = output.extended_names["webapp"].managed_identity.name == "mi-Tes-web"
    error_message = "Extended names should use the same configured suffix."
  }
}

run "exclude_all_components" {
  command = apply

  variables {
    suffix_include_company_name = false
    suffix_include_project_name = false
    suffix_include_location     = false
    suffix_include_workspace    = false
  }

  assert {
    condition     = output.names["webapp"].resource_group.name == "rg" && output.names["webapp"].resource_group.name_unique == "rg-${output.seed}"
    error_message = "An empty suffix should leave only the resource prefix and, for unique names, the seed."
  }
}
