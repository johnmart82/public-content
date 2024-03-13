variable "ResourceGroupName" {
  type        = string
  description = "Please provide a name for the resource group."
}
variable "ResourceGroupLocation" {
  type        = string
  description = "Please provide an Azure region for the resource group."
}
variable "azSqlServer01-Name" {
  type        = string
  description = "Please provide a name for the Azure SQL Server."
}
variable "azSqlDb01-Name" {
  type        = string
  description = "Please provide a name for the Azure SQL Database."
}
variable "azSqlDb01-Collation" {
  type        = string
  description = "Please provide a name for the Azure SQL Database to be created."
}
variable "azSqlDb01-MaxSizeGb" {
  type        = number
  description = "Please provide an Integer value for the max size of the SQL Database to be created."
}
variable "azSqlDb01-SkuName" {
  type        = string
  description = "Please provide the SKU name for the Azure SQL Database tier. Can be obtained with \"az sql db list-editions -a -l <Azure Region> -o table\""
}
variable "azSqlDb01-ZoneRedundant" {
  type        = bool
  description = "Please provide confirmation (true|false) that Azure SQL Database should be zone redundant."
}
variable "azSqlServer01-aadAdminName" {
  type        = string
  description = "Please provide the name of the AAD object for the SQL Server admin."
}
variable "azSqlServer01-aadObjectId" {
  type        = string
  description = "Please provide the object ID of the admin user entity."
}