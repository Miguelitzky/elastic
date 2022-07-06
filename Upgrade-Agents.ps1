# Variables
$cloudAuth = 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'
$cloudId = 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'
$filebeatPath = 'C:\Program Files\Filebeat'
$downloadPath = "C:\Windows\Temp"
$filebeatextractedPath = "filebeat-8.2.0-windows-x86_64/filebeat-8.2.0-windows-x86_64"
$packetbeatPath = 'C:\Program Files\Packetbeat'
$packetbeatextractedPath = "packetbeat-8.2.0-windows-x86_64\packetbeat-8.2.0-windows-x86_64"
$elasticExtractedPath = "elastic-agent-8.2.0-windows-x86_64\elastic-agent-8.2.0-windows-x86_64"

# Download Files
Set-Location $downloadPath
Start-BitsTransfer -Source https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.2.0-windows-x86_64.zip
Start-BitsTransfer -Source https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-8.2.0-windows-x86_64.zip
Start-BitsTransfer -Source https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.2.0-windows-x86_64.zip

# Create Directories
New-Item -Path $fileBeatPath -ItemType Directory -Force
New-Item -Path $packetBeatPath -ItemType Directory -Force

# Extract Everything
Expand-Archive filebeat-8.2.0-windows-x86_64.zip -Force
Expand-Archive packetbeat-8.2.0-windows-x86_64.zip -Force
Expand-Archive elastic-agent-8.2.0-windows-x86_64.zip -Force

# Move files
Copy-Item $downloadPath"\"$filebeatextractedPath"\*" -Destination $fileBeatPath
Copy-Item $downloadPath"\"$packetbeatextractedPath"\*" -Destination $packetBeatPath

# Install Elastic
Set-Location $downloadPath"\"$elasticExtractedPath
Write-Output "Y" | .\elastic-agent.exe install --url=https://162b9dcabf0e448a8bd6471a98c3a980.fleet.us-east-1.aws.found.io:443 --enrollment-token=RXdWWjFJRUJaeVlCcjVSZVdQWVk6RWZGWjMxTkNUUS1aUmstMklEQXZ3dw==

# Install Filebeat
Set-Location $filebeatPath
& .\install-service-filebeat.ps1

# Install Packetbeat
Set-Location $packetbeatPath
& .\install-service-packetbeat.ps1

## Modify Configuration Files
Add-Content -Path $filebeatPath"\filebeat.yml" -Value $cloudId
Add-Content -Path $filebeatPath"\filebeat.yml" -Value $cloudAuth
Add-Content -Path $packetbeatPath"\packetbeat.yml" -Value $cloudId
Add-Content -Path $packetbeatPath"\packetbeat.yml" -Value $cloudAuth

# Restart Services
sc.exe stop elastic
sc.exe start elastic
sc.exe stop filebeat
sc.exe start filebeat
sc.exe stop packetbeat
sc.exe start packetbeat
