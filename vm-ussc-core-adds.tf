resource "azurerm_network_interface" "nic-ussc-adds" {
  name                = "vmussccoreadds${count.index + 1}-NIC"
  location            = azurerm_resource_group.ADDS-ussc.location
  resource_group_name = azurerm_resource_group.ADDS-ussc.name
  #count               = length(var.ussc-adds-ip_address)
  count = length(local.settings.adds.ussc-adds-ip_address)

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-ussc-core-adds.id
    private_ip_address_allocation = "Static"
    #private_ip_address            = var.ussc-adds-ip_address[count.index]
    private_ip_address = local.settings.adds.ussc-adds-ip_address[count.index]
  }

  tags = merge(local.settings.common_tags, local.settings.core_tags)
}

resource "azurerm_availability_set" "avset-ussc-adds" {
  name                = "vmussccoreadds-avset"
  location            = azurerm_resource_group.ADDS-ussc.location
  resource_group_name = azurerm_resource_group.ADDS-ussc.name

  tags = merge(local.settings.common_tags, local.settings.core_tags)
}

resource "azurerm_virtual_machine" "vm-ussc-adds" {
  name                             = "vmussccoreadds${count.index + 1}"
  location                         = azurerm_resource_group.ADDS-ussc.location
  resource_group_name              = azurerm_resource_group.ADDS-ussc.name
  network_interface_ids            = [element(azurerm_network_interface.nic-ussc-adds.*.id, count.index)]
  vm_size                          = local.settings.adds.vm_size
  availability_set_id              = azurerm_availability_set.avset-ussc-adds.id
  delete_data_disks_on_termination = true
  count                            = length(local.settings.adds.ussc-adds-ip_address)

  storage_image_reference {
    publisher = local.settings.adds.publisher
    offer     = local.settings.adds.offer
    sku       = local.settings.adds.sku
    version   = local.settings.adds.version
  }
  os_profile {
    computer_name  = "vmussccoreadds${count.index + 1}"
    admin_username = local.settings.adds.admin_username
    admin_password = azurerm_key_vault_secret.ussc-admin_ospassword.value
  }
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  storage_os_disk {
    name              = "vmussccoreadds${count.index + 1}-OSDisk"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_data_disk {
    name              = "vmussccoreadds${count.index + 1}-DataDisk01"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 64
    lun               = 0
    caching           = "None"
  }

  tags = merge(local.settings.common_tags, local.settings.core_tags)
}

resource "azurerm_virtual_machine_extension" "ussc-iaasantimalware" {
  name                       = "IaaSAntimalware"
  virtual_machine_id         = azurerm_virtual_machine.vm-ussc-adds[count.index].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  count                      = length(local.settings.adds.ussc-adds-ip_address)

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

resource "azurerm_virtual_machine_extension" "ussc-mma" {
  name                 = "MicrosoftMonitoringAgent"
  virtual_machine_id   = azurerm_virtual_machine.vm-ussc-adds[count.index].id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"
  count                = length(local.settings.adds.ussc-adds-ip_address)

  settings = <<SETTINGS
        {
          "workspaceId": "${azurerm_log_analytics_workspace.ussc-core-log.workspace_id}"
        }
        SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${azurerm_log_analytics_workspace.ussc-core-log.primary_shared_key}"
        }
        PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "ussc-netwatch" {
  name                       = "NetworkWatcher"
  virtual_machine_id         = azurerm_virtual_machine.vm-ussc-adds[count.index].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  count                      = length(local.settings.adds.ussc-adds-ip_address)
}


