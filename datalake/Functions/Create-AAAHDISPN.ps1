[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [String]$clusterName,
  [Parameter(Mandatory = $true)]
  [String]$CertFilePath,
  [Parameter(Mandatory = $true)]
  [String]$CertPassword,
  [Parameter(Mandatory = $true)]
  [String]$ApplicationDisplayName
)

function Create-AAAHDISPN {
   param ($clusterName,$ApplicationDisplayName,$CertFilePath,$CertPassword)
          ### Create Service principal with certificate Authentication
            $certPasswordSecureString = ConvertTo-SecureString $certPassword -AsPlainText -Force
            $certificatePFX = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certFilePath, $certPasswordSecureString)
            $credential = [System.Convert]::ToBase64String($certificatePFX.GetRawCertData())
            $ServicePrincipal = New-AzureRMADServicePrincipal -DisplayName $ApplicationDisplayName
            New-AzureRmADSpCredential -ObjectId $ServicePrincipal.Id -CertValue $credential -StartDate $certificatePFX.NotBefore -EndDate $certificatePFX.NotAfter
            Get-AzureRmADServicePrincipal -ObjectId $ServicePrincipal.Id 
            $RawObjectID = (Get-AzureRmADApplication -DisplayNameStartWith $ApplicationDisplayName).ObjectId.Guid
            $ObjectID = ($RawObjectID | Out-String).Trim()
            Set-AzureRmADApplication -ObjectId $ObjectID -IdentifierUris "https://$clusterName.azurehdinsight.net" -HomePage "https://$clusterName.azurehdinsight.net"

          ## Outputs // Service Principal needed 
            $ApplicationID = ($servicePrincipal.ApplicationId.Guid | Out-String).Trim()
            Write-Output "Votre Application ID est le $ApplicationID"
            $SPID = ($servicePrincipal.Id.Guid | Out-String).Trim()
            Write-Output "Votre Service Principal ID est le $SPID"
            $TenantID = (Get-AzureRmContext).Tenant.TenantId
            Write-Output "Votre Tenant ID est le $TenantID"
            $certstring = [System.Convert]::ToBase64String((Get-Content $certFilePath -Encoding Byte))
            Write-Output "Votre certificat est : $certstring"
            Write-Output "Le mot de passe de votre certificat est : $certPassword"
}