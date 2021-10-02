locals {
  settings = yamldecode(file("../environments/${terraform.workspace}/settings.yaml"))
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "adds_ospassword" {
  type = string
}

resource "azurerm_resource_group" "networking" {
  name     = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.rglabels.networking}-${local.settings.naming.rglabels.rgsuffix}"
  location = local.settings.location
  tags     = local.settings.tags
}

resource "azurerm_resource_group" "cloudadmin" {
   name     = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.rglabels.admin}-${local.settings.naming.rglabels.rgsuffix}"
   location = local.settings.location
   tags     = local.settings.tags
}

resource "azurerm_resource_group" "monitoring" {
   name     = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.rglabels.monitoring}-${local.settings.naming.rglabels.rgsuffix}"
   location = local.settings.location
   tags     = local.settings.tags
}

resource "azurerm_resource_group" "backup" {
   name     = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.rglabels.backup}-${local.settings.naming.rglabels.rgsuffix}"
   location = local.settings.location
   tags     = local.settings.tags
}

resource "azurerm_resource_group" "ADDS" {
   name     = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.rglabels.adds}-${local.settings.naming.rglabels.rgsuffix}"
   location = local.settings.location
   tags     = local.settings.tags
}

/*
resource "azurerm_management_lock" "rglock" {
    name = "${local.settings.project}-${local.settings.env}-${local.settings.location}"
    scope = "${azurerm_resource_group.hub.id}"
    lock_level = local.settings.lock_level
    notes = local.settings.notes
}
*/