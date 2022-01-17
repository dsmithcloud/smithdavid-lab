resource "azurerm_network_interface" "nic-ussc-ckalab" {
  name                = "vmusscckalab${count.index + 1}-NIC"
  location            = azurerm_resource_group.ckalab-ussc.location
  resource_group_name = azurerm_resource_group.ckalab-ussc.name
  #count               = length(var.ussc-ckalab-ip_address)
  count = length(local.settings.ckalab.ussc-ckalab-ip_address)

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-ussc-dev-fe.id
    private_ip_address_allocation = "Static"
    #private_ip_address            = var.ussc-ckalab-ip_address[count.index]
    private_ip_address = local.settings.ckalab.ussc-ckalab-ip_address[count.index]
  }

  tags = merge(local.settings.common_tags, local.settings.core_tags)
}

resource "azurerm_availability_set" "avset-ussc-ckalab" {
  name                = "vmusscckalab-avset"
  location            = azurerm_resource_group.ckalab-ussc.location
  resource_group_name = azurerm_resource_group.ckalab-ussc.name

  tags = merge(local.settings.common_tags, local.settings.core_tags)
}

resource "azurerm_virtual_machine" "vm-ussc-ckalab" {
  name                             = "vmusscckalab${count.index + 1}"
  location                         = azurerm_resource_group.ckalab-ussc.location
  resource_group_name              = azurerm_resource_group.ckalab-ussc.name
  network_interface_ids            = [element(azurerm_network_interface.nic-ussc-ckalab.*.id, count.index)]
  vm_size                          = local.settings.ckalab.vm_size
  availability_set_id              = azurerm_availability_set.avset-ussc-ckalab.id
  delete_data_disks_on_termination = true
  count                            = length(local.settings.ckalab.ussc-ckalab-ip_address)

  storage_image_reference {
    publisher = local.settings.ckalab.publisher
    offer     = local.settings.ckalab.offer
    sku       = local.settings.ckalab.sku
    version   = local.settings.ckalab.version
  }
  os_profile {
    computer_name  = "vmusscckalab${count.index + 1}"
    admin_username = local.settings.ckalab.admin_username
    admin_password = azurerm_key_vault_secret.ussc-admin_ospassword.value
  }

  storage_os_disk {
    name              = "vmusscckalab${count.index + 1}-OSDisk"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_data_disk {
    name              = "vmusscckalab${count.index + 1}-DataDisk01"
    create_option     = "Empty"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 64
    lun               = 0
    caching           = "None"
  }

  tags = merge(local.settings.common_tags, local.settings.core_tags)
}




