Param (
    [string] $storageAccountName = "",
    [string] $storageAccountKey = "",
    [string] $storageAccountContainerName = "",
    [string] $azureStorageBlobPrefix = ""
)

#Remove Azure Blobs
"Remove Azure Storage Blobs"
$Ctx = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey;
Get-AzureStorageBlob -Container $storageAccountContainerName -Context $Ctx -Blob "$azureStorageBlobPrefix/*" | Remove-AzureStorageBlob
