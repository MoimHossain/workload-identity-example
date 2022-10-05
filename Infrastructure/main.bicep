targetScope = 'resourceGroup'

param location string = resourceGroup().location
param appName string = 'App${uniqueString(resourceGroup().id)}'

resource appPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${appName}-plan'
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard' 
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  kind: 'linux' 
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}


resource webapp 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  kind: 'app,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    serverFarmId: appPlan.id
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'DOTNETCORE|6.0'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    httpsOnly: true
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}
