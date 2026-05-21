# sqlmi-iac-lab
IaC lab: Azure SQL with CMK/TDE via Bicep + Azure Pipelines
# sqlmi-iac-lab

Infrastructure-as-Code lab for deploying Azure SQL Database with Bicep,
progressing toward a full database DevOps pipeline with customer-managed
key (CMK) TDE, multi-environment parameterization, and CI/CD via Azure
Pipelines.

## Phase 1 — Single Azure SQL DB via Bicep ✅

Deployed a serverless Azure SQL Database (GP_S_Gen5, 2 GB max, 60-min
auto-pause) with a logical SQL server and firewall rule allowing Azure
services. SQL server has a system-assigned managed identity ready for
Phase 2's Key Vault integration.

### Deployment

```powershell
az group create --name rg-sqliac-dev --location centralus

az deployment group create `
  --resource-group rg-sqliac-dev `
  --template-file infra/sql.bicep `
  --parameters sqlServerName=sqliac-dev-$(Get-Random) `
               sqlAdminLogin=sqladmin `
               sqlAdminPassword='<strong-password>'
```

### Verified

- 3 resources provisioned in `centralus` (server, database, firewall rule)
- Connection from `Invoke-Sqlcmd` returns `Microsoft SQL Azure (RTM) - 12.0.2000.8`

## Known Gotchas / Phase 1.5 Hardening Backlog

- **Region restrictions:** `westus2` and `eastus` returned `ProvisioningDisabled`
  for SQL DB on free-tier subscriptions. `centralus` worked. Future: parameterize
  `location` with `@allowed` regions.
- **Developer firewall access:** template's firewall rule only allows Azure
  services. Connecting from a dev machine requires adding the dev IP via CLI.
  Future: parameterize a list of developer IPs in `dev.bicepparam` and add them
  as firewall rules.
- **Admin password handling:** currently passed via CLI parameter (visible in
  shell history). Future: source from Key Vault reference or pipeline secret.

## Phase 2 — Coming next

Add Key Vault with purge protection, generate an RSA key, grant the SQL
server's managed identity Crypto Service Encryption User rights, and configure
the database's TDE protector to use the customer-managed key. Mirrors a real
production architecture pattern for HIPAA/HITRUST environments.