# Login to Azure tenant 
az login

# Show Azure subscriptions
az account list -o table

# Set the context to the subscription you want to use for the Azure storage account.
az account set --subscription <Your subscription ID>

# Create resource group, storage account, and create a container.
az group create --name rg-tsqltue-io --location uksouth
az storage account create --name sttsqltueio --resource-group rg-tsqltue-io
az storage container create --name sqlserverarchive --account-name sttsqltueio --auth-mode login

# Get the blob endpoint for the storage account.
## Keep this output as this will be needed for the SQL Server credential we will create later.
az storage account show --resource-group rg-tsqltue-io --name sttsqltueio --query 'primaryEndpoints.blob'
# Output: https://sttsqltueio.blob.core.windows.net/

# Load account key to environment variable for use with SAS creation.
AZURE_STORAGE_KEY=$(az storage account keys list --account-name sttsqltueio -o json --query '[0].value')

# Generate SAS key for use by SQL Server to access the storage location.
## Generate expiry date time for SAS, 1 day for the purposes of this demo.
expiryDateTime=`date -u -d "1 day" '+%Y-%m-%dT%H:%MZ'`
## SAS Properties
### Services - b [blob]
### Resource Type = sco [service, container, object]
### Permisisons = cdlruwap [create, delete, list, read, update, write, add, process]
az storage account generate-sas --expiry $expiryDateTime --services b --resource-types sco --permissions cdlruwap --account-name sttsqltueio --https-only --account-key $AZURE_STORAGE_KEY
## Save the output value somewhere safe to use with our SQL script.

# Now go and run the SQL commands to setup the database and files on blob storage.

# Once database has been created then come back and check that we can see the files in the container.
az storage blob list --account-key $AZURE_STORAGE_KEY --account-name sttsqltueio --container-name sqlserverarchive --query "[].name"