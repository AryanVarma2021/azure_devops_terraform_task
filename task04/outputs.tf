output "vm_public_ip" {

  value = azurerm_public_ip.public-ip-address.ip_address

}

output "vm_fqdn" {

  value = azurerm_public_ip.public-ip-address.fqdn

}