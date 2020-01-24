variable "prefixes" {
  type        = list(string)
  description = "List of names or prefixes for pingtest and alert"
}

variable "ping_urls" {
  type        = list(string)
  description = "List of URLs can be any web page you want to test, but it must be visible from the public internet. The URL can include a query string. So, for example, you can exercise your database a little. If the URL resolves to a redirect, we follow it up to 10 redirects."
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

variable "location1" {
  description = "location1"
  default     = "emea-nl-ams-azr"
}

variable "location2" {
  description = "location1"
  default     = "us-tx-sn1-azr"
}

variable "location3" {
  description = "location1"
  default     = "us-il-ch1-azr"
}

variable "location4" {
  description = "location1"
  default     = "us-va-ash-azr"
}

variable "location5" {
  description = "location1"
  default     = "us-fl-mia-edge"
}
