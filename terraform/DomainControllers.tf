resource "azurerm_network_interface" "adds_nic" {
  name                = "${local.settings.naming.dcnameprefix}${count.index + 1}-${local.settings.naming.resourcelabels.nic}"
  location            = azurerm_resource_group.ADDS.location
  resource_group_name = azurerm_resource_group.ADDS.name
  count               = local.settings.adds_dccount

  ip_configuration {
    name                          = local.settings.adds.ipconfigname
    subnet_id                     = azurerm_subnet.addssubnet[0].id
    private_ip_address_allocation = local.settings.adds.ipallocationtype
    private_ip_address = local.settings.adds.dc_ipaddresses[count.index]
  }
  
  tags = local.settings.tags
}

resource "azurerm_availability_set" "avset" {
  name                = "${local.settings.naming.cloudprefix}-${local.settings.naming.locationcode}-${local.settings.naming.envlabel}-${local.settings.naming.resourcelabels.adds}-${local.settings.naming.resourcelabels.avset}"
  location            = local.settings.location
  resource_group_name = azurerm_resource_group.ADDS.name
  managed             = local.settings.adds.avset_managed
  count               = local.settings.adds_dccount >= 1 ? 1 : 0
  tags                = local.settings.tags
}

resource "azurerm_virtual_machine" "domain_controller" {
  name                             = "${local.settings.naming.dcnameprefix}${count.index + 1}"
  location                         = azurerm_resource_group.ADDS.location
  resource_group_name              = azurerm_resource_group.ADDS.name
  network_interface_ids            = [element(azurerm_network_interface.adds_nic.*.id, count.index)]
  vm_size                          = local.settings.adds.vmsize
  availability_set_id              = azurerm_availability_set.avset[0].id
  delete_data_disks_on_termination = local.settings.adds.deletedatadisk
  count                            = local.settings.adds_dccount

  storage_image_reference {
    publisher = local.settings.adds.publisher
    offer     = local.settings.adds.offer
    sku       = local.settings.adds.skuwindows
    version   = local.settings.adds.version
  }
  os_profile {
    computer_name  = "${local.settings.naming.dcnameprefix}${count.index + 1}"
    admin_username = local.settings.adds.os_adminusername
    admin_password = var.adds_ospassword
  }
  os_profile_windows_config {
    provision_vm_agent        = local.settings.adds.provision_vm_agent
    enable_automatic_upgrades = local.settings.adds.enable_automatic_upgrades
  }
  storage_os_disk {
    name              = "${local.settings.naming.dcnameprefix}${count.index + 1}-${local.settings.naming.resourcelabels.osdisk}"
    create_option     = local.settings.adds.create_option
    managed_disk_type = local.settings.adds.managed_disk_type
  }
  storage_data_disk {
    name              = "${local.settings.naming.dcnameprefix}${count.index + 1}-${local.settings.naming.resourcelabels.datadisk}01"
    create_option     = "Empty"
    managed_disk_type = local.settings.adds.managed_disk_type
    disk_size_gb      = 64
    lun               = 0
    caching           = "None"
  }

  tags = local.settings.tags
}

resource "azurerm_virtual_machine_extension" "mma" {
  name                 = local.settings.adds.extension1.name
  virtual_machine_id   = azurerm_virtual_machine.domain_controller[count.index].id
  publisher            = local.settings.adds.extension1.publisher
  type                 = local.settings.adds.extension1.type
  type_handler_version = local.settings.adds.extension1.type_handler_version
  count                = local.settings.adds.extension1.enabled ? local.settings.adds_dccount : 0

  settings = <<SETTINGS
        {
          "workspaceId": "${azurerm_log_analytics_workspace.loganalytics[0].workspace_id}"
        }
        SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${azurerm_log_analytics_workspace.loganalytics[0].primary_shared_key}"
        }
        PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "iaasantimalware" {
  name                       = local.settings.adds.extension2.name
  virtual_machine_id         = azurerm_virtual_machine.domain_controller[count.index].id
  publisher                  = local.settings.adds.extension2.publisher
  type                       = local.settings.adds.extension2.type
  type_handler_version       = local.settings.adds.extension2.type_handler_version
  auto_upgrade_minor_version = local.settings.adds.extension2.upgrade
  count                      = local.settings.adds.extension2.enabled ? local.settings.adds_dccount : 0

  settings = <<SETTINGS
    {
      "AntimalwareEnabled": true,
      "RealtimeProtectionEnabled": "true",
      "ScheduledScanSettings": {
      "isEnabled": "true",
      "day": "1",
      "time": "120",
      "scanType": "Quick"
        },
      "Exclusions": {
      "Extensions": "",
      "Paths": "",
      "Processes": ""
        }
      }
SETTINGS
}