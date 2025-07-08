module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vnet_address_space
  networks = [
    {
      name     = "PESubnet"
      new_bits = 2
    },
    {
      name     = "FuncAppSubnet"
      new_bits = 4
    },
  ]
}


module "virtualnetwork" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.8.1"

  // DO NOT SET DNS IPs HERE

  location            = module.rg_network.resource.location
  name                = replace(local.naming_structure, "{resourceType}", "vnet")
  resource_group_name = module.rg_network.name
  tags                = var.tags

  address_space = [var.vnet_address_space]

  subnets = {
    "PESubnet" = {
      name             = "PESubnet"
      address_prefixes = [module.subnet_addrs.network_cidr_blocks["PESubnet"]]
      network_security_group = {
        id = module.nsg_functionapp.resource.id
      }
    },
    "FuncAppSubnet" = {
      name             = "FuncAppSubnet"
      address_prefixes = [module.subnet_addrs.network_cidr_blocks["FuncAppSubnet"]]
      network_security_group = {
        id = module.nsg_functionapp.resource.id
      }
      delegation = [{
        name = "Microsoft.App.environments"
        service_delegation = {
          name = "Microsoft.App/environments"
        }
      }]
    },
  }

  flow_timeout_in_minutes = 20

  # diagnostic_settings = {
  #   sendToLogAnalytics = {
  #     name                           = "sendToLogAnalytics"
  #     workspace_resource_id          = var.logAnalyticsWorkspaceId
  #     log_analytics_destination_type = "Dedicated"
  #   }
  # }

  enable_telemetry = var.telemetry_enabled
}