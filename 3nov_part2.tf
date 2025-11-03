/*
resource "azurerm_network_interface_backend_address_pool_association" "nic_bepool" {
 network_interface_id    = azurerm_network_interface.nic[count.index].id
 ip_configuration_name   = "ipconfig1"
 backend_address_pool_id = azurerm_lb_backend_address_pool.bepool.id
}
resource "azurerm_lb_rule" "http" {
 name                           = "http-rule"
 loadbalancer_id                = azurerm_lb.lb.id
 protocol                       = "Tcp"
 frontend_port                  = var.frontend_http_port
 backend_port                   = 80
 frontend_ip_configuration_name = "feip"
 backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
 probe_id                       = azurerm_lb_probe.
*/
