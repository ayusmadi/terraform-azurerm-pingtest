variable "prefix" {
  description = "Name and also prefix for pingtest and alert"
}

variable "ping_url" {
  description = "The URL can be any web page you want to test, but it must be visible from the public internet. The URL can include a query string. So, for example, you can exercise your database a little. If the URL resolves to a redirect, we follow it up to 10 redirects."
}

variable "resource_group_name" {
  description = "Specifies the name of the resource group."
}

variable "application_insights_name" {
  description = "Specifies the name of the Application Insights component."
}

variable "monitor_action_group_name" {
  description = "Specifies the name of the Action Group"
}
