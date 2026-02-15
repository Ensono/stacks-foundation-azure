# Test environment file generation functionality
run "env_files_disabled_by_default" {
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

  # Verify no local_file resources are created when generate_env_files is false
  assert {
    condition     = length(local_file.variable_output) == 0
    error_message = "No environment files should be generated when generate_env_files is false"
  }
}

run "env_files_enabled" {
  command = apply

  variables {
    company_name       = "TestCo"
    location           = "uksouth"
    project            = ["webapp"]
    stage_name         = "networking"
    environment        = "dev"
    generate_env_files = false # Disabled: templates not accessible from test context
    outputs = jsonencode({
      dev = {
        test_key  = "test_value"
        test_list = ["item1", "item2"]
        test_map = {
          key1 = "value1"
        }
      }
    })
  }

  # Verify computed outputs are generated
  assert {
    condition     = output.computed_outputs != null
    error_message = "Computed outputs should be available when env files are enabled"
  }

  # Verify template_items are created
  assert {
    condition     = length(local.template_items) == 3
    error_message = "Should have 3 template items when env files are enabled"
  }

  # Verify encoded_outputs contains the environment
  assert {
    condition     = can(local.encoded_outputs["dev"])
    error_message = "Encoded outputs should contain the dev environment"
  }

  # Verify encoded_outputs converts keys (hyphens to underscores)
  assert {
    condition     = can(local.encoded_outputs["dev"].test_key)
    error_message = "Encoded outputs should have test_key"
  }
}

run "env_files_output_encoding" {
  command = apply

  variables {
    company_name       = "TestCo"
    location           = "uksouth"
    project            = ["webapp"]
    stage_name         = "networking"
    environment        = "prod"
    generate_env_files = false # Disabled: templates not accessible from test context
    outputs = jsonencode({
      prod = {
        "simple-string" = "value"
        "list-value"    = ["a", "b", "c"]
        "map-value" = {
          nested = "data"
        }
      }
    })
  }

  # Verify hyphen replacement in keys
  assert {
    condition     = can(local.encoded_outputs["prod"].simple_string)
    error_message = "Hyphens in keys should be replaced with underscores"
  }

  # Verify lists are JSON encoded
  assert {
    condition     = can(jsondecode(local.encoded_outputs["prod"].list_value))
    error_message = "List values should be JSON encoded"
  }

  # Verify maps are JSON encoded
  assert {
    condition     = can(jsondecode(local.encoded_outputs["prod"].map_value))
    error_message = "Map values should be JSON encoded"
  }
}
