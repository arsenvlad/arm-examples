# Set Many Tags as Parameters
This simple example shows how to pass multiple tags as parameter of type "object" to an ARM template and set them all on a created resource

Create resource group
```
az group create -n avtag1 -l eastus2
```

Deploy template with tagsObject parameter
```
az group deployment create -g avtag1 --template-file set-many-tags-as-parameter.json --parameter tagsObject="{'tag1':'value1','tag2':'value2'}"
```