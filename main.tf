#################### Terrafrom Config #######################

terraform{
    required_providers{
        azurerm={   
            source = "hashicorp/azurerm"
            version = "=2.59.0"
        }
        azuread = {
            source  = "hashicorp/azuread"
            version = "=1.3.0"
        }
    }
}

#############################################################

#################### Providers ##############################

provider "azurerm"{
  features{}
}

provider "azuread"{

}
#################### Data Soruce ############################

data "azurerm_subscription" "current" {
}

data "azurerm_role_definition" "builtin" {
  name = "Contributor"
}

#############################################################

#################### Data Soruce ############################

data "azurerm_subscription" "current" {
}

data "azurerm_role_definition" "builtin" {
  name = "Contributor"
}

#############################################################

#################### Resource ###############################
resource "azuread_application" "agent" {
  display_name = "terrafrom-application"
}

resource "azuread_service_principal" "agent" {
  application_id = azuread_application.agent.application_id
}

resource "azuread_service_principal_password" "agent" {
  service_principal_id = azuread_service_principal.agent.id
  value                = "bd018069-622d-4b46-bcb9-2bbee49fe7d9"
  end_date             = "2022-01-01T01:02:03Z"
}

resource "azurerm_role_assignment" "terrafrom" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.builtin.id
  principal_id       = azuread_service_principal.agent.id
}

resource "azurerm_resource_group" "resourceGroup" {
  name = "terrafromRG"
  location = "westus"
}
#############################################################