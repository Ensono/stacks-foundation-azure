# Terraform Tests for Stacks Foundation Azure

This directory contains unit tests for the Stacks Foundation Azure Terraform module using the native Terraform test framework.

## Test Files

### `basic_naming.tftest.hcl`
Tests basic naming functionality with minimal configuration:
- Verifies names are generated for a single project
- Validates company name shortening logic
- Checks random seed generation (4 characters, lowercase, no special chars)
- Confirms region information is available

### `multi_project.tftest.hcl`
Tests multi-project configuration:
- Verifies naming for multiple projects (frontend, backend, database)
- Ensures all projects receive naming configurations
- Validates extended naming is available for all projects

### `short_name_length.tftest.hcl`
Tests short name length configuration:
- Default length (4 characters)
- Custom length configuration
- Edge cases (company name shorter than configured length)

### `region_filtering.tftest.hcl`
Tests region filtering functionality:
- Recommended regions filter enabled/disabled
- Geography-based filtering (e.g., "Europe")
- No filters applied

### `outputs_validation.tftest.hcl`
Tests output structure and validation:
- Verifies all expected outputs are present
- Validates extended naming contains all custom resource types
- Checks output data structures

### `extended_naming.tftest.hcl`
Tests extended naming for unsupported Azure resources:
- Microsoft Fabric (capacity, workspace, lakehouse)
- Azure Front Door (firewall policy, endpoint, security policy)
- AI Services (services, foundry, foundry project)
- Other resources (managed identity, key vault v2, private DNS links)
- Validates correct naming prefixes

### `env_file_generation.tftest.hcl`
Tests environment file generation:
- Disabled by default
- Enabled with outputs
- Output encoding (strings, lists, maps)
- Key transformation (hyphens to underscores)

### `workspace_naming.tftest.hcl`
Tests Terraform workspace integration:
- Workspace name included in resource names
- Naming structure validation

## Important Note

All tests include a required `outputs` variable that is used by the module to generate environment files. This variable must be a JSON-encoded string containing environment-specific outputs.

Example:
```hcl
outputs = jsonencode({
  dev = {
    test_output = "test_value"
  }
})
```

## Running the Tests

### Run All Tests

```powershell
# From the src/ directory
cd src
terraform init
terraform test
```

### Run Specific Test File

```powershell
# Run only basic naming tests
terraform test -filter=tests/basic_naming.tftest.hcl

# Run only multi-project tests
terraform test -filter=tests/multi_project.tftest.hcl

# Run only extended naming tests
terraform test -filter=tests/extended_naming.tftest.hcl
```

### Verbose Output

```powershell
# Show detailed test output
terraform test -verbose
```

### Run Tests in Specific Test Block

```powershell
# Run a specific test run block
terraform test -filter=tests/short_name_length.tftest.hcl#short_name_custom_length
```

## Test Output

Successful test output will look like:

```
tests/basic_naming.tftest.hcl... pass
tests/multi_project.tftest.hcl... pass
tests/short_name_length.tftest.hcl... pass
tests/region_filtering.tftest.hcl... pass
tests/outputs_validation.tftest.hcl... pass
tests/extended_naming.tftest.hcl... pass
tests/env_file_generation.tftest.hcl... pass
tests/workspace_naming.tftest.hcl... pass

Success! 8 passed, 0 failed.
```

Failed tests will show specific assertion errors with the configured error messages.

## Prerequisites

- Terraform 1.6.0 or later (native test framework support)
- Valid Azure credentials (for region and naming module initialization)
- Internet connectivity (to download required modules)

## Test Strategy

These tests use the `command = plan` strategy, which:
- Validates Terraform configuration syntax
- Checks that all resources can be planned
- Runs assertions against planned values
- Does NOT create actual Azure resources
- Executes quickly without cloud costs

## Continuous Integration

To integrate these tests into CI/CD pipelines:

```yaml
# Example GitHub Actions
- name: Run Terraform Tests
  run: |
    cd src
    terraform init
    terraform test
```

```yaml
# Example Azure DevOps
- task: PowerShell@2
  displayName: 'Run Terraform Tests'
  inputs:
    targetType: 'inline'
    script: |
      cd src
      terraform init
      terraform test
```

## Adding New Tests

1. Create a new `.tftest.hcl` file in the `tests/` directory
2. Define test runs with `run "test_name" { ... }`
3. Set `command = plan` (or `apply` if needed)
4. Provide required variables
5. Add assertions using `assert { condition = ..., error_message = ... }`
6. Run `terraform test` to validate

Example:

```hcl
run "my_new_test" {
  command = plan

  variables {
    company_name = "TestCo"
    location     = "uksouth"
    project      = ["test"]
    stage_name   = "foundation"
    environment  = "dev"
  }

  assert {
    condition     = can(module.azure_naming["test"].resource_group.name)
    error_message = "Resource group name should be generated"
  }
}
```

## Troubleshooting

### Tests Fail with "Module not installed"

```powershell
# Initialize Terraform first
cd src
terraform init
```

### Tests Fail with Region Errors

Ensure you have valid Azure credentials configured or disable region filters in tests.

### Assertion Failures

Check the error message in the test output for specific details about what failed and why.
