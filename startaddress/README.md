# Start Address
Example of using static private IPs and start address parameter for multi-node clusters on Azure

# Deploy using Azure CLI
```
azure account login
```
```
azure account set "My Subscription"
```
```
azure group list
```
```
azure group create --name avstartaddress1 --location westus
```
```
azure group deployment create --resource-group avstartaddress1 --name mainTemplate --template-file mainTemplate.json
```

# Copy data to Azure Storage using Azure CLI
azure storage blob copy start --source-uri "https://mydatasource/data.tar.gz" --dest-account-name "mydestination" --dest-account-key "" --dest-container "data" --dest-blob "data.tar.gz"

