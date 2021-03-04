# Create virtual machine master
resource "azurerm_linux_virtual_machine" "azure_worker" {
    name                            = "node.worker"
    location                        = azurerm_resource_group.resource_group.location
    resource_group_name             = azurerm_resource_group.resource_group.name
    network_interface_ids           = [azurerm_network_interface.myNic2.id]
    admin_username                  = var.admin_user
    disable_password_authentication = false
    admin_password                  = var.admin_user_pass
    size                            = var.vm_size

    admin_ssh_key {
        username       = var.admin_user
        public_key     = tls_private_key.admin_key_ssh.public_key_openssh
    }

    os_disk {
        caching                 = "ReadWrite"
        storage_account_type    = "Standard_LRS"
    }

    plan {
        name        = "centos-8-stream-free"
        product     = "centos-8-stream-free"
        publisher   = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.staccount2cp2.primary_blob_endpoint
    }

    provisioner "remote-exec" {
        inline   = [
            "sudo dnf makecache",
            "sudo dnf install epel-release -y",
            "sudo dnf makecache",
            #"echo  \"------------------timezone-----------------\"",
            #"sudo timedatectl set-timezone Europe/Madrid",
            #"sudo dnf install chrony -y",
            #"sudo systemctl enable chronyd",
            #"sudo systemctl start chronyd",
            #"sudo timedatectl set-ntp true",
            "echo  \"------------------Install-------------------------\"",
            "sudo dnf install ansible git sshpass -y",
            #"sudo dnf install nfs-utils nfs4-acl-tools wget -y",
            #"echo  \"------------------Security---------------------\"",
            #"sudo sed -i s/=enforcing/=disabled/g /etc/selinux/config",
            "echo  \"----------------------USER---------------------\"",
            "sudo adduser -md /home/${var.ansible_user} ${var.ansible_user}",
            "sudo usermod -G wheel ${var.ansible_user}",
            "echo ${var.ansible_user_pass} | sudo passwd --stdin ${var.ansible_user}",
            "sudo su - -c 'echo \"${var.admin_user} ALL=(${var.ansible_user}) NOPASSWD:ALL\" >> /etc/sudoers'",
            "sudo su - -c 'echo \"${var.ansible_user} ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers'",
        ]
        connection {
            type        = "ssh"
            user        = var.admin_user
            host        = azurerm_public_ip.myPublicIP2.ip_address
            private_key = tls_private_key.admin_key_ssh.private_key_pem
            agent = true
            timeout = "5m"
        }
        on_failure = continue
    }

    tags = {
        environment = "PC2"
    }
}