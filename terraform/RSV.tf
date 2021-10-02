resource "azurerm_recovery_services_vault" "rsvault" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.rsv}"
  location            = azurerm_resource_group.backup.location
  resource_group_name = azurerm_resource_group.backup.name
  sku                 = local.settings.rsv.sku
  count               = local.settings.enable_rsv ? 1 : 0
  tags                = local.settings.tags
}