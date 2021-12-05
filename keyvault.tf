data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "ussc-core-kv" {
  name                            = "ussc-core-kv"
  resource_group_name             = azurerm_resource_group.ussc-admin.name
  location                        = azurerm_resource_group.ussc-admin.location
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 14
  purge_protection_enabled        = true

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "ussc-core-kv" {
  key_vault_id = azurerm_key_vault.ussc-core-kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault" "euw-core-kv" {
  name                            = "euw-core-kv"
  resource_group_name             = azurerm_resource_group.euw-admin.name
  location                        = azurerm_resource_group.euw-admin.location
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 14
  purge_protection_enabled        = true

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "euw-core-kv" {
  key_vault_id = azurerm_key_vault.euw-core-kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}
