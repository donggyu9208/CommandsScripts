# User name from WebDeploy Publish Profile. Use backtick while assigning variable content  
$userName = ""  
# Password from WebDeploy Publish Profile  
$password = ""  
# Encode username and password to base64 string  
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $userName, $password)))  
# Splat all parameters together in $param hash table  
$url = "https://<url>/api/zip/site/wwwroot"
$zipFilePath = "C:\zipfile.zip"  
$param = @{  
            # zipdeploy api url  
            Uri = $url
            Headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}  
            UserAgent = "powershell/1.0"  
            Method = "PUT"  
            # Deployment Artifact Path  
            InFile = $zipFilePath
            ContentType = "multipart/form-data"  
}  

# Invoke REST call  
Invoke-RestMethod @param