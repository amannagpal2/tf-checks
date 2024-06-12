# Create Virtual Network (Exposed to Internet)
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["0.0.0.0/0"]  # Exposing to the entire internet
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

# Create Subnet (Exposed to Internet)
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["0.0.0.0/0"]  # Exposing to the entire internet
}

# Create Public IP Address (Static)
resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"  # Using a static IP address
  domain_name_label   = "app1-vm-${random_string.myrandom.id}"
  tags = {
    environment = "Dev"
  }
}

# Create Network Interface (Exposed to Internet)
resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id  # Exposing to the entire internet
  }
}
