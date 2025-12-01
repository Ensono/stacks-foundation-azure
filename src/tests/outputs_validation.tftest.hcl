# Test output validation and structure
run "verify_all_outputs" {
  command = apply

  variables {
    company_name = "TestCo"
    location     = "uksouth"
    project      = ["webapp", "api"]
    stage_name   = "foundation"
    environment  = "dev"
    outputs = jsonencode({
      dev = {
        test_output = "test_value"
      }
    })
  }

  # Verify all required outputs are present
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
    condition     = output.seed != null && length(output.seed) == 4
    error_message = "Seed output should be available and 4 characters"
  }

  assert {
    condition     = output.state_time != null
    error_message = "State time output should be available"
  }

  assert {
    condition     = output.computed_outputs != null
    error_message = "Computed outputs should be available"
  }
}
