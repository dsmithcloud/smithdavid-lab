resource "azurerm_network_security_group" "addsnsg" {
  name                  = "${azurerm_subnet.addssubnet[0].name}-${local.settings.naming.resourcelabels.nsg}"
  location              = azurerm_resource_group.networking.location
  resource_group_name   = azurerm_resource_group.networking.name
  count                 = local.settings.networking.addssubnet.enabled? 1 : 0
  tags                  = local.settings.tags
}

resource "azurerm_subnet_network_security_group_association" "addsnsgassociation" {
  subnet_id                 = azurerm_subnet.addssubnet[0].id
  network_security_group_id = azurerm_network_security_group.addsnsg[0].id
  count                     = local.settings.networking.addssubnet.enabled? 1 : 0
}

resource "azurerm_network_security_group" "nsg02" {
  name                  = "${azurerm_subnet.mgmtsubnet[0].name}-${local.settings.naming.resourcelabels.nsg}"
  location              = azurerm_resource_group.networking.location
  resource_group_name   = azurerm_resource_group.networking.name
  count                 = local.settings.networking.mgmtsubnet.enabled? 1 : 0
  tags                  = local.settings.tags
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation2" {
  subnet_id                 = azurerm_subnet.mgmtsubnet[0].id
  network_security_group_id = azurerm_network_security_group.nsg02[0].id
  count                     = local.settings.networking.mgmtsubnet.enabled? 1 : 0
}

# ASR test network NSGs

resource "azurerm_network_security_group" "asr_testnsg" {
  name                  = "${azurerm_subnet.asr_testsubnet[0].name}-${local.settings.naming.resourcelabels.nsg}"
  location              = azurerm_resource_group.networking.location
  resource_group_name   = azurerm_resource_group.networking.name
  count                 = local.settings.enable_asrtestvnet ? 1 : 0
}

resource "azurerm_subnet_network_security_group_association" "asr-test-nsg-assoc" {
  subnet_id                 = azurerm_subnet.asr_testsubnet[0].id
  network_security_group_id = azurerm_network_security_group.asr_testnsg[0].id
  count                     = local.settings.enable_asrtestvnet ? 1 : 0
}