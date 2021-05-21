#################### Terraform Config #######################

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
resource "azuread_application" "tf_app" {
  display_name = "terraform-application"
}

resource "azuread_service_principal" "tf_spn" {
  application_id = azuread_application.tf_app.application_id
}

resource "azuread_service_principal_password" "tf_credential" {
  service_principal_id = azuread_service_principal.tf_spn.id
  value                = var.tf_spn_secret
  end_date             = var.tf_spn_secret_validity
}

resource "azurerm_role_assignment" "tf_rbac" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.builtin.id
  principal_id       = azuread_service_principal.agent.id
}

resource "azurerm_resource_group" "project_rg" {
  name = "PheonixProject"
  location = "westeurope"
}
#############################################################