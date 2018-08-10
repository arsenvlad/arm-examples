# Azure Application Insights ARM Template Example

Create Application Insights resource
```
az group create --name avai1 --location eastus
az group deployment create --resource-group avai1 --template-file create-appinsights.json
```

Look at the outputs of the last deployment to see how object is structured
```
az group deployment show --query properties.outputs --resource-group avai1 --name create-appinsights -o json
```

```json
{
  "appInsightsInstrumentationKey": {
    "type": "String",
    "value": "xxxx61fc-xxxx-41fa-86b0-caa462a0xxxx"
  },
  "appInsightsObject": {
    "type": "Object",
    "value": {
      "AppId": "17f671dd-c720-xxxx-bf51-8c225d1dxxxx",
      "ApplicationId": "app1",
      "Application_Type": "web",
      "CreationDate": "2018-08-10T20:17:43.9185045+00:00",
      "CustomMetricsOptedInType": null,
      "Flow_Type": null,
      "HockeyAppId": null,
      "HockeyAppToken": null,
      "InstrumentationKey": "xxxx61fc-xxxx-41fa-86b0-caa462a0xxxx",
      "Name": "app1",
      "PackageId": null,
      "Request_Source": null,
      "SamplingPercentage": null,
      "TenantId": "xxxxxxxx-xxxx-xxxx-xxxx-a66deba80362",
      "Ver": "v2",
      "provisioningState": "Succeeded"
    }
  },
  "appInsightsResourceId": {
    "type": "String",
    "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-a66deba80362/resourceGroups/avai1/providers/Microsoft.Insights/components/app1"
  }
}
```

Get an already existing Application Insights resource in same or different resource group
```
az group deployment create --resource-group avai1 --template-file get-appinsights.json
az group deployment show --query properties.outputs --resource-group avai1 --name get-appinsights -o json
```

