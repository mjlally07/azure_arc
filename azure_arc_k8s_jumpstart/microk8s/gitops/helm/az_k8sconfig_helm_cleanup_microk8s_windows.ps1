# <--- Change the following environment variables according to your Azure service principal name --->

Write-Output "Exporting environment variables"
$appId="d626f14d-efc1-4766-9da4-8c3e8dbc4f86"
$password="ZlX8Q~iWVlWCPQqiCBel-iTG5XVKuZXcE4ufAbA0"
$tenantId="16b3c013-d300-468d-ac64-7eda0820b6d3"
$resourceGroup="rg-arck8s-01"
$arcClusterName="Arc-MicroK8s-Demo"

Write-Output "Log in to Azure with Service Principal"
az login --service-principal --username $appId --password $password --tenant $tenantId

Write-Output "Deleting GitOps Configurations from Azure Arc-enabled Kubernetes cluster"
az k8s-configuration flux delete --name config-helloarc --cluster-name $arcClusterName --resource-group $resourceGroup --cluster-type connectedClusters --force -y

Write-Output "Deleting GitOps Flux extension"
az config set extension.use_dynamic_install=yes_without_prompt
az k8s-extension delete --name flux --cluster-name $arcClusterName --resource-group $resourceGroup --cluster-type connectedClusters -y

Write-Output "Cleaning Kubernetes cluster. You Can safely ignore non-exist resources"
microk8s kubectl delete ns hello-arc

microk8s kubectl delete -f  https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/baremetal/deploy.yaml
