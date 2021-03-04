terraform {
  required_providers {
      azurerm ={
          source    = "hashicorp/azurerm"
          version = "=2.46.1"
      }
  }
}

# ITG:
#provider "azurerm" {
#    features {}
#    subscription_id = ""
#    client_id       = ""
#    client_secret   = ""
#    tenant_id       = ""
#}

# Create (and display) an SSH key
resource "tls_private_key" "admin_key_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = tls_private_key.admin_key_ssh.private_key_pem }

resource "local_file" "private_key" {
    content  = tls_private_key.admin_key_ssh.private_key_pem
    filename = "private_key.pem"
}

#fefinimos el resource group
resource "azurerm_resource_group" "resource_group" {
    name        = "Kubernetes_rg"
    location    = var.location
    tags = {
        environment = "CP2"
    }
}

resource "azurerm_storage_account" "staccount1cp2" {
    name                        = "staccount1cp2"
    resource_group_name         = azurerm_resource_group.resource_group.name
    location                    = azurerm_resource_group.resource_group.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    tags = {
        environment = "CP2"
        host = "Master"
    }
}
resource "azurerm_storage_account" "staccount2cp2" {
    name                        = "staccount2cp2"
    resource_group_name         = azurerm_resource_group.resource_group.name
    location                    = azurerm_resource_group.resource_group.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    tags = {
        environment = "CP2"
        host = "Worker"
    }
}

#resource "azurerm_storage_account" "staccount3cp2" {
#    name                        = "staccount3cp2"
#    resource_group_name         = azurerm_resource_group.resource_group.name
#    location                    = azurerm_resource_group.resource_group.location
#    account_tier                = "Standard"
#    account_replication_type    = "LRS"
#    tags = {
#        environment = "CP2"
#        host = "Nfs"
#    }
#}