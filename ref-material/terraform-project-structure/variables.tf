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