[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [String]$certFolder,
  [Parameter(Mandatory = $true)]
  [String]$CertFilePath,
  [Parameter(Mandatory = $true)]
  [String]$certName,
  [Parameter(Mandatory = $true)]
  [String]$CertPassword,
  [Parameter()]
  [int]$validityInYears = 4
)

function Create-AAACertificate {
   param ($certFolder,$CertFilePath,$certName,$certPassword,$ValidityInYears)
    ## Certificate creation for SPN authentication
	$certStartDate = (Get-Date).Date
	$certStartDateStr = $certStartDate.ToString("MM/dd/yyyy")
	$certEndDate = $certStartDate.AddYears($ValidityInYears)
	$certEndDateStr = $certEndDate.ToString("MM/dd/yyyy")
	$certPasswordSecureString = ConvertTo-SecureString $certPassword -AsPlainText -Force
	
	mkdir $certFolder
	
	$cert = New-SelfSignedCertificate -DnsName $certName -CertStoreLocation cert:\CurrentUser\My -KeySpec KeyExchange -NotAfter $certEndDate -NotBefore $certStartDate
	$certThumbprint = $cert.Thumbprint
	$cert = (Get-ChildItem -Path cert:\CurrentUser\My\$certThumbprint)
	
	Export-PfxCertificate -Cert $cert -FilePath $certFilePath -Password $certPasswordSecureString
}