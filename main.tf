terraform {
  required_providers {
    azurerm = "~> 1.41"
  }
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_application_insights" "main" {
  resource_group_name = data.azurerm_resource_group.main.name
  name                = var.application_insights_name
}

data "azurerm_monitor_action_group" "main" {
  resource_group_name = data.azurerm_resource_group.main.name
  name                = var.monitor_action_group_name
}

resource "azurerm_template_deployment" "main" {
  count               = length(var.prefixes)
  name                = "${var.prefixes[count.index]}-webtest-deployment"
  resource_group_name = data.azurerm_resource_group.main.name

  template_body = <<DEPLOY
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appName": {
      "type": "string"
    },
    "pingTestName": {
      "type": "string"
    },
    "pingAlertRuleName": {
      "type": "string"
    },
    "pingURL": {
      "type": "string"
    },
    "pingText": {
      "type": "string",
      "defaultValue": ""
    },
    "actionGroupId": {
      "type": "string"
    },
    "location": {
      "type": "string"
    }
  },
  "resources": [
    {
      "name": "[parameters('pingTestName')]",
      "type": "Microsoft.Insights/webtests",
      "apiVersion": "2014-04-01",
      "location": "[parameters('location')]",
      "tags": {
        "[concat('hidden-link:', resourceId('Microsoft.Insights/components', parameters('appName')))]": "Resource"
      },
      "properties": {
        "Name": "[parameters('pingTestName')]",
        "Description": "Basic ping test",
        "Enabled": true,
        "Frequency": 300,
        "Timeout": 120,
        "Kind": "ping",
        "RetryEnabled": true,
        "Locations": [
          {
            "Id": "emea-nl-ams-azr"
          },
          {
            "Id": "us-tx-sn1-azr"
          },
          {
            "Id": "us-il-ch1-azr"
          },
          {
            "Id": "us-va-ash-azr"
          },
          {
            "Id": "us-fl-mia-edge"
          }
        ],
        "Configuration": {
          "WebTest": "[concat('<WebTest   Name=\"', parameters('pingTestName'), '\"   Enabled=\"True\"         CssProjectStructure=\"\"    CssIteration=\"\"  Timeout=\"120\"  WorkItemIds=\"\"         xmlns=\"http://microsoft.com/schemas/VisualStudio/TeamTest/2010\"         Description=\"\"  CredentialUserName=\"\"  CredentialPassword=\"\"         PreAuthenticate=\"True\"  Proxy=\"default\"  StopOnError=\"False\"         RecordedResultFile=\"\"  ResultsLocale=\"\">  <Items>  <Request Method=\"GET\"    Version=\"1.1\"  Url=\"', parameters('pingURL'),   '\" ThinkTime=\"0\"  Timeout=\"300\" ParseDependentRequests=\"True\"         FollowRedirects=\"True\" RecordResult=\"True\" Cache=\"False\"         ResponseTimeGoal=\"0\"  Encoding=\"utf-8\"  ExpectedHttpStatusCode=\"200\"         ExpectedResponseUrl=\"\" ReportingName=\"\" IgnoreHttpStatusCode=\"False\" />        </Items>  <ValidationRules> <ValidationRule  Classname=\"Microsoft.VisualStudio.TestTools.WebTesting.Rules.ValidationRuleFindText, Microsoft.VisualStudio.QualityTools.WebTestFramework, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a\" DisplayName=\"Find Text\"         Description=\"Verifies the existence of the specified text in the response.\"         Level=\"High\"  ExecutionOrder=\"BeforeDependents\">  <RuleParameters>        <RuleParameter Name=\"FindText\" Value=\"',   parameters('pingText'), '\" />  <RuleParameter Name=\"IgnoreCase\" Value=\"False\" />  <RuleParameter Name=\"UseRegularExpression\" Value=\"False\" />  <RuleParameter Name=\"PassIfTextFound\" Value=\"True\" />  </RuleParameters> </ValidationRule>  </ValidationRules>  </WebTest>')]"
        },
        "SyntheticMonitorId": "[parameters('pingTestName')]"
      }
    },
    {
      "name": "[parameters('pingAlertRuleName')]",
      "type": "Microsoft.Insights/metricAlerts",
      "apiVersion": "2018-03-01",
      "location": "global",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/webtests', parameters('pingTestName'))]"
      ],
      "tags": {
        "[concat('hidden-link:', resourceId('Microsoft.Insights/components', parameters('appName')))]": "Resource",
        "[concat('hidden-link:', resourceId('Microsoft.Insights/webtests', parameters('pingTestName')))]": "Resource"
      },
      "properties": {
        "description": "Alert for web test",
        "severity": 1,
        "enabled": true,
        "scopes": [
          "[resourceId('Microsoft.Insights/webtests',parameters('pingTestName'))]",
          "[resourceId('Microsoft.Insights/components',parameters('appName'))]"
        ],
        "evaluationFrequency": "PT1M",
        "windowSize": "PT5M",
        "templateType": 0,
        "criteria": {
          "odata.type": "Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria",
          "webTestId": "[resourceId('Microsoft.Insights/webtests', parameters('pingTestName'))]",
          "componentId": "[resourceId('Microsoft.Insights/components', parameters('appName'))]",
          "failedLocationCount": 3
        },
        "actions": [
          {
            "actionGroupId": "[parameters('actionGroupId')]"
          }
        ]
      }
    }
  ]
}
DEPLOY

  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters = {
    "appName"           = data.azurerm_application_insights.main.name
    "pingTestName"      = "${var.prefixes[count.index]}-pingtest"
    "pingAlertRuleName" = "${var.prefixes[count.index]}-pingtest-alert"
    "pingURL"           = var.ping_urls[count.index]
    "actionGroupId"     = data.azurerm_monitor_action_group.main.id
    "location"          = data.azurerm_resource_group.main.location
  }

  deployment_mode = "Incremental"
}
