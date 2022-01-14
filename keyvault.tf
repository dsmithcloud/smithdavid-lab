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


resource "azurerm_key_vault_access_policy" "ussc-core-kv1" {
  key_vault_id = azurerm_key_vault.ussc-core-kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get", "Set"
  ]

  storage_permissions = [
    "Get",
  ]

  certificate_permissions = [
    "Get",
  ]
}


resource "azurerm_key_vault_access_policy" "ussc-core-kv2" {
  key_vault_id = azurerm_key_vault.ussc-core-kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "0bbb40c6-f6d6-4c9b-9760-d8c62dde5978"

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get", "List"
  ]

  storage_permissions = [
    "Get",
  ]

  certificate_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault_secret" "ussc-admin_ospassword" {
  name         = "admin-ospassword"
  value        = var.admin_ospassword
  key_vault_id = azurerm_key_vault.ussc-core-kv.id
  depends_on = [
    azurerm_key_vault.ussc-core-kv,
    azurerm_key_vault_access_policy.ussc-core-kv1,
    azurerm_key_vault_access_policy.ussc-core-kv2
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

resource "azurerm_key_vault_access_policy" "euw-core-kv1" {
  key_vault_id = azurerm_key_vault.euw-core-kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get", "Set"
  ]

  storage_permissions = [
    "Get",
  ]

  certificate_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault_access_policy" "euw-core-kv2" {
  key_vault_id = azurerm_key_vault.euw-core-kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "0bbb40c6-f6d6-4c9b-9760-d8c62dde5978"

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get", "List"
  ]

  storage_permissions = [
    "Get",
  ]

  certificate_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault_secret" "euw-admin_ospassword" {
  name         = "admin-ospassword"
  value        = var.admin_ospassword
  key_vault_id = azurerm_key_vault.euw-core-kv.id
  depends_on = [
    azurerm_key_vault.euw-core-kv,
    azurerm_key_vault_access_policy.euw-core-kv1,
    azurerm_key_vault_access_policy.euw-core-kv2
  ]
}

