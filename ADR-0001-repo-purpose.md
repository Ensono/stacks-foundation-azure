# Architecture Decision Record: Project Purpose

## Title
Define the Purpose and Scope of the stacks-foundation-azure Repository

## Status
Proposed


## Context
The stacks-foundation-azure repository is a foundational component of Ensono's infrastructure-as-code (IaC) ecosystem. It provides standardized Terraform modules, templates, and supporting scripts for provisioning and managing Azure cloud resources. The repository is designed to promote consistency, reusability, and best practices across multiple projects and teams deploying workloads to Azure.


### Naming Consistency
To ensure consistent and compliant resource naming across all Azure deployments, this repository implements a robust naming convention system. It leverages logic and templates that enforce organization-wide standards for resource names, regions, and environments. Importantly, the repository integrates with Azure Verified Modules (AVM), which are Microsoft-endorsed Terraform modules that follow best practices for Azure resource management. By using these modules, the repository ensures that naming conventions are not only consistent internally but also aligned with Azure's recommended patterns and compliance requirements.

#### Azure Verified Modules in Use

- **Azure Naming AVM**  
	Provides standardized naming for Azure resources, ensuring compliance and uniqueness.  
	Source: [Azure/naming/azurerm](https://registry.terraform.io/modules/Azure/naming/azurerm)  
	Homepage: [AVM Naming](https://azure.github.io/Azure-Verified-Modules/modules/utility/naming/)

- **Azure Regions AVM**  
	Supplies authoritative Azure region data and logic for region selection and filtering.  
	Source: [Azure/avm-utl-regions/azurerm](https://registry.terraform.io/modules/Azure/avm-utl-regions/azurerm)  
	Homepage: [AVM Regions](https://azure.github.io/Azure-Verified-Modules/modules/utility/regions/)

For more information about Azure Verified Modules, see the [AVM Homepage](https://azure.github.io/Azure-Verified-Modules/).

Key features and contents include:
- Core Terraform modules for Azure resource provisioning
- Naming conventions and region selection logic, with integration of Azure Verified Modules for best-practice naming
- Environment variable and configuration file templates
- Example deployments and usage documentation
- Azure DevOps pipeline templates for CI/CD
- Best practices and troubleshooting guides

## Decision
This repository will serve as the central source for foundational Azure IaC components at Ensono. All new Azure projects should leverage the modules, templates, and guidance provided here to ensure alignment with organizational standards and accelerate delivery.


## Build and Release Process

To make the foundational modules and templates easy to consume, the build pipeline automatically packages the relevant build artifacts into a zip file. This zip file is then published as a tagged release in the repository. Consumers, such as Terraform projects, can reference these tagged releases directly, ensuring they use a specific, versioned set of modules and templates.

### Key Points:
- The build process creates a zip archive containing all necessary Terraform modules, templates, and documentation.
- Each release is tagged and published in the repository, following semantic versioning or project-specific conventions.
- Consumers can download or reference the release artifact directly in their Terraform configurations, simplifying integration and version management.
- This approach ensures that consumers always have access to a stable, tested, and versioned set of IaC components.

## Consequences
- Teams benefit from a consistent, well-documented approach to Azure infrastructure
- Reduces duplication of effort and risk of misconfiguration
- Enables easier maintenance, upgrades, and compliance
- Provides a single point of reference for Azure IaC best practices
- Simplifies consumption and versioning of modules for downstream Terraform projects

---

*Created: 2026-01-03*
