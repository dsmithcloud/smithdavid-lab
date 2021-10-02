resource "azurerm_storage_account" "storage" {
  name                     = local.settings.naming.admstoragename
  resource_group_name      = azurerm_resource_group.cloudadmin.name
  location                 = azurerm_resource_group.cloudadmin.location
  account_tier             = local.settings.storage_account.account_tier
  access_tier              = local.settings.storage_account.access_tier
  account_replication_type = local.settings.storage_account.replication_type
  account_kind             = local.settings.storage_account.kind
  tags                     = local.settings.tags
  count                    = local.settings.enable_adminstorageacct ? 1 : 0
}


