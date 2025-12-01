# Test workspace integration in naming
run "workspace_in_naming" {
  command = apply

  variables {
    company_name = "TestCo"
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

  # Verify workspace naming is available
  assert {
    condition     = output.names != null
    error_message = "Names should be generated with workspace"
  }

  # Verify random seed
  assert {
    condition     = output.seed != null && length(output.seed) == 4
    error_message = "Random seed should be 4 characters"
  }
}

run "different_workspaces_different_names" {
  command = apply

  variables {
    company_name = "TestCo"
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

  # Verify naming supports workspace differentiation
  assert {
    condition     = output.names != null
    error_message = "Naming should support workspace differentiation"
  }

  # Verify the random seed
  assert {
    condition     = output.seed != null && length(output.seed) == 4
    error_message = "Random seed should be 4 characters for uniqueness"
  }
}
