resource "azurerm_automation_account" "autoaccount" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.automationacct}"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku_name            = local.settings.automationacct.sku_name
  count               = local.settings.enable_automationacct ? 1 : 0
  tags                = local.settings.tags
}