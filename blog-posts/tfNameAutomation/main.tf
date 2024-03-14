resource "azurerm_resource_group" "rg-base-resourceGroup" {
  name     = join("-", [local.azPrefix.resource_group, local.baseName])
  location = var.azureRegion
}

resource "azurerm_mssql_server" "sql-paasSqlServer1" {
  name                = join("-", [local.azPrefix.azure_sql_database_server, local.baseName])
  resource_group_name = azurerm_resource_group.rg-base-resourceGroup.name
  location            = azurerm_resource_group.rg-base-resourceGroup.location
  version             = var.azureSqlServerVersion
  azuread_administrator {
    login_username = var.sqlServerAdminEntraIdName
    object_id      = var.sqlServerAdminEntraIdObjectId
    azuread_authentication_only = true
  }
}

resource "azurerm_mssql_database" "sqldb-appdb1" {
  name           = join("_", [local.azPrefix.azure_sql_database, local.underscoredName])
  server_id      = azurerm_mssql_server.sql-paasSqlServer1.id
  max_size_gb    = var.azureSqlDbMaxSizeGb
  sku_name       = var.azureSqlDbSkuName
  zone_redundant = var.azureSqlDbZoneRedundancy
}

resource "azurerm_storage_account" "st-blobstore1" {
  name                     = join("", [local.azPrefix.storage_account, local.safeName])
  resource_group_name      = azurerm_resource_group.rg-base-resourceGroup.name
  location                 = azurerm_resource_group.rg-base-resourceGroup.location
  account_tier             = var.blobstore1AccountTier
  account_replication_type = var.blobstore1AccountRepType
}
