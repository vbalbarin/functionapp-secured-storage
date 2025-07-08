locals {
  rules_nsg_functionapp = {
    #     "name_rule_01" = {
    #       name                       = "inbound-allow"
    #       access                     = "Allow"
    #       destination_address_prefix = "VirtualNetwork"
    #       destination_port_ranges    = ["*",]
    #       direction                  = "Inbound"
    #       priority                   = 150
    #       protocol                   = "Tcp"
    #       source_address_prefix      = ""
    #       source_port_range          = "*"
    #     }
  }
}

# This is the module call
module "nsg_functionapp" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "~> 0.4.0"

  name                = replace(local.naming_structure, "{resourceType}", "nsg-functionapp")
  location            = module.rg_network.resource.location
  resource_group_name = module.rg_network.name
  tags                = var.tags

  security_rules = local.rules_nsg_functionapp

  enable_telemetry = var.telemetry_enabled
}