Param(
    $storageAccountName,
    $storageAccountKey,
	$shareName,
    $azureStorageDirectoryPath,
	$sourceDirectoryPath
)

function Upload-FileDirectory
{
    Param (
        $azureStorageDirectoryPath, 
        $sourceDirectoryPath, 
		$shareName,
        $context
    )
    
    if (Test-Path -path $sourceDirectoryPath) {
        $folderName = Split-Path -Path $sourceDirectoryPath -Leaf
        New-AzureStorageDirectory -Context $context -ShareName $shareName -Path "$azureStorageDirectoryPath\$folderName"
    }
    
    $items = ls $sourceDirectoryPath
    foreach ($item in $items) {
        if ($item.Attributes -eq "Directory") {
        "$azureStorageDirectoryPath\$item"
            Upload-FileDirectory -azureStorageDirectoryPath "$azureStorageDirectoryPath\$folderName" -sourceDirectoryPath $item.FullName -context $context -ShareName $shareName
        }
        else {
            Set-AzureStorageFileContent -Context $context -ShareName $shareName -Source $item.FullName -Path "$azureStorageDirectoryPath\$folderName"
        }
    }
}

$context = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
Upload-FileDirectory -azureStorageDirectoryPath $azureStorageDirectoryPath -sourceDirectoryPath $sourceDirectoryPath -shareName $shareName -context $context