output "template_deployment_id" {
  value       = azurerm_template_deployment.main[*].id
  description = "The Template Deployment ID"
}

output "template_deployment_outputs" {
  value       = azurerm_template_deployment.main[*].outputs
  description = "A map of supported scalar output types returned from the deployment"
}
