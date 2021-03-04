### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
   content = templatefile(
      "templates/inventory.tmpl",
      {
         ansible_user= var.ansible_user
         ansible_user_pass= var.ansible_user_pass
         master-id = azurerm_network_interface.myNic1.private_ip_address
         worker-id = azurerm_network_interface.myNic2.private_ip_address
         nfs-id = azurerm_network_interface.myNic1.private_ip_address
      }
   )
   filename = "playbooks/hosts"
}

resource "local_file" "KubeVariables" {
   content = templatefile(
      "templates/env_variables.tmpl",
      {
         master-id = azurerm_network_interface.myNic1.private_ip_address
         worker-id = azurerm_network_interface.myNic2.private_ip_address
      }
   )
   filename = "playbooks/playbooks/env_variables"
}