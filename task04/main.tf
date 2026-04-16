# ================= Resource Group =================

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.default_location

  tags = var.tags
}


# ================= Virtual Network =================

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.default_location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}


# ================= Subnet =================

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = ["10.0.1.0/24"]
}


# ================= Public IP =================

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_address_name
  location            = var.default_location
  resource_group_name = azurerm_resource_group.rg.name

  sku = "Standard"

  allocation_method = "Static"

  domain_name_label = var.domain_name_label

  tags = var.tags
}


# ================= Network Security Group =================

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.default_location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}


# allow SSH

resource "azurerm_network_security_rule" "allow_ssh" {

  name      = var.allow_ssh_rule_name
  priority  = 1001
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "22"

  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}


# allow HTTP

resource "azurerm_network_security_rule" "allow_http" {

  name      = var.allow_http_rule_name
  priority  = 1002
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "80"

  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}


# ================= Network Interface =================

resource "azurerm_network_interface" "nic" {

  name                = var.network_interface_name
  location            = var.default_location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {

    name = var.ip_configuration_name

    subnet_id = azurerm_subnet.subnet.id

    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  tags = var.tags
}


# ================= NSG association =================

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {

  network_interface_id = azurerm_network_interface.nic.id

  network_security_group_id = azurerm_network_security_group.nsg.id
}


# ================= Virtual Machine =================

resource "azurerm_linux_virtual_machine" "vm" {

  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.default_location

  size = "Standard_B2s_v2"

  computer_name = var.vm_name

  admin_username = "azureuser"

  admin_password = var.vm_password

  disable_password_authentication = false


  network_interface_ids = [

    azurerm_network_interface.nic.id

  ]


  os_disk {

    caching = "ReadWrite"

    storage_account_type = "Standard_LRS"
  }


  source_image_reference {

    publisher = "Canonical"

    offer = "0001-com-ubuntu-server-jammy"

    sku = "24_04-lts"

    version = "latest"
  }


  provisioner "remote-exec" {

    inline = [

      "sudo apt-get update -y",

      "sudo apt-get install -y nginx",

      "sudo systemctl enable nginx",

      "sudo systemctl start nginx"

    ]


    connection {

      type = "ssh"

      host = azurerm_public_ip.public_ip.ip_address

      user = "azureuser"

      password = var.vm_password

      port = 22

      timeout = "10m"
    }
  }


  tags = var.tags
}