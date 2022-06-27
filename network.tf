
resource   "azurerm_public_ip"   "publicip"   { 
   name   =   "publicip-20180417" 
   location   =   var.region
   resource_group_name   =   data.azurerm_resource_group.tp4.name 
   allocation_method   =   "Dynamic" 
   sku   =   "Basic" 
 } 

resource "azurerm_network_interface" "interface" {
  name                = "interface-20180417"
  resource_group_name = data.azurerm_resource_group.tp4.name
  location            = var.region

  ip_configuration {
    name                          = "publicip"
    subnet_id                     = data.azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id   =   azurerm_public_ip.publicip.id 
  }
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "devops-20180417"
  resource_group_name             = data.azurerm_resource_group.tp4.name
  location                        = var.region
  size                            = "Standard_D2s_v3"
  admin_username                  = "devops"
  admin_password                  = "Password123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.interface.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
