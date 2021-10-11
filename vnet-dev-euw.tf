#================    VNET    ================
resource "azurerm_virtual_network" "vnet-dev-euw" {
  name = "vnet-dev-euw-10.1.2.0_25"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "westeurope"
  address_space       = ["10.1.2.0/25"]
  dns_servers         = ["10.1.0.36", "10.1.0.37"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos-plan.id
    enable = true
  }

tags = "${merge(local.settings.common_tags, local.settings.dev_tags)}"
}

resource "azurerm_subnet" "subnet-euw-dev-fe" {
    name           = "subnet-euw-dev-vnet1-fe-10.1.2.0_27"
    address_prefixes = ["10.1.2.0/27"]
    resource_group_name = azurerm_resource_group.rg-network.name
    virtual_network_name = azurerm_virtual_network.vnet-dev-euw.name
    service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "subnet-euw-dev-be" {
    name           = "subnet-euw-dev-vnet1-be-10.1.2.32_27"
    address_prefixes = ["10.1.2.32/27"]
    resource_group_name = azurerm_resource_group.rg-network.name
    virtual_network_name = azurerm_virtual_network.vnet-dev-euw.name
    service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}


#================    NSGs    ================
resource "azurerm_network_security_group" "nsg-euw-dev-fe" {
  name                = "subnet-euw-dev-vnet1-fe-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "westeurope"
}

resource "azurerm_subnet_network_security_group_association" "nsg-euw-dev-fe" {
  subnet_id                 = azurerm_subnet.subnet-euw-dev-fe.id
  network_security_group_id = azurerm_network_security_group.nsg-euw-dev-fe.id
}

resource "azurerm_network_security_group" "nsg-euw-dev-be" {
  name                = "subnet-euw-dev-vnet1-be-nsg"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = "westeurope"
}

resource "azurerm_subnet_network_security_group_association" "nsg-euw-dev-be" {
  subnet_id                 = azurerm_subnet.subnet-euw-dev-be.id
  network_security_group_id = azurerm_network_security_group.nsg-euw-dev-be.id
}

#================    VWAN Connection    ================
resource "azurerm_virtual_hub_connection" "vnet-dev-euw-hub2-connection" {
  name                      = "vnet-dev-euw-hub2-connection"
  virtual_hub_id            = azurerm_virtual_hub.vwan-euw-hub1.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-dev-euw.id
}
