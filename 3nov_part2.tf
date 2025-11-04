
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.resource_group_location
  resource_group_name = var.second_resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.second_resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = var.resource_group_location
  resource_group_name = var.second_resource_group_name
  allocation_method   = var.public_ip_allocation_method
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.resource_group_location
  resource_group_name = var.second_resource_group_name

  ip_configuration {
    name                          = var.ip_config_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.private_ip_allocation
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.resource_group_location
  resource_group_name = var.second_resource_group_name

  security_rule {
    name                       = var.nsg_rule_name
    priority                   = var.nsg_rule_priority
    direction                  = var.nsg_rule_direction
    access                     = var.nsg_rule_access
    protocol                   = var.nsg_rule_protocol
    source_port_range           = var.nsg_rule_source_port
    destination_port_range      = var.nsg_rule_destination_port
    source_address_prefix       = var.nsg_rule_source_address
    destination_address_prefix  = var.nsg_rule_destination_address
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = var.second_resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}
//load balancer was missing the ressource lb 

resource "azurerm_lb" "lb" {
  name                = "myLoadBalancer"
  location            = var.resource_group_location
  resource_group_name = var.second_resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "msload"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

// azurerm_network_interface.nic[count.index].id countindex used with each like in 3november where we use eachkey

resource "azurerm_network_interface_backend_address_pool_association" "nic_bepool" {
 network_interface_id    = azurerm_network_interface.nic.id
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
 probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_lb_backend_address_pool" "bepool" {
 name            = "be-pool"
 loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "http" {
 name            = "http-probe"
 loadbalancer_id = azurerm_lb.lb.id
 protocol        = "Http"
 port            = 80
 request_path    = "/"
 interval_in_seconds = 5
 number_of_probes    = 2
}
