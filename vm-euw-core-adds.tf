resource "azurerm_network_interface" "nic-euw-adds" {
  name                = "vmeuwcoreadds${count.index + 1}-NIC"
  location            = azurerm_resource_group.ADDS-euw.location
  resource_group_name = azurerm_resource_group.ADDS-euw.name
  count               = length(var.euw-adds-ip_address)

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-euw-core-adds.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.euw-adds-ip_address[count.index]
  }

  tags = merge(local.settings.common_tags, local.settings.core_tags)
}

resource "azurerm_availability_set" "avset-euw-adds" {
  name                = "vmeuwcoreadds-avset"
  location            = azurerm_resource_group.ADDS-euw.location
  resource_group_name = azurerm_resource_group.ADDS-euw.name

  tags = merge(local.settings.common_tags, local.settings.core_tags)
}

resource "azurerm_virtual_machine" "vm-euw-adds" {
  name                             = "vmeuwcoreadds${count.index + 1}"
  location                         = azurerm_resource_group.ADDS-euw.location
  resource_group_name              = azurerm_resource_group.ADDS-euw.name
  network_interface_ids            = [element(azurerm_network_interface.nic-euw-adds.*.id, count.index)]
  vm_size                          = "Standard_D2s_v3"
  availability_set_id              = azurerm_availability_set.avset-euw-adds.id
  delete_data_disks_on_termination = true
  count                            = length(var.euw-adds-ip_address)

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  os_profile {
    computer_name  = "vmeuwcoreadds${count.index + 1}"
    admin_username = "azadmin"
    admin_password = var.admin_ospassword
  }
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  storage_os_disk {
    name              = "vmeuwcoreadds${count.index + 1}-OSDisk"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_data_disk {
    name              = "vmeuwcoreadds${count.index + 1}-DataDisk01"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 64
    lun               = 0
    caching           = "None"
  }

  tags = merge(local.settings.common_tags, local.settings.core_tags)
}

resource "azurerm_virtual_machine_extension" "euw-iaasantimalware" {
  name                       = "IaaSAntimalware"
  virtual_machine_id         = azurerm_virtual_machine.vm-euw-adds[count.index].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.5.7.24"
  auto_upgrade_minor_version = true
  #enable_automatic_upgrades  = true
  count = length(var.euw-adds-ip_address)

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

resource "azurerm_virtual_machine_extension" "euw-mma" {
  name                       = "MicrosoftMonitoringAgent"
  virtual_machine_id         = azurerm_virtual_machine.vm-euw-adds[count.index].id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0.18064.0"
  auto_upgrade_minor_version = true
  #enable_automatic_upgrades  = true
  count = length(var.euw-adds-ip_address)

  settings = <<SETTINGS
        {
          "workspaceId": "${azurerm_log_analytics_workspace.euw-core-log.workspace_id}"
        }
        SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${azurerm_log_analytics_workspace.euw-core-log.primary_shared_key}"
        }
        PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "euw-netwatch" {
  name                       = "NetworkWatcher"
  virtual_machine_id         = azurerm_virtual_machine.vm-euw-adds[count.index].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
  #enable_automatic_upgrades  = true
  count = length(var.euw-adds-ip_address)
}


