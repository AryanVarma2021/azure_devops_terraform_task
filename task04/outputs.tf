output "vm_public_ip" {
  description = "VM ip address"
  value       = azurerm_public_ip.public_ip.ip_address

}

output "vm_fqdn" {
  description = "VM FQDN"
  value       = azurerm_public_ip.public_ip.fqdn

}