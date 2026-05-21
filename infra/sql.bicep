// main.bicep equivalent - orchestrates SQL infrastructure modules
// Note: filename remains sql.bicep for now to avoid breaking existing deploy commands.

@description('SQL Server name (globally unique)')
param sqlServerName string

@description('Azure region')
param location string = resourceGroup().location

@description('SQL admin login')
param sqlAdminLogin string

@description('SQL admin password')
@secure()
param sqlAdminPassword string

@description('Database name')
param databaseName string = 'appdb'

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
