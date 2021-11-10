resource "azurerm_public_ip" "bastion-pip" {
  name                = "bastion-core-ussc-nic"
  location            = azurerm_resource_group.rg-network.location
  resource_group_name = azurerm_resource_group.rg-network.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-core-ussc-host"
  location            = azurerm_resource_group.rg-network.location
  resource_group_name = azurerm_resource_group.rg-network.name

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = azurerm_subnet.subnet-ussc-core-bastion.id
    public_ip_address_id = azurerm_public_ip.bastion-pip.id
  }

  tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"
}