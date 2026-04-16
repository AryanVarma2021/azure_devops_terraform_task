variable "rg_name" {
  description = "Resource group name"
  type        = string
}

variable "default_location" {
  description = "Default location for resources"
  type        = string
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "network_interface_name" {
  description = "Network interface name"
  type        = string
}

variable "public_ip_address_name" {
  description = "Public IP address name"
  type        = string
}
variable "vm_name" {
  description = "Virtual machine name"
  type        = string

}
variable "allow_ssh_rule_name" {
  description = "NSG rule name for SSH"
  type        = string
}

variable "allow_http_rule_name" {
  description = "NSG rule name for HTTP"
  type        = string
}

variable "nsg_name" {
  description = "Network security group name"
  type        = string
}

variable "vm_password" {
  description = "Password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
}

variable "domain_name_label" {
  description = "Domain name label for the public IP address"
  type        = string

}