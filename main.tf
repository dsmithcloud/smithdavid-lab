locals {
  settings = yamldecode(file("./settings.yaml"))
}

resource "azurerm_resource_group" "rg-vwan" {
  name     = "rg-ussc-core-vwan"
  location = "South Central US"
}

resource "azurerm_resource_group" "rg-network" {
  name     = "rg-global-core-network"
  location = "South Central US"
}