###
### Assuming that login and subscription context has been set before running this script.
###

## Set variable properties for script.
$sasStartTime = -1
$sasEndDurationDays = 7
$sourceSqlInstanceName = "localhost"
$managedInstanceName = ""

## Create instance objects for use later to create credentials.
### I am using SQL Authentication here and will prompt for login details. Update as needed for your scenario.
$sourceSqlInstance = Connect-DbaInstance -SqlInstance $sourceSqlInstanceName -Database master -SqlCredential (Get-Credential) -TrustServerCertificate
$managedInstance = Connect-DbaInstance -SqlInstance $managedInstanceName -Database master -SqlCredential (Get-Credential) -TrustServerCertificate

## Setup an Azure Storage Account and container for our database backup.
$newStorageAccountParams = @{
    ResourceGroupName = "rg-migrations" 
    Name = "stmigblogpost" 
    SkuName = "Standard_LRS"
    Location = 'UK South' 
    Kind = "StorageV2" 
    AccessTier = "Hot"
    MinimumTlsVersion = "TLS1_2"
    AllowBlobPublicAccess = $false
}
$storageAccount = New-AzStorageAccount @newStorageAccountParams

$newStorageAccountContainerParams = @{
    Name = "dbbackups"
    Context = $storageAccount.Context
}
$container = New-AzStorageContainer @newStorageAccountContainerParams

## Create a new SAS token with an appropriate duration which will be used by the SQL credential for backup and restore.
### See Microsoft documentation for more details and recommended practices for use of SAS keys in production scenarios.
$newSasTokenParams = @{
    Context = $storageAccount.Context
    Service = "Blob"
    ResourceType = "Container","Object"
    Permission = "racwdlup"
    StartTime = ((Get-Date).AddDays($sasStartTime))
    ExpiryTime = ((Get-Date).AddDays($sasEndDurationDays))
}
$sasToken = New-AzStorageAccountSASToken @newSasTokenParams

## Create new SQL Credential using DbaToolss PowerShell module and copy to target server.
$newDbaCredentialParams = @{
    SqlInstance = $sourceSqlInstance
    Name = $container.CloudBlobContainer.Uri.AbsoluteUri
    Identity = "Shared Access Signature"
    SecurePassword = (ConvertTo-SecureString -AsPlainText -Force ($sasToken.Replace("?","")))
}
$credential = New-DbaCredential @newDbaCredentialParams
$copyCredentialParams = @{
    Source = $sourceSqlInstance
    Destination = $managedInstance
    Name = $credential.Name
}
Copy-DbaCredential @copyCredentialParams