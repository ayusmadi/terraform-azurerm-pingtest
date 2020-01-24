# Azure Ping Test Module
A Terraform module to deploy Azure Application Insights Webtest with alert.

## Example
```
module "hashipingtest" {
  source                    = "ayusmadi/pingtest/azurerm"
  resource_group_name       = "hashi-rg"
  application_insights_name = "hashi-insights"
  prefix                    = "hashicorp"
  ping_url                  = "https://www.hashicorp.com/"
  monitor_action_group_name = "hashi-action-group"
}
```
This code deploys the following
* ARM deployment `hashicorp-webtest-deployment`
* App Insights Webtest resource `hashicorp-pingtest`
* Alert resource `hashicorp-pingtest-alert`

## Notes

* Terraform `destroy` will only delete ARM deployment. To delete the webtest and its alert, use the `delete.sh` script.

  ```
  $ delete.sh hashi-rg hashicorp
  ```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 1.41 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| application\_insights\_name | Specifies the name of the Application Insights component. | `any` | n/a | yes |
| monitor\_action\_group\_name | Specifies the name of the Action Group | `any` | n/a | yes |
| Prefix | Prefix for pingtest and alert | `any` | n/a | yes |
| ping\_url | The URL can be any web page you want to test, but it must be visible from the public internet. The URL can include a query string. So, for example, you can exercise your database a little. If the URL resolves to a redirect, we follow it up to 10 redirects. | `any` | n/a | yes |
| resource\_group\_name | Specifies the name of the resource group. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| template\_deployment\_id | The Template Deployment ID |
| template\_deployment\_outputs | A map of supported scalar output types returned from the deployment |
