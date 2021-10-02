resource "azurerm_virtual_network" "net-vnet" {
  name                = replace("${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.vnet}-001_${local.settings.networking.address_space[0]}", "/", "_")
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  address_space       = local.settings.networking.address_space
  tags = local.settings.tags
}

resource "azurerm_subnet" "gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.net-vnet.name
  address_prefixes     = local.settings.networking.gatewaysubnet_prefixes
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  count                = local.settings.networking.creategatewaysubnet ? 1 : 0
}

resource "azurerm_subnet" "firewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.net-vnet.name
  address_prefixes     = local.settings.networking.firewallsubnet.address_prefixes
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  count                = local.settings.networking.firewallsubnet.enabled ? 1 : 0
}

resource "azurerm_subnet" "bastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.net-vnet.name
  address_prefixes     = local.settings.networking.bastionsubnet.address_prefixes
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  count                = local.settings.networking.bastionsubnet.enabled ? 1 : 0
}

resource "azurerm_subnet" "addssubnet" {
  name                 = replace("${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.networking.addssubnet.namelabel}-${local.settings.naming.resourcelabels.subnet}_${local.settings.networking.addssubnet.address_prefixes[0]}", "/", "_")
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.net-vnet.name
  address_prefixes     = local.settings.networking.addssubnet.address_prefixes
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  count                = local.settings.networking.addssubnet.enabled? 1 : 0
}

resource "azurerm_subnet" "mgmtsubnet" {
  name                 = replace("${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.networking.mgmtsubnet.namelabel}-${local.settings.naming.resourcelabels.subnet}_${local.settings.networking.mgmtsubnet.address_prefixes[0]}", "/", "_")
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.net-vnet.name
  address_prefixes     = local.settings.networking.mgmtsubnet.address_prefixes
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  count                = local.settings.networking.mgmtsubnet.enabled ? 1 : 0
}

resource "azurerm_management_lock" "vnetlock" {
  name       = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.vnet}-${local.settings.naming.resourcelabels.lock}"
  scope      = azurerm_virtual_network.net-vnet.id
  lock_level = local.settings.networking.lock_level
  notes      = local.settings.networking.notes
  count      = local.settings.networking.enablelock ? 1 : 0
}

# IP Prefix

resource "azurerm_public_ip_prefix" "hub-pip-prefix" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.publicip_prefix}"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  prefix_length       = local.settings.pip_prefix.prefix_length
  count               = local.settings.enable_pipprefix ? 1 : 0
  tags                = local.settings.tags
}

# ASR testing VNETs

resource "azurerm_virtual_network" "asr_testvnet" {
  name                = replace("${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.asr_testvnet.namelabel}-${local.settings.naming.resourcelabels.vnet}-001_${local.settings.asr_testvnet.address_space[0]}", "/", "_")
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  address_space       = local.settings.asr_testvnet.address_space
  count               = local.settings.enable_asrtestvnet ? 1 : 0
}

resource "azurerm_subnet" "asr_bastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.asr_testvnet[0].name
  address_prefixes     = local.settings.asr_testvnet.bastionsubnet_prefixes
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  count                = local.settings.enable_asrtestvnet? 1 : 0
}

resource "azurerm_subnet" "asr_testsubnet" {
  name                 = replace("${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.asr_testvnet.namelabel}-${local.settings.naming.resourcelabels.subnet}_${local.settings.asr_testvnet.testsubnet_prefixes[0]}", "/", "_")
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.asr_testvnet[0].name
  address_prefixes     = local.settings.asr_testvnet.testsubnet_prefixes
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  count                = local.settings.enable_asrtestvnet? 1 : 0
}