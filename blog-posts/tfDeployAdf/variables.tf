## Naming variables.
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

## Provider variables.
variable "githubPAT" {
  type        = string
  description = "Please provide a GitHub Personal Access Token to authenticate against GitHub."
}

## GitHub Variables.
variable "githubAdfRepoName" {
  type        = string
  description = "Please provide the name of the repository to be created for ADF to be connected to."
}
variable "githubAdfRepoDescription" {
  type        = string
  description = "Please provide a brief description for the repo which will be used for ADF."
}
variable "githubAdfRepoVisibility" {
  type        = string
  description = "Please specify a visibility for the GitHub Repository which will be connected to ADF [public | private]."
  default     = "private"
}
variable "githubAdfRepoHasIssues" {
  type        = bool
  description = "Please select if the Issues feature within the ADF repository will be enabled. [true | false]."
  default     = true
}
variable "githubAdfRepoHasWiki" {
  type        = bool
  description = "Please select if the wiki feature within the ADF repository will be enabled. [true | false]."
  default     = true
}
variable "githubAdfRepoDefaultBranchName" {
  type        = string
  description = "Please provide the default branch name for the ADF repository."
  default     = "main"
}
variable "githubAdfRepoAutoInit" {
  type        = bool
  description = "Please select if the GitHub repo will auto init."
  default     = true
}

## ADF Variables
variable "githubAccountName" {
  type        = string
  description = "Please provide the account name which hosts the repository used by ADF."
}
variable "adfRepoRootFolder" {
  type        = string
  description = "Please provide a root folder for the GitHub repository used by ADF."
  default     = "/"
}
variable "adfAutoPublishingEnabled" {
  type        = bool
  description = "Please set whether auto-publishing is enabled by default on the ADF source countrol repository."
  default     = true
}