Param(
    $storageAccountName,
    $storageAccountKey,
	$fileShareName,
    $azureStorageDirectoryPath
)

function Remove-FileDirectory
{
    Param (
        [Microsoft.WindowsAzure.Storage.File.CloudFileDirectory] $azureStorageFile
    )
    $filelist = Get-AzureStorageFile -Directory $azureStorageFile
    foreach ($f in $filelist)
    {
        if ($f.GetType().Name -eq "CloudFileDirectory")
        {
            Remove-FileDirectory -azureStorageFile $f
        }
        else
        {
            $f
            Remove-AzureStorageFile -File $f
        }
    }
    $azureStorageFile
    Remove-AzureStorageDirectory -Directory $azureStorageFile
}

$context = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
$azureStorageFile = Get-AzureStorageFile -ShareName $shareName -Path "$azureStorageDirectoryPath" -Context $context