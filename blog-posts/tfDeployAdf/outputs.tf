output "GitHubAdfRepoName" {
  value = github_repository.ghAdfRepo.name
}

output "GitHubRepoURL" {
  value = github_repository.ghAdfRepo.html_url
}

output "AdfName" {
  value = azurerm_data_factory.adfDeployment-1.name
}