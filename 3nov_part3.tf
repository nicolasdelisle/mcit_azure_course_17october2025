#load balancer 5vm 

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
  for_each            = toset(var.vm_names)
  name                = "${each.key}-pip"
  location            = var.resource_group_location
  resource_group_name = var.second_resource_group_name
  allocation_method   = var.public_ip_allocation_method
}

resource "azurerm_network_interface" "nic" {
  for_each            = toset(var.vm_names)
  name                = "${each.key}-nic"
  location            = var.resource_group_location
  resource_group_name = var.second_resource_group_name

  ip_configuration {
    name                          = "${each.key}-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.private_ip_allocation
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
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
  for_each = toset(var.vm_names)
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = toset(var.vm_names)

  name                  = each.key
  resource_group_name   = var.second_resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

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
//load balancer 
// since now pip.id is using var in a list ill create a ressource bloc to give lb a ip address

resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-public-ip"
  location            = var.resource_group_location
  resource_group_name = var.second_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = "myLoadBalancer"
  location            = var.resource_group_location
  resource_group_name = var.second_resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "feip"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_bepool" {
 for_each = azurerm_network_interface.nic
 network_interface_id    = each.value.id
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



