variable "ussc-adds-ip_address" {
  type = list(string)
  default = ["10.0.0.36","10.0.0.37"]  
}

resource "azurerm_network_interface" "nic-ussc-adds" {
  name                = "vmussccoreadds${count.index + 1}-NIC"
  location            = azurerm_resource_group.ADDS-ussc.location
  resource_group_name = azurerm_resource_group.ADDS-ussc.name
  count               = 2

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-ussc-core-adds.id
    private_ip_address_allocation = "Static"
    private_ip_address = var.ussc-adds-ip_address[count.index]
  }
  
  tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"
}

resource "azurerm_availability_set" "avset-ussc-adds" {
  name                = "vmussccoreadds-avset"
  location            = azurerm_resource_group.ADDS-ussc.location
  resource_group_name = azurerm_resource_group.ADDS-ussc.name

  tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"
}

resource "azurerm_virtual_machine" "vm-ussc-adds" {
  name                             = "vmussccoreadds${count.index + 1}"
  location                         = azurerm_resource_group.ADDS-ussc.location
  resource_group_name              = azurerm_resource_group.ADDS-ussc.name
  network_interface_ids            = [element(azurerm_network_interface.nic-ussc-adds.*.id, count.index)]
  vm_size                          = "Standard_D2s_v3"
  availability_set_id              = azurerm_availability_set.avset-ussc-adds.id
  delete_data_disks_on_termination = true
  count                            = 2

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  os_profile {
    computer_name  = "vmussccoreadds${count.index + 1}"
    admin_username = "azadmin"
    admin_password = "#mRjNQ2@47Ch"
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

  tags = "${merge(local.settings.common_tags, local.settings.core_tags)}"
}

resource "azurerm_virtual_machine_extension" "ussc-iaasantimalware" {
  name                       = "IaaSAntimalware"
  virtual_machine_id         = azurerm_virtual_machine.vm-ussc-adds[count.index].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  count                      = 2

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
  count                = 2

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