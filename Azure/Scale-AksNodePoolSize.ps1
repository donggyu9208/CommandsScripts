Param(
    [String] $AksClusterResourceGroupName = "", # Kunbernetes Cluster Name
    [String] $AksClusterNames = "", # Kubernetes Cluster Resource Group Name
	[String] $AksSubscription = "RB", # Kubernetes Cluster Subscription
    [String] $osType = "Windows", # Windows, Linux
    [Int] $NodeCount = 2
)
#az login
#Connect-AzureRmAccount -subscription $AksSubscription

$aksClusterNameList = $AksClusterNames -split ',\s*';

foreach ($aksClusterName in $aksClusterNameList) {
	$aksCluster = az aks show --resource-group $AksClusterResourceGroupName --name $aksClusterName --subscription $AksSubscription | ConvertFrom-Json
	$nodeResourceGroup = $aksCluster.nodeResourceGroup
	$agentPool = $aksCluster.agentPoolProfiles | Where-Object { $_.osType -eq $osType }

	# Scale up a nodepool size
	az aks scale --resource-group $AksClusterResourceGroupName --name $AksClusterNames --node-count $NodeCount --nodepool-name $agentPool.name --subscription $AksSubscription
}