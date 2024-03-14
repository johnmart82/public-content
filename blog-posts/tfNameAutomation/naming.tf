# Contains all constants for resource naming for this Terraform solution
# See: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
locals {
  azPrefix = {
    resource_group            = "rg"
    azure_sql_database_server = "sql"
    azure_sql_database        = "sqldb"
    storage_account           = "st"
  }
}

# Naming structure according to CAF
## <Resource Type>-<Worklaod/App>-<Environment>-<Azure Region>-<Instance>
## Resouce type will be added via lookup at the resource.
locals {

  baseName = lower(join("-", [var.applicationName, var.environment, var.azureRegion, var.applicationInstance]))
  # Certain resourecs like storage accounts need lowercase with no non-alphanumerics.
  safeName = replace(local.baseName, "-", "")
  # Some things like sql databases work better in other tools with underscores rather than hyphens.
  underscoredName = replace(local.baseName, "-", "_")
}
