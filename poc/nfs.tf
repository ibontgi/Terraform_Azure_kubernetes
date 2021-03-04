# Create virtual machine master
#resource "azurerm_linux_virtual_machine" "azure_nfs" {
#    name                            = "node.nfs"
#    location                        = azurerm_resource_group.resource_group.location
#    resource_group_name             = azurerm_resource_group.resource_group.name
#    network_interface_ids           = [azurerm_network_interface.myNic3.id]
#    admin_username                  = var.admin_user
#    disable_password_authentication = false
#    admin_password                  = var.admin_user_pass
#    size                            = var.vm_size
#
#    admin_ssh_key {
#        username       = var.admin_user
#        public_key     = tls_private_key.admin_key_ssh.public_key_openssh
#    }
#
#    os_disk {
#        caching                 = "ReadWrite"
#        storage_account_type    = "Standard_LRS"
#    }
#
#    plan {
#        name        = "centos-8-stream-free"
#        product     = "centos-8-stream-free"
#        publisher   = "cognosys"
#    }
#
#    source_image_reference {
#        publisher = "cognosys"
#        offer     = "centos-8-stream-free"
#        sku       = "centos-8-stream-free"
#        version   = "1.2019.0810"
#    }
#
#    provisioner "file" {
#        source      = "playbooks"
#        destination = "/home/${var.admin_user}/playbooks"
#        connection {
#            type        = "ssh"
#            user        = var.admin_user
#            host        = azurerm_public_ip.myPublicIP3.ip_address
#            private_key = tls_private_key.admin_key_ssh.private_key_pem
#            agent = true
#            timeout = "5m"
#        }
#    }
#
#    provisioner "remote-exec" {
#        inline   = [
#            "sudo dnf makecache",
#            "sudo dnf install epel-release -y",
#            "sudo dnf makecache",
#            "echo  \"------------------timezone-----------------\"",
#            "sudo timedatectl set-timezone Europe/Madrid",
#            "sudo dnf install chrony -y",
#            "sudo systemctl enable chronyd",
#            "sudo systemctl start chronyd",
#            "sudo timedatectl set-ntp true",
#            "echo  \"------------------Install-------------------------\"",
#            "sudo dnf install ansible git sshpass nfs-utils nfs4-acl-tools wget -y",
#            "echo  \"------------------Security---------------------\"",
#            "sudo sed -i s/=enforcing/=disabled/g /etc/selinux/config",
#            "echo  \"----------------------USER---------------------\"",
#            "sudo adduser -md /home/${var.ansible_user} ${var.ansible_user}",
#            "sudo usermod -G wheel ${var.ansible_user}",
#            "echo ${var.ansible_user_pass} | sudo passwd --stdin ${var.ansible_user}",
#            "sudo su - -c 'echo \"${var.admin_user} ALL=(${var.ansible_user}) NOPASSWD:ALL\" >> /etc/sudoers'",
#            "sudo su - -c 'echo \"${var.ansible_user} ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers'",
#            "echo \"----------------------mkdir---------------------\"",
#            "sudo mkdir /home/ansible/playbooks",
#            "sudo cp -R /home/${var.admin_user}/playbooks/. /home/${var.ansible_user}/playbooks",
#            "sudo mkdir /home/${var.ansible_user}/.ssh",
#            "sudo sh -c 'ssh-keygen -f \"/home/${var.ansible_user}/.ssh/id_rsa\" -t rsa -b 4096 -N \"\"'",
#            "echo \"---------------------chown----------------------\"",
#            "sudo chown -R ${var.ansible_user}.${var.ansible_user} \"/home/${var.ansible_user}\"",
#        ]
#        connection {
#            type        = "ssh"
#            user        = var.admin_user
#            host        = azurerm_public_ip.myPublicIP3.ip_address
#            private_key = tls_private_key.admin_key_ssh.private_key_pem
#            agent = true
#            timeout = "5m"
#        }
#        #on_failure = continue
#    }
#
#    provisioner "remote-exec" {
#        inline   = [
#            "echo \"---------------------MASTER----------------------\"",
#            "sudo sshpass -p \"${var.ansible_user_pass}\" ssh-copy-id -o \"StrictHostKeyChecking no\" -i /home/${var.ansible_user}/.ssh/id_rsa.pub ${var.ansible_user}@${azurerm_network_interface.myNic1.private_ip_address}",
#            "sudo su - ansible -c 'ssh -t -q -o \"StrictHostKeyChecking no\" ${var.ansible_user}@${azurerm_network_interface.myNic1.private_ip_address} \"exit\" -vvv'",
#            "echo  \"--------------------WORKER----------------------\"",
#            "sudo sshpass -p \"${var.ansible_user_pass}\" ssh-copy-id -o \"StrictHostKeyChecking no\" -i /home/${var.ansible_user}/.ssh/id_rsa.pub ${var.ansible_user}@${azurerm_network_interface.myNic2.private_ip_address}",
#            "sudo su - ansible -c 'ssh -t -q -o \"StrictHostKeyChecking no\" ${var.ansible_user}@${azurerm_network_interface.myNic2.private_ip_address} \"exit\" -vvv'",
#            "echo  \"--------------------NFS----------------------\"",
#            "sudo sshpass -p \"${var.ansible_user_pass}\" ssh-copy-id -o \"StrictHostKeyChecking no\" -i /home/${var.ansible_user}/.ssh/id_rsa.pub ${var.ansible_user}@${azurerm_network_interface.myNic3.private_ip_address}",
#            "sudo su - ansible -c 'ssh -t -q -o \"StrictHostKeyChecking no\" ${var.ansible_user}@${azurerm_network_interface.myNic3.private_ip_address} \"exit\" -vvv'",
#            "echo  \"--------------------CHECK-----------------------\"",
#            "ansible -i /home/${var.ansible_user}/playbooks/hosts -m ping all",
#            "echo  \"--------------------END-----------------------\"",
#        ]
#        connection {
#            type        = "ssh"
#            user        = var.admin_user
#            host        = azurerm_public_ip.myPublicIP3.ip_address
#            private_key = tls_private_key.admin_key_ssh.private_key_pem
#            agent = true
#            timeout = "5m"
#        }
#        on_failure = continue
#    }
#
#    boot_diagnostics {
#        storage_account_uri = azurerm_storage_account.staccount3cp2.primary_blob_endpoint
#    }
#
#    tags = {
#        environment = "PC2"
#        role = "nfs"
#    }
#    depends_on = [azurerm_linux_virtual_machine.azure_master, azurerm_linux_virtual_machine.azure_worker]
#}