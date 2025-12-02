# Stacks Foundation Azure Terraform Module

A foundational Terraform module that provides **standardized naming conventions** and **regional configurations** for Azure infrastructure deployments across Ensono Stacks projects.

## What It Does

This module:

- **Generates consistent Azure resource names** following organizational standards
- **Provides regional configuration data** for Azure deployments
- **Creates unique identifiers** (seeds) for resource naming
- **Supports multiple projects** in a single deployment
- **Offers extended naming** for additional Azure resource types
- **Generates environment variable files** (optional) for integration with other tools

## Quick Start

### Using the Distributed Zip File

Terraform can consume the zip file **directly** without extraction. You have three options:

#### Option 1: Direct HTTP/HTTPS URL (Recommended)

```hcl
module "foundation" {
  source = "https://github.com/ensono/stacks-foundation-azure/releases/stacks-foundation-azure-0.0.3.zip"

  company_name = "MyCompany"
  location     = "uksouth"
  project      = ["webapp"]
  stage_name   = "foundation"
  environment  = "dev"
}
```

#### Option 2: Local Zip File

```hcl
module "foundation" {
  source = "./path/to/stacks-foundation-azure.zip"

  company_name = "MyCompany"
  location     = "uksouth"
  project      = ["webapp"]
  stage_name   = "foundation"
  environment  = "dev"
}
```

#### Option 3: Extract Locally

```bash
# Extract the module
unzip stacks-foundation-azure.zip -d ./modules/foundation
```

```hcl
module "foundation" {
  source = "./modules/foundation"

  company_name = "MyCompany"
  location     = "uksouth"
  project      = ["webapp"]
  stage_name   = "foundation"
  environment  = "dev"
}
```

### Using the Generated Names

```hcl
resource "azurerm_resource_group" "example" {
  name     = module.foundation.names["webapp"].resource_group.name
  location = module.foundation.names["webapp"].resource_group.location
}
```

> [!NOTE]
> When using a zip file as the source (Options 1 or 2), run `terraform init` to download and extract the module. Terraform handles the extraction automatically.

### Module Outputs

The module provides several outputs:

- `names` - Standard Azure resource naming conventions
- `extended_names` - Extended resource types (Fabric, AI services, Front Door, etc.)
- `regions` - Azure region configuration data
- `seed` - Unique 4-character identifier for this deployment
- `state_time` - Timestamp when the module state was created

## Building the Module

For developers working on this repository:

```bash
# Install eirctl (Ensono Infrastructure CLI)
# Set the build number
export BUILD_BUILDNUMBER=$(eirctl build:number)
# Run the build pipeline
eirctl build

# Output will be in:
# outputs/stacks-foundation-azure.zip
```

## Documentation

- **Module Usage Guide** - Packaged inside the zip file as `README.md`
- **Repository Development Guide** - See `docs/repository/index.adoc`

## Requirements

- Terraform >= 1.0.0
- Azure provider configured
- Azure CLI authentication (for tenant/subscription detection)

## License

Copyright (c) 2025 Ensono

This project is licensed under the MIT License. See the `LICENSE` file for details.
