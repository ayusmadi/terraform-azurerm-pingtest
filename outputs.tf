output "template_deployment_id" {
  value = azurerm_template_deployment.main.id
}

output "template_deployment_outputs" {
  value = azurerm_template_deployment.main.outputs
}
