resource "azurerm_public_ip" "vng-pip" {
  name                 = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.vng}-${local.settings.naming.resourcelabels.publicip}"
  location             = azurerm_resource_group.networking.location
  resource_group_name  = azurerm_resource_group.networking.name
  sku                  = local.settings.virtualnetworkgateway.pip_sku
  allocation_method    = local.settings.virtualnetworkgateway.pip_alloc-method
  #public_ip_prefix_id  = azurerm_public_ip_prefix.hub-pip-prefix[0].id
  count                = local.settings.enable_vng ? 1 : 0
  tags                 = local.settings.tags
}

resource "azurerm_virtual_network_gateway" "vng" {
  name                =  "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.vng}"
  location            =  azurerm_resource_group.networking.location
  resource_group_name =  azurerm_resource_group.networking.name
  type                =  local.settings.virtualnetworkgateway.gateway-type
  vpn_type            =  local.settings.virtualnetworkgateway.vpn-type
  enable_bgp          =  local.settings.virtualnetworkgateway.enable-bgp
  sku                 =  local.settings.virtualnetworkgateway.gateway-sku
  count               =  local.settings.enable_vng ? 1 : 0

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vng-pip[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gatewaysubnet[0].id
  }

  tags =  local.settings.tags
}