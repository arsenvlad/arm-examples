# Start Address
Example of using static private IPs and start address parameter for multi-node clusters on Azure

# Deploy using Azure CLI
```
azure account login
azure account set "My Subscription"
azure group list
azure group create --name avstartaddress1 --location westus
azure group deployment create --resource-group avstartaddress1 --name mainTemplate --template-file mainTemplate.json
```

# Description
Get input parameter of a start address for each of the 3 subnets from the UI control into the template.
Use static private IP addresses assigned following a convention like vm0, vm1, vm2, etc. 
In this way, we can know exactly which IPs are assigned to a node based on its index, the start address, and the total number of nodes.

* To make sure that we also get proper virtual network and subnet definitions as input parameters to the template, our createUiDefinition.json needs to include the VirtualNetworkCombo UI control azure group deployment create --resource-group avstartaddress1 --name mainTemplate --template-file mainTemplate.json
    * If we only want to support "new virtual network" pattern, we can set the options.hideExisting to false
    * The output of this UI control would give us back the 3 subnets that we requested and the start address for each of the subnets
    * We can configure the minAddressPrefixSize for the subnets and also set requireContiguousAddresses to true to make sure that all available addresses are one right after the other
* In the template, we setup 3 sets of parameters for the network
    * Subnet1Name
    * Subnet1AddressPrefix
    * Subnet1StartAddress
* In the template, we can use start address of each subnet to calculate the other IPs and set them statically on each network interface
* In the template, we pass can parameters to custom script extension
    * Number of VMs
    * Subnet1StartAddress
    * Subnet2StartAddress
    * Subnet3StartAddress

In variables section, we split the start addresses to get the octets (using short names to make the template more consise):

```
"s1": "[split(parameters('subnet1StartAddress'),'.')]",
"s2": "[split(parameters('subnet2StartAddress'),'.')]",
"s3": "[split(parameters('subnet3StartAddress'),'.')]",
```

In the copy loop for each NIC, we create the static IP assignments using a bit of IP math:

```
"privateIPAllocationMethod": "Static",
"privateIPAddress": "[concat(variables('s2')[0], '.', variables('s2')[1], '.', add(int(variables('s2')[2]), div(add(int(variables('s2')[3]),copyindex()),256)), '.', mod(add(int(variables('s2')[3]),copyindex()),256))]",
```

In the bash script within the VMs, we can reconstruct the IP addresses using something like this:

```
# Generate IP addresses of the nodes based on the convention of node0, node1, etc.
IFS='.' read -r -a startaddress_parts <<< "$STARTADDRESS"
for (( c=0; c<$VMCOUNT; c++ ))
do
    octet1=${startaddress_parts[0]}
    octet2=${startaddress_parts[1]}
    octet3=$(( ${startaddress_parts[2]} + $(( $((${startaddress_parts[3]} + c)) / 256 )) ))
    octet4=$(( $(( ${startaddress_parts[3]} + c )) % 256 ))
    ip=$octet1"."$octet2"."$octet3"."$octet4
    echo $ip
done 
```

* This example template attaches public IP only to the first VM created.
* It by default uses Standard_D3_v2 VMs since it shows how to attach 3 network cards to each.
* After the template runs successfully,  init.sh script will log some data into /var/log/messages

> Jul 21 23:22:25 localhost logger: init.sh NOW=20160721 MYIP1=10.0.0.11 NODETYPE=nodetype NODECOUNT=2 LOCALIP1=10.0.0.11 LOCALIP2=10.0.1.21 LOCALIP3=10.0.2.31 SUBNET1STARTADDRESS=10.0.0.11 SUBNET2STARTADDRESS=10.0.1.21 SUBNET3STARTADDRESS=10.0.2.31
 