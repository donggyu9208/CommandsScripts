<#
.Synopsis

   Get IIS WebSite status

.DESCRIPTION

   The function would provide IIS Website status

.EXAMPLE

   Get-IISsite -Server server1,server2 -web "Default Web Site"


.FUNCTIONALITY

   It uses Microsoft.Web.Administration assembly to get the status
#>

function Get-IISsite {

  [CmdletBinding()]

  param
  (

    [string[]]$Server,
    [String]$web

  )

#region loadAssembly 

[Reflection.Assembly]::LoadWithPartialName('Microsoft.Web.Administration')

#endregion loadAssembly

foreach ($s in $server)

{


$sm = [Microsoft.Web.Administration.ServerManager]::OpenRemote($s)

$site = $sm.sites["$web"]

$status = $site.state


      $info = @{
        'Site Name'=$web;
        'Status'=$status;
        'Server'=$S;
      }

      Write-Output (New-Object –Typename PSObject –Prop $info)
      
      }

      
    }
  



