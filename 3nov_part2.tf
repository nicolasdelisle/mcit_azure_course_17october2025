resource "azurerm_network_interface_backend_address_pool_association" "nic_bepool" {
 network_interface_id    = azurerm_network_interface.nic[count.index].id
 ip_configuration_name   = "ipconfig1"
 backend_address_pool_id = azurerm_lb_backend_address_pool.bepool.id
}
