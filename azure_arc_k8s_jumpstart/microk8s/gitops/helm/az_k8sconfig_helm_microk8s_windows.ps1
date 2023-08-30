# <--- Change the following environment variables according to your Azure service principal name --->

Write-Output "Exporting environment variables"
$appId="d626f14d-efc1-4766-9da4-8c3e8dbc4f86"
$password="ZlX8Q~iWVlWCPQqiCBel-iTG5XVKuZXcE4ufAbA0"
$tenantId="16b3c013-d300-468d-ac64-7eda0820b6d3"
$resourceGroup="rg-arck8s-01"
$arcClusterName="Arc-MicroK8s-Demo"
$appClonedRepo="https://github.com/mjlally07/azure-arc-jumpstart-apps"
$namespace='hello-arc'

# Logging in to Azure using service principal
Write-Output "Log in to Azure with Service Principal"
az login --service-principal --username $appId --password $password --tenant $tenantId

# Create GitOps config for App Deployment
Write-Output "Creating GitOps config for deploying the Hello-Arc App"
az k8s-configuration flux create `
--cluster-name $arcClusterName `
--resource-group $resourceGroup `
--name config-helloarc `
--namespace $namespace `
--cluster-type connectedClusters `
--scope namespace `
--url $appClonedRepo `
--branch main --sync-interval 3s `
--kustomization name=app prune=true path=./hello-arc/releases/app
