# Varriable
#-----------------------------------------------------------------------------------------#
provider "azurerm" { alias = "sub-vm" }
provider "azurerm" { alias = "sub-law" }

variable "globals" {}
variable "name" {}
variable "rg-system" {}
variable "rg-network" {}
variable "rg-law" {}
variable "vnet" {}
variable "snet" {}
variable "law" {}

# Data
#-----------------------------------------------------------------------------------------#
# Data - RG
#------------------------------------------------------------------#
data "azurerm_resource_group" "rg-system" {
  name     = var.rg-system
  provider = azurerm.sub-vm
}
data "azurerm_resource_group" "rg-network" {
  name     = var.rg-network
  provider = azurerm.sub-vm
}
data "azurerm_resource_group" "rg-law" {
  name     = var.rg-law
  provider = azurerm.sub-law
}

# Data - vNet
#------------------------------------------------------------------#
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  provider            = azurerm.sub-vm
  resource_group_name = data.azurerm_resource_group.rg-network.name
}

# Data - sNet
#------------------------------------------------------------------#
data "azurerm_subnet" "snet" {
  name                 = var.snet
  provider             = azurerm.sub-vm
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg-network.name
}

# Data - LAW
#------------------------------------------------------------------#
data "azurerm_log_analytics_workspace" "law" {
  name                = var.law
  provider            = azurerm.sub-law
  resource_group_name = data.azurerm_resource_group.rg-law.name
}

# VM Windows - winVM - Server
#-----------------------------------------------------------------------------------------#
resource "azurerm_windows_virtual_machine" "winVM" {
    name = var.name
    provider = azurerm.sub-vm
    location = "canadaCentral"
    resource_group_name = data.azurerm_resource_group.rg-system.name
    computer_name  = var.name
    admin_username = var.globals.user
    admin_password = var.globals.password
    network_interface_ids = [azurerm_network_interface.winVM-nic1.id]
    size = "Standard_DS2_v2"
    enable_automatic_updates = "true"
    provision_vm_agent = "true"
    allow_extension_operations = "true"
    source_image_reference  {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2016-Datacenter"
        version = "latest"
    }
    os_disk {
        name = join("-", [var.name, "OSdisk1"])
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    tags = var.globals.tags
}


# VM Windows - winVM - Extensions - Link Worksapce
#-----------------------------------------------------------------------------------------#
resource "azurerm_virtual_machine_extension" "linkworkspace" {
  name = "linkworkspace"
  provider = azurerm.sub-vm
  virtual_machine_id =    azurerm_windows_virtual_machine.winVM.id
  publisher = "Microsoft.EnterpriseCloud.Monitoring"
  type = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true
  settings = <<-BASE_SETTINGS
    {
        "workspaceId" : "${data.azurerm_log_analytics_workspace.law.workspace_id}"
    }
    BASE_SETTINGS
  protected_settings  = <<-PROTECTED_SETTINGS
    {
        "workspaceKey" : "${data.azurerm_log_analytics_workspace.law.primary_shared_key}"
    }
    PROTECTED_SETTINGS
}

# VM Windows - winVM - NIC
#-----------------------------------------------------------------------------------------#
resource "azurerm_network_interface" "winVM-nic1" {
  name                          = join("-", [var.name, "nic1"])
  provider                      = azurerm.sub-vm
  location                      = "canadaCentral"
  resource_group_name           = data.azurerm_resource_group.rg-system.name
  enable_ip_forwarding          = "false"
  enable_accelerated_networking = "false"
  ip_configuration {
    name                          = join("-", [var.name, "nic1-config"])
    subnet_id                     = data.azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.globals.tags
}

# VM Windows - winVM - Auto-Shutdown
#-----------------------------------------------------------------------------------------#
resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  virtual_machine_id = azurerm_windows_virtual_machine.winVM.id
  provider = azurerm.sub-vm
  location = "canadaCentral"
  enabled = true

  daily_recurrence_time = "1700"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled         = false
    time_in_minutes = "60"
  }
}

# NSG 
#-----------------------------------------------------------------------------------------#
/*
resource "azurerm_network_security_group" "nsg" {
  name = join("-", [var.name, "nsg"])
  provider = azurerm.sub-vm
  location = "canadaCentral"
  resource_group_name           = data.azurerm_resource_group.rg-system.name
  security_rule {
    name                       = "InBound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = var.globals.tags
}

resource "azurerm_network_interface_security_group_association" "nsgassoc" {
  network_interface_id      = azurerm_network_interface.winVM-nic1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  provider = azurerm.sub-vm
}
*/

# Output 
#-----------------------------------------------------------------------------------------#
output id {value = azurerm_windows_virtual_machine.winVM.id}