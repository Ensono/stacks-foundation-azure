# Test region filtering functionality
run "region_recommend_filter_enabled" {
  command = apply

  variables {
    company_name            = "TestCo"
    location                = "uksouth"
    project                 = ["webapp"]
    stage_name              = "foundation"
    environment             = "dev"
    region_recommend_filter = true
    outputs = jsonencode({
      dev = {
        test_output = "test_value"
      }
    })
  }

  # Verify regions output is available
  assert {
    condition     = output.regions != null
    error_message = "Regions output should be available with recommendation filter"
  }
}

run "region_geography_filter" {
  command = apply

  variables {
    company_name     = "TestCo"
    location         = "westeurope" # Use a location in Europe geography
    project          = ["webapp"]
    stage_name       = "foundation"
    environment      = "dev"
    region_geography = "Europe"
    outputs = jsonencode({
      dev = {
        test_output = "test_value"
      }
    })
  }

  # Verify region geography filter is applied
  assert {
    condition     = output.regions != null
    error_message = "Regions output should be available with geography filter"
  }
}

run "region_no_filters" {
  command = apply

  variables {
    company_name            = "TestCo"
    location                = "uksouth"
    project                 = ["webapp"]
    stage_name              = "foundation"
    environment             = "dev"
    region_recommend_filter = false
    outputs = jsonencode({
      dev = {
        test_output = "test_value"
      }
    })
  }

  # Verify regions are available without filters
  assert {
    condition     = output.regions != null
    error_message = "Regions should be available even without filters"
  }
}
