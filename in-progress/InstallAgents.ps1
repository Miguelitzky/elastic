Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force

$filebeatPath = 'C:\Program Files\Filebeat'
$downloadPath = "C:\Users\" + ([Environment]::UserName) + "\Downloads"
$filebeatExtractedPath = "filebeat-8.2.0-windows-x86_64/filebeat-8.2.0-windows-x86_64"
$packetbeatPath = 'C:\Program Files\Packetbeat'
$packetbeatExtractedPath = "packetbeat-8.2.0-windows-x86_64\packetbeat-8.2.0-windows-x86_64"
$elasticExtractedPath = "elastic-agent-8.2.0-windows-x86_64\elastic-agent-8.2.0-windows-x86_64"

# Install Elastic
Set-Location $downloadPath
Start-BitsTransfer -Source https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.2.0-windows-x86_64.zip -Destination $downloadPath
Expand-Archive .\elastic-agent-8.2.0-windows-x86_64.zip -Force
Set-Location $elasticExtractedPath
Write-Output "Y" | .\elastic-agent.exe install --url=https://162b9dcabf0e448a8bd6471a98c3a980.fleet.us-east-1.aws.found.io:443 --enrollment-token=Z2hPTHpZQUJqeF9LdEM2ZjFkQUo6eDlsVEs4bkNRWXFCWWc5eXgwTTg1QQ==
Set-Location $downloadPath 
Remove-Item -Recurse -Force elastic-agent-8.2.0-windows-x86_64*
Write-Host "Elastic has been installed." 

Start-Sleep -Seconds 2

# Install Filebeat
New-Item -Path $fileBeatPath -ItemType Directory -Force
Set-Location $downloadPath
Start-BitsTransfer -Source https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.2.0-windows-x86_64.zip
Expand-Archive filebeat-8.2.0-windows-x86_64.zip
Set-Location $filebeatExtractedPath
Copy-Item $downloadPath"\"$filebeatExtractedPath"\*" -Destination $fileBeatPath
& .\install-service-filebeat.ps1
Add-Content -Path $filebeatPath"\filebeat.yml" -Value 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'
Add-Content -Path $filebeatPath"\filebeat.yml" -Value 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'
sc.exe stop filebeat
sc.exe start filebeat

# Install Packetbeat
New-Item -Path $packetBeatPath -ItemType Directory -Force
Set-Location $downloadPath
Start-BitsTransfer -Source https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-8.2.0-windows-x86_64.zip
Expand-Archive packetbeat-8.2.0-windows-x86_64.zip
Set-Location $packetbeatextractedPath
Copy-Item $downloadPath"\"$packetbeatExtractedPath"\*" -Destination $packetBeatPath
& .\install-service-packetbeat.ps1
Add-Content -Path $packetbeatPath"\packetbeat.yml" -Value 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'
Add-Content -Path $packetbeatPath"\packetbeat.yml" -Value 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'
sc.exe stop packetbeat
sc.exe start packetbeat

# Uninstall Cylerian
wmic product where "name like '%%cylerian%%'" call uninstall /nointeractive
sc.exe stop cagent
sc.exe delete cagent
taskkill /F /IM cagent.exe
taskkill /F /IM cagent_monitor.exe
rmdir /S c:\progra~1\cylerian /Q