# Current Powershell Script path
$PSScriptRoot

Get-ChildItem . -Directory -force -Exclude $generalExclude -erroraction 'silentlycontinue' | Where-Object {$_.Attributes.To
String() -Like "*ReparsePoint*"}

# Remove symoblic link
cmd /c rmdir $a

#Timeout Command
function Timeout-Command {
	param (
		[scriptblock] $Command,
		[int] $Timeout
	)
	
	# Start Job
	$job = Start-Job -ScriptBlock $Command

	# Wait for job to complete with timeout (in seconds)
	Wait-Job -Job $job -Timeout $Timeout > $NULL

	# Check to see if any jobs are still running and stop them
	if ($job.State -ne "Completed") {
		Stop-Job $job > $NULL
		
		return $true # Command Timed out
	}
	else {
		return $false # Command executed
	}
}

# Get Free Space
gwmi Win32_LogicalDisk -Filter "DeviceID='C:'" | select Name, FileSystem,FreeSpace,BlockSize,Size | % {$_.BlockSize=(($_.FreeSpace)/($_.Size))*100;$_.FreeSpace=($_.FreeSpace/1GB);$_.Size=($_.Size/1GB);$_}| Format-Table Name, @{n='FS';e={$_.FileSystem}},@{n='Free, Gb';e={'{0:N2}'-f
$_.FreeSpace}}, @{n='Free,%';e={'{0:N2}'-f $_.BlockSize}} -AutoSize