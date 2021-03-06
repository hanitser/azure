[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [String]$dataLakeStoreName,
  [Parameter(Mandatory = $true)]
  [String]$ClusterName,
  [Parameter(Mandatory = $true)]
  [String]$SPID,
  [Parameter(Mandatory = $true)]
  [String]$ApplicationDisplayName
)

function Set-AAADLS {
   param ($dataLakeStoreName,$ApplicationDisplayName,$ClusterName)
      ## Folders Structure creation
         $test = Test-AzureRmDataLakeStoreAccount -Name $dataLakeStoreName
         $pathcluhdfs = "/clusters/$ClusterName"
         $pathdtlkdata = "/data/datalake"
         $pathdtlkexpl = "/exploration/datalake"
         $pathclusters = "/clusters"

         if ($test -eq "true") {
            New-AzureRmDataLakeStoreItem -Folder -AccountName $dataLakeStoreName -Path $pathcluhdfs
            New-AzureRmDataLakeStoreItem -Folder -AccountName $dataLakeStoreName -Path $pathdtlkdata
            New-AzureRmDataLakeStoreItem -Folder -AccountName $dataLakeStoreName -Path $pathdtlkexpl
         }
         ## Give permissions to SPN
         Set-AzureRmDataLakeStoreItemAclEntry -AccountName $dataLakeStoreName -Path / -AceType User -Id $SPID -Permissions All 
         Set-AzureRmDataLakeStoreItemAclEntry -AccountName $dataLakeStoreName -Path $pathclusters -AceType User -Id $SPID -Permissions All 
         Set-AzureRmDataLakeStoreItemAclEntry -AccountName $dataLakeStoreName -Path $pathcluhdfs -AceType User -Id $SPID -Permissions All
         Set-AzureRmDataLakeStoreItemAclEntry -AccountName $dataLakeStoreName -Path $pathdtlkdata -AceType User -Id $SPID -Permissions All
         Set-AzureRmDataLakeStoreItemAclEntry -AccountName $dataLakeStoreName -Path $pathdtlkexpl -AceType User -Id $SPID -Permissions All         
}

