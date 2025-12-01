# Test extended naming functionality for unsupported Azure resources
run "verify_extended_naming_types" {
  command = apply

  variables {
    company_name = "TestCo"
    location     = "uksouth"
    project      = ["test"]
    stage_name   = "foundation"
    environment  = "dev"
    outputs = jsonencode({
      dev = {
        test_output = "test_value"
      }
    })
  }

  # Verify extended names are available
  assert {
    condition     = output.extended_names != null
    error_message = "Extended names output should be available"
  }
}

run "verify_extended_naming_prefixes" {
  command = plan

  variables {
    company_name = "TestCo"
    location     = "uksouth"
    project      = ["test"]
    stage_name   = "foundation"
    environment  = "dev"
    outputs = jsonencode({
      dev = {
        test_output = "test_value"
      }
    })
  }

  # Verify Fabric capacity has correct prefix (afc)
  assert {
    condition     = startswith(local.extended_naming_map["test"].fabric_capacity.name, "afc")
    error_message = "Fabric capacity name should start with 'afc' prefix"
  }

  # Verify Front Door firewall policy has correct prefix (fdfwp)
  assert {
    condition     = startswith(local.extended_naming_map["test"].frontdoor_firewall_policy.name, "fdfwp")
    error_message = "Front Door firewall policy name should start with 'fdfwp' prefix"
  }

  # Verify AI services has correct prefix (ais)
  assert {
    condition     = startswith(local.extended_naming_map["test"].ai_services.name, "ais")
    error_message = "AI services name should start with 'ais' prefix"
  }

  # Verify managed identity has correct prefix (mi)
  assert {
    condition     = startswith(local.extended_naming_map["test"].managed_identity.name, "mi")
    error_message = "Managed identity name should start with 'mi' prefix"
  }
}
