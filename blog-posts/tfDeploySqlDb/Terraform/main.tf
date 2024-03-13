resource "azurerm_resource_group" "rg-deployment-core" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation
}

resource "azurerm_mssql_server" "az-sqlServer-01" {
  name                = var.azSqlServer01-Name
  location            = azurerm_resource_group.rg-deployment-core.location
  resource_group_name = azurerm_resource_group.rg-deployment-core.name
  version             = "12.0"
  ## Preference to use Entra ID auth as SQL username & password will be stored in plain text in plan/state files if used.
  azuread_administrator {
    login_username              = var.azSqlServer01-aadAdminName
    object_id                   = var.azSqlServer01-aadObjectId
    azuread_authentication_only = true
  }
}

resource "azurerm_mssql_database" "az-sqldb-01" {
  name           = var.azSqlDb01-Name
  server_id      = azurerm_mssql_server.az-sqlServer-01.id
  collation      = var.azSqlDb01-Collation
  max_size_gb    = var.azSqlDb01-MaxSizeGb
  sku_name       = var.azSqlDb01-SkuName
  zone_redundant = var.azSqlDb01-ZoneRedundant
}