output "vm_public_ip" {
    description = "Public VM IP"
    value = azurerm_linux_virtual_machine.lab-bastion.public_ip_address
}

output "db_endpoint" {
    description = "Getting the DB host"
    value = module.database-server.server_fqdn
}

output "load-balancer-public-ip" {
  value = module.load-balancer.public_ip_address
}
