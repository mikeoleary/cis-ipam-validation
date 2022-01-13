resource "random_id" "id" {
  byte_length = 2
}

# mgmt subnet for F5 resources
resource "azurerm_subnet" "mgmt" {
  name                 = "mgmt"
  resource_group_name  = azurerm_resource_group.rancher-quickstart.name
  virtual_network_name = azurerm_virtual_network.rancher-quickstart.name
  address_prefixes     = ["10.1.0.0/24"]
}

# external subnet for F5 resources
resource "azurerm_subnet" "external" {
  name                 = "external"
  resource_group_name  = azurerm_resource_group.rancher-quickstart.name
  virtual_network_name = azurerm_virtual_network.rancher-quickstart.name
  address_prefixes     = ["10.1.1.0/24"]
}

# internal subnet for F5 resources
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rancher-quickstart.name
  virtual_network_name = azurerm_virtual_network.rancher-quickstart.name
  address_prefixes     = ["10.1.2.0/24"]
}

module "mgmt-network-security-group" {
  depends_on = [
    azurerm_resource_group.rancher-quickstart
  ]
  source              = "Azure/network-security-group/azurerm"
  resource_group_name = azurerm_resource_group.rancher-quickstart.name
  security_group_name = format("%s-mgmt-nsg-%s", var.prefix, random_id.id.hex)
}


module "external-network-security-group-public" {
  depends_on = [
    azurerm_resource_group.rancher-quickstart
  ]
  source              = "Azure/network-security-group/azurerm"
  resource_group_name = azurerm_resource_group.rancher-quickstart.name
  security_group_name = format("%s-external-public-nsg-%s", var.prefix, random_id.id.hex)
}

module "internal-network-security-group" {
  depends_on = [
    azurerm_resource_group.rancher-quickstart
  ]
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = azurerm_resource_group.rancher-quickstart.name
  security_group_name   = format("%s-internal-nsg-%s", var.prefix, random_id.id.hex)
  source_address_prefix = ["10.0.3.0/24"]
}

resource "azurerm_network_security_rule" "mgmt_allow_https" {
  name                        = "Allow_Https"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  destination_address_prefix  = "*"
  source_address_prefix     = var.AllowedIPs
  resource_group_name         = azurerm_resource_group.rancher-quickstart.name
  network_security_group_name = format("%s-mgmt-nsg-%s", var.prefix, random_id.id.hex)
  depends_on                  = [module.mgmt-network-security-group]
}
resource "azurerm_network_security_rule" "mgmt_allow_ssh" {
  name                        = "Allow_ssh"
  priority                    = 202
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  destination_address_prefix  = "*"
  source_address_prefix     = var.AllowedIPs
  resource_group_name         = azurerm_resource_group.rancher-quickstart.name
  network_security_group_name = format("%s-mgmt-nsg-%s", var.prefix, random_id.id.hex)
  depends_on                  = [module.mgmt-network-security-group]
}

resource "azurerm_network_security_rule" "external_allow_https" {
  name                        = "Allow_Https"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  destination_address_prefix  = "*"
  source_address_prefix     = var.AllowedIPs
  resource_group_name         = azurerm_resource_group.rancher-quickstart.name
  network_security_group_name = format("%s-external-public-nsg-%s", var.prefix, random_id.id.hex)
  depends_on                  = [module.external-network-security-group-public]
}
resource "azurerm_network_security_rule" "external_allow_ssh" {
  name                        = "Allow_ssh"
  priority                    = 202
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  destination_address_prefix  = "*"
  source_address_prefix     = var.AllowedIPs
  resource_group_name         = azurerm_resource_group.rancher-quickstart.name
  network_security_group_name = format("%s-external-public-nsg-%s", var.prefix, random_id.id.hex)
  depends_on                  = [module.external-network-security-group-public]
}

module "bigip" {
  depends_on = [
    azurerm_resource_group.rancher-quickstart
  ]
  count                       = var.instance_count
  source                      = "../bigip/"
  prefix                      = format("%s-3nic", var.prefix)
  resource_group_name         = azurerm_resource_group.rancher-quickstart.name
  f5_ssh_publickey            = tls_private_key.global_key.public_key_openssh
  f5_password                 = var.f5_password
  mgmt_subnet_ids             = [{ "subnet_id" = azurerm_subnet.mgmt.id, "public_ip" = true, "private_ip_primary" = "" }]
  mgmt_securitygroup_ids      = [module.mgmt-network-security-group.network_security_group_id]
  external_subnet_ids         = [{ "subnet_id" = azurerm_subnet.external.id, "public_ip" = true, "private_ip_primary" = "", "private_ip_secondary" = "" }]
  external_securitygroup_ids  = [module.external-network-security-group-public.network_security_group_id]
  internal_subnet_ids         = [{ "subnet_id" = azurerm_subnet.internal.id, "public_ip" = false, "private_ip_primary" = "" }]
  internal_securitygroup_ids  = [module.internal-network-security-group.network_security_group_id]
  availabilityZones           = var.availabilityZones
  availabilityZones_public_ip = var.availabilityZones_public_ip
}