locals {
  settings = yamldecode(file("./settings.yaml"))
}

resource "azurerm_resource_group" "rg-vwan" {
  name     = "rg-euw-core-vwan"
  location = "West Europe"
}