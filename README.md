# Azure Ping Test Module
A Terraform module to deploy Azure Application Insights Webtest with alert.

Usage:
```
module "hashipingtest" {
  source                    = "ayusmadi/pingtest/azurerm"
  resource_group_name       = "hashi-rg"
  application_insights_name = "hashi-insights"
  name                      = "hashicorp"
  ping_url                  = "https://www.hashicorp.com/"
  monitor_action_group_name = "hashi-action-group"
}
