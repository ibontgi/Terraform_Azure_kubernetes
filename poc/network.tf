resource "azurerm_virtual_network" "mynetwork" {
    name                = "Kubernetesnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.resource_group.location
    resource_group_name = azurerm_resource_group.resource_group.name

    tags = {
        environment = "CP2"
    }
}

# Create subnet
resource "azurerm_subnet" "mySubnet" {
    name                 = "terraformsubnet"
    resource_group_name  = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.mynetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create network interface for Master
resource "azurerm_network_interface" "myNic1" {
    name                      = "vmnic1"
    location                  = azurerm_resource_group.resource_group.location
    resource_group_name       = azurerm_resource_group.resource_group.name

    ip_configuration {
        name                          = "myipconfiguration1"
        subnet_id                     = azurerm_subnet.mySubnet.id
        private_ip_address_allocation = "static"
        private_ip_address            = "10.0.1.10"
        public_ip_address_id          = azurerm_public_ip.myPublicIP1.id
    }

    tags = {
        environment = "CP2"
        host = "Master"
    }
}

resource "azurerm_network_interface" "myNic2" {
    name                      = "vmnic2"
    location                  = azurerm_resource_group.resource_group.location
    resource_group_name       = azurerm_resource_group.resource_group.name

    ip_configuration {
        name                          = "myipconfiguration2"
        subnet_id                     = azurerm_subnet.mySubnet.id
        private_ip_address_allocation = "static"
        private_ip_address            = "10.0.1.11"
        public_ip_address_id          = azurerm_public_ip.myPublicIP2.id
    }

    tags = {
        environment = "CP2"
        host = "worker"
    }
}

# Create network interface
#resource "azurerm_network_interface" "myNic3" {
#    name                      = "vmnic3"
#    location                  = azurerm_resource_group.resource_group.location
#    resource_group_name       = azurerm_resource_group.resource_group.name
#
#    ip_configuration {
#        name                          = "myipconfiguration3"
#        subnet_id                     = azurerm_subnet.mySubnet.id
#        private_ip_address_allocation = "static"
#        private_ip_address            = "10.0.1.12"
#        public_ip_address_id          = azurerm_public_ip.myPublicIP3.id
#    }
#
#    tags = {
#        environment = "CP2"
#    }
#}

# Create public IPs
resource "azurerm_public_ip" "myPublicIP1" {
    name                        = "myPublicIP1"
    location                    = azurerm_resource_group.resource_group.location
    resource_group_name         = azurerm_resource_group.resource_group.name
    allocation_method           = "Static"
    sku                         = "Basic"
    tags = {
        environment = "CP2"
        host = "Master"
    }
}

# Create public IPs
resource "azurerm_public_ip" "myPublicIP2" {
    name                        = "myPublicIP2"
    location                    = azurerm_resource_group.resource_group.location
    resource_group_name         = azurerm_resource_group.resource_group.name
    allocation_method           = "Static"
    sku                         = "Basic"
    tags = {
        environment = "CP2"
        host = "worker"
    }
}

# Create public IPs
#resource "azurerm_public_ip" "myPublicIP3" {
#    name                        = "myPublicIP3"
#    location                    = azurerm_resource_group.resource_group.location
#    resource_group_name         = azurerm_resource_group.resource_group.name
#    allocation_method           = "Static"
#    sku                         = "Basic"
#    tags = {
#        environment = "CP2"
#        host = "nfs"
#    }
#}