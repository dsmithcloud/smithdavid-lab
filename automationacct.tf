resource "azurerm_automation_account" "ussc-automation" {
  name                = "ussc-core-aa"
  location            = azurerm_resource_group.ussc-admin.location
  resource_group_name = azurerm_resource_group.ussc-admin.name

  sku_name = "Basic"

  tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"
}

resource "azurerm_automation_account" "euw-automation" {
  name                = "euw-core-aa"
  location            = azurerm_resource_group.euw-admin.location
  resource_group_name = azurerm_resource_group.euw-admin.name

  sku_name = "Basic"

  tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"
}