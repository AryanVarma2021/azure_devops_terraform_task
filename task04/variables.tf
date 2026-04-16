variable "rg-name" {

    default = "cmaz-z5t7jrzx-mod4-rg"
    description = "Resource group name"
  
}

variable "default-location" {
    default = "eastus"
    description = "Default location for resources"
  
}

variable "vnet-name" {
    default = "cmaz-z5t7jrzx-mod4-vnet"
    description = "Virtual network name"
}

variable "subnet-name" {
    default = "frontend"
    description = "Subnet name"
}

variable "network-interface-name" {
    default = "cmaz-z5t7jrzx-mod4-nic"
    description = "Network interface name"
  
}

variable "public-ip-address-name" {
    default = "cmaz-z5t7jrzx-mod4-pip"
    description = "Public IP address name"
  
}
variable "nsg-name" {
    default = "cmaz-z5t7jrzx-mod4-nsg"
    description = "Network security group name"
  
}
variable "vm_password" {
    
    default = "P@ssw0rd1234!"
    description = "Password for the virtual machine"
}
variable "tags" {
    default =  {
        Creator = "aryan_pramodkumarvarma@epam.com"
        
    }
  
}