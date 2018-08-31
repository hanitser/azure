## Destroy the cluster
$clusterName = "cludtlkhdi-dev"
$CheckCluster= Get-AzureRmHDInsightCluster -ClusterName $ClusterName


if ($CheckCluster.ClusterState -like "Error" ) {
   Remove-AzureRmHDInsightCluster -ClusterName $ClusterName  
}
if ($CheckCluster.ClusterState -like "Running") {
   Remove-AzureRmHDInsightCluster -ClusterName $ClusterName
}

## Destroy All Clusters
$CheckClusters= Get-AzureRmHDInsightCluster

Foreach ($ClusterData in $CheckClusters.Name) {
  Remove-AzureRmHDInsightCluster -ClusterName $CheckClusters.Name   
}
