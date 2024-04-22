## Deploy resource group to contain our Azure resoures.
resource "azurerm_resource_group" "rgDeployment-1" {
  name     = join("-", [local.azPrefix.resource_group, local.baseName])
  location = var.azureRegion
}

resource "github_repository" "ghAdfRepo" {
  name        = var.githubAdfRepoName
  description = var.githubAdfRepoDescription
  visibility  = var.githubAdfRepoVisibility
  has_issues  = var.githubAdfRepoHasIssues
  has_wiki    = var.githubAdfRepoHasWiki
  auto_init   = var.githubAdfRepoAutoInit
}

resource "github_branch" "main" {
  repository = github_repository.ghAdfRepo.name
  branch     = var.githubAdfRepoDefaultBranchName
}

resource "github_branch_default" "ghAdfRepoBranchDefaultName" {
  repository = github_repository.ghAdfRepo.name
  branch     = github_branch.main.branch
}

resource "azurerm_data_factory" "adfDeployment-1" {
  name                = join("-", [local.azPrefix.resource_group, local.baseName])
  location            = azurerm_resource_group.rgDeployment-1.location
  resource_group_name = azurerm_resource_group.rgDeployment-1.name
  github_configuration {
    account_name       = var.githubAccountName
    branch_name        = github_branch_default.ghAdfRepoBranchDefaultName.branch
    repository_name    = github_repository.ghAdfRepo.name
    root_folder        = var.adfRepoRootFolder
    publishing_enabled = var.adfAutoPublishingEnabled
  }
}
