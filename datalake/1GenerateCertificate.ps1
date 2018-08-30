## Certificate creation for SPN authentication
$certFolder = "C:\certificates"
$certFilePath = "$certFolder\certFile-dev.pfx"
$certStartDate = (Get-Date).Date
$certStartDateStr = $certStartDate.ToString("MM/dd/yyyy")
$certEndDate = $certStartDate.AddYears(4)
$certEndDateStr = $certEndDate.ToString("MM/dd/yyyy")
$certName = "HDI-ADLS-DEV"
$certPassword = "Alv9A3tSjTGSghsQtvGb"
$certPasswordSecureString = ConvertTo-SecureString $certPassword -AsPlainText -Force

mkdir $certFolder

$cert = New-SelfSignedCertificate -DnsName $certName -CertStoreLocation cert:\CurrentUser\My -KeySpec KeyExchange -NotAfter $certEndDate -NotBefore $certStartDate
$certThumbprint = $cert.Thumbprint
$cert = (Get-ChildItem -Path cert:\CurrentUser\My\$certThumbprint)

Export-PfxCertificate -Cert $cert -FilePath $certFilePath -Password $certPasswordSecureString