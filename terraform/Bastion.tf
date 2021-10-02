resource "azurerm_public_ip" "bastion-pip" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.bastion}-${local.settings.naming.resourcelabels.publicip}"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  allocation_method   = "Static"
  sku                 = "Standard"
  #public_ip_prefix_id = azurerm_public_ip_prefix.hub-pip-prefix[0].id
  count               = local.settings.enable_bastion ? 1 : 0
  tags                = local.settings.tags
}

resource "azurerm_bastion_host" "bastion" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.bastion}"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  count               = local.settings.enable_bastion ? 1 : 0

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = azurerm_subnet.bastionsubnet[0].id
    public_ip_address_id = azurerm_public_ip.bastion-pip[0].id
  }

  tags = local.settings.tags
}

resource "azurerm_public_ip" "asr_bastion-pip" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.asr_testvnet.namelabel}-${local.settings.naming.resourcelabels.bastion}-${local.settings.naming.resourcelabels.publicip}"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  allocation_method   = "Static"
  sku                 = "Standard"
  #public_ip_prefix_id = azurerm_public_ip_prefix.hub-pip-prefix[0].id
  count               = local.settings.enable_asrtestvnet_bastion ? 1 : 0
  tags                = local.settings.tags
}

resource "azurerm_bastion_host" "asr_bastion" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.asr_testvnet.namelabel}-${local.settings.naming.resourcelabels.bastion}"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  count               = local.settings.enable_asrtestvnet_bastion ? 1 : 0

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = azurerm_subnet.asr_bastionsubnet[0].id
    public_ip_address_id = azurerm_public_ip.asr_bastion-pip[0].id
  }

  tags = local.settings.tags
}