resource "azurerm_managed_disk" "extra" {
  name                 = "Extra-disk1"
  location             = azurerm_resource_group.resource_group.location
  resource_group_name  = azurerm_resource_group.resource_group.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.extra.id
  virtual_machine_id = azurerm_linux_virtual_machine.azure_master.id
  lun                = "10"
  caching            = "ReadWrite"
}