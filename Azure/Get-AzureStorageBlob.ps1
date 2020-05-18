<#
    #Prerequisites#
        - Powershell Version 5.0 or later
        - AzCopy.exe on path .\azcopy.exe
#>

Param(
    $storageAccountName = "",
    $storageAccountKey = "",
    $storageAccountContainerName = "",
    $storageAccountBlobPrefix = "/*",
    $destinationPath = "Z:\DestinationPath"
)

$azureRM = Get-InstalledModule -Name AzureRM

if ($azureRM -eq $null) {
	Install-Module -Name AzureRM -AllowClobber
}

if ($azureRM -ne $null) {
	$connectionString = "DefaultEndpointsProtocol=https;AccountName=$storageAccountName;AccountKey=$storageAccountKey;EndpointSuffix=core.windows.net"
	$context = New-AzureStorageContext -ConnectionString "$connectionString" -Verbose
 	$sasToken = New-AzureStorageContainerSASToken -Name $storageAccountContainerName -Context $context -Permission rwdlac -Protocol HttpsOnly -Verbose
	$response = $context.BlobEndPoint + $storageAccountContainerName + $storageAccountBlobPrefix + $sasToken
}

& ".\Resources\azcopy.exe" cp $response $destinationPath --recursive=true