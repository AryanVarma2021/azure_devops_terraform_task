# ===========Resource Group====================
resource "azurerm_resource_group" "rg" {
  name = var.rg-name
  location = var.default-location

  tags = var.tags

  
}



# ===========Virtual Network and Subnet====================
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet-name
  address_space       = ["10.0.0.0/16"]
  location            = var.default-location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags

}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet-name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  
}





# ===================Public IP, Network Interface, and Network Security Group====================
resource "azurerm_public_ip" "public-ip-address" {
    name                = "cmaz-z5t7jrzx-mod4-pip"
    location            = var.default-location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"
    domain_name_label  = "cmaz-z5t7jrzx-mod4-nginx"

    tags = var.tags
  
}

resource "azurerm_network_interface" "nic-name" {
    name                = var.network-interface-name
    location            = var.default-location
    resource_group_name = azurerm_resource_group.rg.name
    
    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.public-ip-address.id
        
    }

    tags = var.tags
  
}

resource "azurerm_network_security_group" "nsg" {
    name                = var.nsg-name
    location            = var.default-location
    resource_group_name = azurerm_resource_group.rg.name

    tags = var.tags
  
}

resource "azurerm_network_security_rule" "allow-ssh" {
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name


    name                        = "Allow-SSH"
    priority                    = 1001
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    
  
}

resource "azurerm_network_security_rule" "allow-http" {
    resource_group_name = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
    
        name                        = "Allow-HTTP"
        priority                    = 1002
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    
   
  
}









resource "azurerm_linux_virtual_machine" "vm_linux" {

  name                = "cmaz-z5t7jrzx-mod4-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.default-location

  size           = "Standard_B2s_v2"
  computer_name  = "mod4vm"

  admin_username = "azureuser"
  admin_password = var.vm_password

  network_interface_ids = [
    azurerm_network_interface.nic_name.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "24_04-lts"
    version   = "latest"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type        = "ssh"
      host        = azurerm_public_ip.public-ip-address.ip_address
      user        = "azureuser"
      password    = var.vm_password
      port = 22

      timeout = "10m"
    }
    
  }

  

  tags = var.tags
}






