output "template_deployment_id" {
  value       = azurerm_template_deployment.main.id
  description = "The Template Deployment ID"
}

output "template_deployment_outputs" {
  value       = azurerm_template_deployment.main.outputs
  description = "A map of supported scalar output types returned from the deployment (currently, Azure Template Deployment outputs of type String, Int and Bool are supported, and are converted to strings - others will be ignored) and can be accessed using .outputs["name"]."
}
