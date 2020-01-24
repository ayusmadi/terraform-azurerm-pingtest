# Delete application insights webtest (pingtest) along with its alert
# Usage: <cmd> $resource_group_name $name_prefix
#        curl -s https://raw.githubusercontent.com/ayusmadi/terraform-azurerm-pingtest/master/delete.sh | bash -s $resource_group_name $name_prefix

RESOURCE_GROUP_NAME=$1
NAME=$2

az monitor metrics alert delete -g $RESOURCE_GROUP_NAME -n "${NAME}-pingtest-alert"
az rest -m DELETE -u "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Insights/webtests/${NAME}-pingtest?api-version=2015-05-01"
