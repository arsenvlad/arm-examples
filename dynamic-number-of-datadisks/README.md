Update: This is an outdated approach that was needed only prior to ARM templates supporting copy for properties. You no longer need to use this approach. See this doc for the property iteration approach that is built into ARM template language https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-multiple#property-iteration

# Dynamic Number of Data Disks

Using nested deployment template to generate a unique array of dataDisks to use for the Virtual Machine.

### Set environment variables

Windows
```
set AZURE_STORAGE_ACCOUNT=templocistorage
set AZURE_STORAGE_KEY=
```

Linux
```
export AZURE_STORAGE_ACCOUNT=templocistorage
export AZURE_STORAGE_KEY=
```

Install Azure CLI 2.0
```
az storage blob upload-batch --destination datadisks --source . --pattern * 
```

Deploy
```
az group create --location eastus2 --name myrg1
az group deployment create --resource-group myrg1 --template-uri https://templocistorage.blob.core.windows.net/datadisks/mainTemplate.json -o json

azure group deployment create --resource-group myrg1 --template-uri https://templocistorage.blob.core.windows.net/datadisks/mainTemplate.json
```