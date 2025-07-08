module "rg_network" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "~> 0.2.1"

  name     = replace(local.naming_structure, "{resourceType}", "rg-network")
  location = var.location
  tags     = var.tags

  enable_telemetry = var.telemetry_enabled
}

module "rg_functionapp" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "~> 0.2.1"

  name     = replace(local.naming_structure, "{resourceType}", "rg-functionapp")
  location = var.location
  tags     = var.tags

  enable_telemetry = var.telemetry_enabled
}