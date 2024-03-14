terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      ## https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/CHANGELOG.md
      version = "3.95.0"
    }
  }
}

provider "azurerm" {
  ## Using AZ CLI Login for this scenario, add client, tenant, and subscription details here if needed.
  features {
  }
}