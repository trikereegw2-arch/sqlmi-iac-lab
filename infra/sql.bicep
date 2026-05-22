// main.bicep equivalent - orchestrates SQL infrastructure modules
// Note: filename remains sql.bicep for now to avoid breaking existing deploy commands.

@description('SQL Server name (globally unique). Defaults to a deterministic name derived from the resource group.')
param sqlServerName string = 'sqliac-dev-${uniqueString(resourceGroup().id)}'

@description('Azure region for resources. Restricted to regions known to allow SQL DB provisioning on free-tier subscriptions.')
@allowed([
  'centralus'
  'eastus2'
  'westus3'
  'southcentralus'
  'northcentralus'
])
param location string = 'centralus'

@description('SQL admin login')
param sqlAdminLogin string

@description('SQL admin password')
@secure()
param sqlAdminPassword string

@description('Database name')
param databaseName string = 'appdb'

@description('Developer IP addresses to allow through the firewall (dev only).')
param developerIpAddresses array = []

module sqlServerModule 'modules/sqlServer.bicep' = {
  name: 'sqlServerDeployment'
  params: {
    sqlServerName: sqlServerName
    location: location
    sqlAdminLogin: sqlAdminLogin
    sqlAdminPassword: sqlAdminPassword
    databaseName: databaseName
  }
}

output sqlServerFqdn string = sqlServerModule.outputs.sqlServerFqdn
output sqlServerPrincipalId string = sqlServerModule.outputs.sqlServerPrincipalId
output sqlServerName string = sqlServerModule.outputs.sqlServerName


