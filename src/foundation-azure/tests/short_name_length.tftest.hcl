# Test short name length configuration
run "short_name_default_length" {
  command = apply

  variables {
    company_name = "VeryLongCompanyName"
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

  # Verify default short name length is 4
  assert {
    condition     = local.company_name_short == "Very"
    error_message = "Default short name should be 4 characters: expected 'Very', got '${local.company_name_short}'"
  }
}

run "short_name_custom_length" {
  command = apply

  variables {
    company_name      = "VeryLongCompanyName"
    location          = "uksouth"
    project           = ["webapp"]
    stage_name        = "foundation"
    environment       = "dev"
    short_name_length = 6
    outputs = jsonencode({
      dev = {
        test_output = "test_value"
      }
    })
  }

  # Verify custom short name length is applied
  assert {
    condition     = local.company_name_short == "VeryLo"
    error_message = "Custom short name should be 6 characters: expected 'VeryLo', got '${local.company_name_short}'"
  }
}

run "short_name_minimum_length" {
  command = apply

  variables {
    company_name      = "ABC"
    location          = "uksouth"
    project           = ["webapp"]
    stage_name        = "foundation"
    environment       = "dev"
    short_name_length = 2
    outputs = jsonencode({
      dev = {
        test_output = "test_value"
      }
    })
  }

  # Verify short name doesn't exceed company name length
  assert {
    condition     = local.company_name_short == "AB"
    error_message = "Short name should be truncated to 2 characters: expected 'AB', got '${local.company_name_short}'"
  }
}
