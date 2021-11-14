resource "azurerm_storage_account" "storussccoreadmin01" {
  name                     = "storussccoreadmin01"
  resource_group_name      = azurerm_resource_group.ussc-admin.name
  location                 = azurerm_resource_group.ussc-admin.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge(local.settings.common_tags, local.settings.core_tags, { ms-resource-usage = "azure-cloud-shell" })
}

resource "azurerm_storage_share" "dsmith-shell" {
  name                 = "dsmith-shell"
  storage_account_name = azurerm_storage_account.storussccoreadmin01.name
  quota                = 50

  #   acl {
  #     id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"

  #     access_policy {
  #       permissions = "rwdl"
  #       start       = "2019-07-02T09:38:21.0000000Z"
  #       expiry      = "2019-07-02T10:38:21.0000000Z"
  #     }
  #   }
}

resource "azurerm_storage_account" "storeuwcoreadmin01" {
  name                     = "storeuwcoreadmin01"
  resource_group_name      = azurerm_resource_group.euw-admin.name
  location                 = azurerm_resource_group.euw-admin.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge(local.settings.common_tags, local.settings.core_tags, { ms-resource-usage = "azure-cloud-shell" })
}
