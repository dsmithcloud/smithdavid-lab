 resource "azurerm_key_vault" "keyvault" {
  name                        = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.keyvault}01"
  location                    = azurerm_resource_group.cloudadmin.location
  resource_group_name         = azurerm_resource_group.cloudadmin.name
  enabled_for_disk_encryption = local.settings.keyvault.enabled_for_disk_encryption
  tenant_id                   = var.tenant_id
  count                       = local.settings.enable_keyvault ? 1 : 0
  sku_name                    = local.settings.keyvault.sku_name

  access_policy {
    tenant_id =  var.tenant_id
    object_id =  var.subscription_id
    
    key_permissions = [
      local.settings.keyvault.key_permissions,
    ]

    secret_permissions = [
      local.settings.keyvault.secret_permissions,
    ]

    storage_permissions = [
      local.settings.keyvault.storage_permissions,
    ]
  }

  network_acls {
    default_action = local.settings.keyvault.default_action
    bypass         = local.settings.keyvault.bypass
  }

tags = local.settings.tags

}