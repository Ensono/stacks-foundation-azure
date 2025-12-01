# Test basic naming functionality with minimal configuration
run "basic_naming_test" {
  command = apply

  variables {
    company_name = "TestCompany"
    location     = "uksouth"
    project      = ["webapp"]
    stage_name   = "foundation"
    environment  = "dev"
    outputs = jsonencode({
      dev = {
        test_output = "test_value"
      }
    })
  }

  # Verify company name shortening
  assert {
    condition     = local.company_name_short == "Test"
    error_message = "Company name short should be first 4 characters: expected 'Test', got '${local.company_name_short}'"
  }

  # Verify random seed is generated with correct properties
  assert {
    condition     = length(random_string.random_seed.result) == 4
    error_message = "Random seed should be exactly 4 characters"
  }

  # Verify outputs are available
  assert {
    condition     = output.names != null
    error_message = "Names output should be available"
  }

  assert {
    condition     = output.extended_names != null
    error_message = "Extended names output should be available"
  }

  assert {
    condition     = output.regions != null
    error_message = "Regions output should be available"
  }

  assert {
    condition     = output.seed != null
    error_message = "Seed output should be available"
  }

  assert {
    condition     = output.state_time != null
    error_message = "State time output should be available"
  }
}
