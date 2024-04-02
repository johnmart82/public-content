variable "applicationName" {
  type        = string
  description = "Please provide the workload or application name descriptor for resources to be deployed."
}
variable "environment" {
  type        = string
  description = "Please provide the environment descriptor for the resources to be deployed. Valid options are dev, test, stage, prod."

  validation {
    condition     = contains(["dev", "test", "stage", "prod"], lower(var.environment))
    error_message = "Incorrect value passed for environment name, valid options are dev, test, stage, prod."
  }
}
variable "azureRegion" {
  type        = string
  description = "Please provide the Azure Region for the resource deployment."
}
variable "applicationInstance" {
  type        = string
  description = "Please provide the instance ID for the workload or application deployment."
}
variable "sqlServerAdminEntraIdName" {
  type        = string
  description = "Please provide the name of the user or group which will be the administrator for the SQL Server."
}
variable "sqlServerAdminEntraIdObjectId" {
  type        = string
  description = "Please provide the Entra ID Object ID of the user or group which is associated with the admin user or group for the SQL Server."
}
variable "azureSqlServerVersion" {
  type        = string
  description = "Please provide the version for the Azure SQL Database engine to use. Valid options are 2.0 or 12.0"
  default     = "12.0"
}
variable "azureSqlDbMaxSizeGb" {
  type        = number
  description = "Please provide an integer value for the max size in GB of the Azure SQL Database to be created."
}
variable "azureSqlDbSkuName" {
  type        = string
  description = "Please provide the SKU name for the Azure SQL Database to be created."
  default     = "S0"
}
variable "azureSqlDbZoneRedundancy" {
  type        = bool
  description = "Please set whether the Azure SQL Database being deployed should be zone redundany. Permitted values are true or false."
  default     = false
}
variable "blobstore1AccountTier" {
  type        = string
  description = "Please provide the apprioriate value for the account tier for the blobstore1 storage account."
  default     = "Standard"
}
variable "blobstore1AccountRepType" {
  type        = string
  description = "Please provide the level of protection for the blobstore1 storage account."
  default     = "LRS"
}