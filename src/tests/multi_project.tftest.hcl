# Test multi-project configuration
run "multi_project_naming" {
  command = apply

  variables {
    company_name = "Ensono"
    location     = "uksouth"
    project      = ["frontend", "backend", "database"]
    stage_name   = "foundation"
    environment  = "prod"
    outputs = jsonencode({
      prod = {
        test_output = "test_value"
      }
    })
  }

  # Verify all outputs contain multiple projects
  assert {
    condition     = output.names != null
    error_message = "Names output should be available for multi-project"
  }

  assert {
    condition     = output.extended_names != null
    error_message = "Extended names output should be available for multi-project"
  }

  # Verify company name shortening
  assert {
    condition     = local.company_name_short == "Enso"
    error_message = "Company name short should be first 4 characters: expected 'Enso', got '${local.company_name_short}'"
  }
}
