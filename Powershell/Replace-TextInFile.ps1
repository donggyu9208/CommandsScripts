$path = '.\web.config'
$a = '<add name="X-Frame-Options" value="sameorigin" />'
$b = '<add name="X-Frame-Options" value="sameorigin" /><add name="Access-Control-Allow-Headers" value="*" />'
$newcontent = (get-Content -path $path) -replace $a, $b
$newcontent | set-content -Path $path