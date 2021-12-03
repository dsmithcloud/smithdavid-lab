module "cloudshell-vnet" {
  source                       = "dsmithcloud/cloudshell-vnet/azurerm"
  version                      = "v1.0.1"
  existing-vnet-resource-group = azurerm_resource_group.rg-network.name
  existing-vnet-name           = azurerm_virtual_network.vnet-core-ussc.name
  ACI-OID                      = "88536fb9-d60a-4aee-8195-041425d6e927"
  container-subnet-name        = "subnet-ussc-core-vnet1-cloudshell-10.0.0.128_27"
  container-subnet-prefix      = ["10.0.0.128/27"]
  relay-subnet-name            = "subnet-ussc-core-vnet1-relay-10.0.0.192_26"
  relay-subnet-prefix          = ["10.0.0.192/26"]
  relay-namespace-name         = "subnet-ussc-core-vnet1-relay-namespace"
  storageaccount-name          = "storusscshell01"
  tags                         = merge(local.settings.common_tags, local.settings.core_tags)
}

resource "azurerm_network_security_group" "nsg-cloudshell" {
  name                = "subnet-ussc-core-vnet1-cloudshell-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = azurerm_resource_group.rg-network.location
}

resource "azurerm_subnet_network_security_group_association" "nsg-cloudshell" {
  subnet_id                 = module.cloudshell-vnet.container-subnet-id
  network_security_group_id = azurerm_network_security_group.nsg-cloudshell.id
}

resource "azurerm_network_security_group" "nsg-relay" {
  name                = "subnet-ussc-core-vnet1-relay-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = azurerm_resource_group.rg-network.location
}

resource "azurerm_subnet_network_security_group_association" "nsg-relay" {
  subnet_id                 = module.cloudshell-vnet.relay-subnet-id
  network_security_group_id = azurerm_network_security_group.nsg-relay.id
}
