# Create Network Security Group and rule
resource "azurerm_network_security_group" "mynsg" {
    name                = "myNetworkSecurityGroup"
    location            = azurerm_virtual_network.mynetwork.location
    resource_group_name = azurerm_resource_group.resource_group.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "CP2"
    }
}


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "master" {
    network_interface_id      = azurerm_network_interface.myNic1.id
    network_security_group_id = azurerm_network_security_group.mynsg.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "worker" {
    network_interface_id      = azurerm_network_interface.myNic2.id
    network_security_group_id = azurerm_network_security_group.mynsg.id
}

# Connect the security group to the network interface
#resource "azurerm_network_interface_security_group_association" "nfs" {
#    network_interface_id      = azurerm_network_interface.myNic3.id
#    network_security_group_id = azurerm_network_security_group.mynsg.id
#}