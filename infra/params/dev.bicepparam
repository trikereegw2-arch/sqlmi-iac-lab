using '../sql.bicep'

param location = 'centralus'
param sqlAdminLogin = 'sqladmin'
param sqlAdminPassword = readEnvironmentVariable('SQL_ADMIN_PASSWORD')
param databaseName = 'appdb'
