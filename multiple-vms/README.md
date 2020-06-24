# Deploy Multiple Azure VMs

Example of a few simple ARM templates that deploy multiple Azure VMs into an existing VNet/subnet using Azure platform/marketplace image or [Azure Shared Gallery Image](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/shared-image-galleries)

## Test Resource Group, VNet, and Subnet

Create resource group, VNet, and network security group for testing

```bash
az group create --name avmultivm1 --location eastus
az network vnet create --resource-group avmultivm1 --name vnet-avmultivm1 --address-prefix 10.0.0.0/16 --subnet-name subnet-vms --subnet-prefix 10.0.0.0/24
az network nsg create --resource-group avmultivm1 --name nsg-avmultivm1
az network vnet subnet update --resource-group avmultivm1 --name subnet-vms --vnet-name vnet-avmultivm1 --network-security-group nsg-avmultivm1
```

Get subnet resource id

```bash
SUBNET_RESOURCE_ID=$(az network vnet subnet show --resource-group avmultivm1 --name subnet-vms --vnet-name vnet-avmultivm1 --query id -o tsv)
echo SUBNET_RESOURCE_ID=$SUBNET_RESOURCE_ID
```

## Deploy VMs Using Platform/Marketplace Image

List platform/marketplace CentOS 7.7 images

```bash
# List CentOS 7.7 images
az vm image list --all --publisher OpenLogic --offer CentOS --sku 7.7
```

Set SSH Public Key (obviously, use your own public key here instead of the test one below)

```bash
SSH_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9wmUPRLdMUJ8/HJz+gpp1YbE09W7HHsAmh0SoCUUrjCsdAoK7x9IQcl+5WP3H1JmtvejZRbPemxtbWgtN3aMvr4WxB0ukfdc4Dcsj73uyhBKn9pUAa/uQV0pwX1FsTNsLF8U99kjfEmCwW6bHOS5PB2E9Kh0pw8i1A36kcgudtoWd6XmwLwlAeVtK+ULkHUHNjOxqLXzbISKeARnhBzqnlA/g+usYEvTLL/VzKFd8FZEF+UBxo5FNVuFIyyXSEr2lRMiaa0W++E1EWhwGNn5weM36vFaZS0So2I8tV/aEb7hfpVe9hSrGjkijAwh+E+nNvjyg0Z1Y407nKvCD9yLr AV"
```

Deploy multiple VMs by pointing imageReference to OpenLogic:CentOS:7.7:latest image from platform/marketplace

```bash
az deployment group create --resource-group avmultivm1 --name deployment001 --template-file multi-vm-spot-template.json --parameters numberOfVms=2 vmSize=Standard_D4s_v3 subnetResourceId="$SUBNET_RESOURCE_ID" sshPublicKey="$SSH_PUBLIC_KEY" customData="# my custom data #" imageReference="{'publisher':'OpenLogic','offer':'CentOS','sku':'7.7','version':'latest'}" additionalTags="{'tag2':'value2','tag3':'value3'}"
```

## Deploy VMs Using Shared Image Gallery Image

See [this](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/shared-image-galleries) to learn more about the Azure Shared Image Gallery and how to create your Shared Image Gallery from a managed image.

Below are example, Azure CLI commands to create shared image gallery image from an existing managed image

```bash
az group create --name avsig100 --location eastus

# Create Shared Image Gallery resource
az sig create --resource-group avsig100 --gallery-name gallery100 --location eastus

# Create Image Definition in the newly created Shared Image Gallery
az sig image-definition create --resource-group avsig100 --gallery-name gallery100 --gallery-image-definition ubuntu1804lts --os-type Linux --publisher publisher100 --offer ubuntu --sku 1804lts --location eastus

# Create concrete image version from an existing managed image (change the managed-image to point to your managed image resource id)
# This command will take some time to execute while multiple replicas of the image are being created
az sig image-version create --resource-group avsig100 --gallery-name gallery100 --gallery-image-definition ubuntu1804lts --gallery-image-version 1.0.0 --managed-image "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Compute/images/{managed-image-name}" --location eastus --target-regions eastus=2
```

List existing shared image galleries, image definitions, and image versions

```bash
az sig list --resource-group avsig100 -o table
az sig image-definition list --resource-group avsig100 --gallery-name gallery100 -o table
az sig image-version list --resource-group avsig100 --gallery-name gallery100 --gallery-image-definition ubuntu1804lts -o table
```

Get shared image version resource id

```bash
IMAGE_RESOURCE_ID=$(az sig image-version show --resource-group avsig100 --gallery-name gallery100 --gallery-image-definition ubuntu1804lts --gallery-image-version 1.0.0 --query id -o tsv)
echo IMAGE_RESOURCE_ID=$IMAGE_RESOURCE_ID
```

Deploy multiple VMs by pointing imageReference to the resource id of the shared image gallery image version

```bash
az deployment group create --resource-group avmultivm1 --name deployment002 --template-file multi-vm-spot-template.json --parameters numberOfVms=3 vmSize=Standard_D4s_v3 subnetResourceId="$SUBNET_RESOURCE_ID" sshPublicKey="$SSH_PUBLIC_KEY" customData="# my custom data #" imageReference="{\"id\":\"$IMAGE_RESOURCE_ID\"}" additionalTags="{'tag2':'value2','tag3':'value3'}"
```

## Get VM Deployment Operation Timing

```bash
az deployment operation group list --resource-group avmultivm1 --name deployment002 --query "[?properties.targetResource.resourceType=='Microsoft.Compute/virtualMachines'].{Duration:properties.duration,State:properties.provisioningState,Resource:properties.targetResource.resourceName,ResourceType:properties.targetResource.resourceType}"
```
