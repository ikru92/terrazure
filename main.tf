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

data "azurerm_client_config" "current_" {   
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
  end_date             = timeadd(timestamp(),"8760h")
}

resource "azurerm_role_assignment" "tf_rbac" {
  scope              = data.azurerm_client_config.current.subscription_id
  role_definition_id = data.azurerm_role_definition.builtin.id
  principal_id       = azuread_service_principal.tf_spn.id
}

resource "azurerm_resource_group" "tf_backend_rg" {
  name      = "InfraStateRG"
  location  = "westeurope"
}

resource "azurerm_storage_account" "tf_backend" {
  name                     = format("backend_%s", substr(azuread_service_principal.tf_spn.id, 0, 8))
  resource_group_name      = azurerm_resource_group.tf_backend_rg.name
  location                 = azurerm_resource_group.tf_backend_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tf_backend_contianer" {
  name                  = "terraform-state"
  storage_account_name  = azurerm_storage_account.tf_backend.name
  container_access_type = "private"
}

#############################################################

#################### Output #################################

output "username"{
    value = azuread_service_principal.tf_spn.id
} 

output "tenant_id"{
    value = data.azurerm_client_config.current.tenant_id
} 

##############################################################
