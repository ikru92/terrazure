output "summary" {
  value = {
    spn_id = azuread_service_principal.tf_spn.id
  }

  #   value = {
  #     spn_id    = azuread_service_principal.tf_spn.id
  #     tenant_id = data.azurerm_client_config.current.tenant_id
  #   }
}


