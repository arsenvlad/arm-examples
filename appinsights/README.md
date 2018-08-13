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

Create Application Insights resource in a separate resource group and from the same template get the App Insights information. For this approach, we pre-create the separate resource group for the App Insights resource (e.g. RG=avai1-app1). The template uses a nested template to create the App Insights resource in that separate existing resource group and afterwards uses the get-appinsights.json as a nested template to get back the instrumentation key. The reason we cannot get the instrumentation key from the same temlate is because it appears ARM template cannot use reference() to get information on resource that was created in separate RG during the same invocation (i.e. ARM template references for resources in other RGs are probably evaluated before the template starts execution both for nested template parameters and outputs)
```
az group create --name avai1-app1 --location eastus
az group deployment create --resource-group avai1 --template-file create-in-different-rg-and-get-appinsights.json
```