###############
## GRAPH API ##
###############
Param(
    $tenantId = "",
    $appServiceObjectID = "", 
    $PermissionsToAdd = @("Reports.Read.All")
)

# Install AzureAD module if not installed
if (-Not(Get-Module -ListAvailable -Name AzureAD)) {
    Install-Module AzureAD -Force
}

# Check if connected to the target Azure AD Tenant
try { 
    $tenantDetail = Get-AzureADTenantDetail 
} 
catch [Microsoft.Open.Azure.AD.CommonLibrary.AadNeedAuthenticationException] 
{ 
    Write-Host "You're not connected."; 
    Connect-AzureAD -TenantId $tenantId;
    $tenantDetail = Get-AzureADTenantDetail 
}

if ($tenantDetail.ObjectId -ne $tenantId) {
    Write-Host "You're not connected to the tenant: " $tenantId; 
    Connect-AzureAD -TenantId $tenantId;
}


# Managed Identity for the SCIM App Service | Found in App Service -> Identity 
$ManagedIdentitiesServicePrincipal = Get-AzureADServicePrincipal -Filter "ObjectId eq `'$appServiceObjectID`'"
if ($ManagedIdentitiesServicePrincipal -eq $null) {
    throw "Managed Identity for the app service is not found. `nApp Service Object ID: $appServiceObjectID "
}

# Resource Name : Microsoft Graph | Resource URI : https://graph.microsoft.com | Application ID : 00000003-0000-0000-c000-000000000000
$GraphAppId = "00000003-0000-0000-c000-000000000000"
$GraphServicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$GraphAppId'"

# Permissions
foreach ($PermissionToAdd in $PermissionsToAdd) {
    $AppRole = $GraphServicePrincipal.AppRoles | Where-Object {$_.Value -eq $PermissionToAdd.Trim() -and $_.AllowedMemberTypes -contains "Application"}
    if ($AppRole -eq $null) {
        Write-Error "Invalid Permission `nPermission name: $PermissionToAdd"
    }
    else {
        # Assigns a Graph API service principal to an application role
        try {
            New-AzureAdServiceAppRoleAssignment -ObjectId $ManagedIdentitiesServicePrincipal.ObjectId -PrincipalId $ManagedIdentitiesServicePrincipal.ObjectId -ResourceId $GraphServicePrincipal.ObjectId -Id $AppRole.Id -ErrorAction Stop
        }
        catch {
            if ($_.Exception.ErrorContent.Message.Value.Contains("Permission being assigned already")) {
                Write-Host "`""$AppRole.DisplayName"`"" " Permission is already assigned on the app service"
            }
            else {
                Write-Error $_
            }
        }
    }
}