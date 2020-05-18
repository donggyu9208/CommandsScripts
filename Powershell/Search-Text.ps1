Param(
	$Path = "c:\fso",
	$ItemsToConsider = "*.txt",
	$Pattern = '',
	[switch] $Recursive
)

function Get-Directories {
	Param (
		$Path,
		[switch] $Recursive
	)
	$directories = Get-ChildItem $Path -Directory
	if ($Recursive) {
		foreach ($directory in $directories) {
			Get-Directories -Path $directory -Recursive
		}
		$currentDirectory = Get-Item -Path $Path
		
		return $currentDirectory.FullName
	}
	else {
		$currentDirectory.FullName
		foreach ($directory in $directories) {
			$directory.FullName
		}
	}
}

Select-String -Pattern $Pattern -Path "$Path\$ItemsToConsider"
