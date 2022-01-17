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

resource "azurerm_resource_group" "ADDS-ussc" {
  name     = "rg-ussc-core-adds"
  location = "South Central US"
}

resource "azurerm_resource_group" "ADDS-euw" {
  name     = "rg-euw-core-adds"
  location = "West Europe"
}

resource "azurerm_resource_group" "ussc-admin" {
  name     = "rg-ussc-core-admin"
  location = "South Central US"
}

resource "azurerm_resource_group" "euw-admin" {
  name     = "rg-euw-core-admin"
  location = "West Europe"
}

resource "azurerm_resource_group" "ussc-law" {
  name     = "rg-ussc-core-log"
  location = "South Central US"
}

resource "azurerm_resource_group" "euw-law" {
  name     = "rg-euw-core-log"
  location = "West Europe"
}

resource "azurerm_resource_group" "ckalab-ussc" {
  name     = "rg-ussc-dev-ckalab"
  location = "South Central US"
}


