# Download Files
Set-Location 'C:\Windows\Temp'
Start-BitsTransfer -Source https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.2.0-windows-x86_64.zip
Start-BitsTransfer -Source https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-8.2.0-windows-x86_64.zip
Start-BitsTransfer -Source https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.2.0-windows-x86_64.zip

# Create Directories
New-Item -Path 'C:\Program Files\Filebeat' -ItemType Directory -Force
New-Item -Path 'C:\Program Files\Packetbeat' -ItemType Directory -Force

# Extract Everything
Expand-Archive filebeat-8.2.0-windows-x86_64.zip -Force
Expand-Archive packetbeat-8.2.0-windows-x86_64.zip -Force
Expand-Archive elastic-agent-8.2.0-windows-x86_64.zip -Force

# Move files
Copy-Item 'C:\Windows\Temp\filebeat-8.2.0-windows-x86_64/filebeat-8.2.0-windows-x86_64\*' -Destination 'C:\Program Files\Filebeat\'
Copy-Item 'C:\Windows\Temp\packetbeat-8.2.0-windows-x86_64\packetbeat-8.2.0-windows-x86_64\*' -Destination 'C:\Program Files\Packetbeat\'

# Install Elastic   
Set-Location 'C:\Windows\Temp\elastic-agent-8.2.0-windows-x86_64\elastic-agent-8.2.0-windows-x86_64\'
Write-Output "Y" | .\elastic-agent.exe install --url=https://162b9dcabf0e448a8bd6471a98c3a980.fleet.us-east-1.aws.found.io:443 --enrollment-token=RXdWWjFJRUJaeVlCcjVSZVdQWVk6RWZGWjMxTkNUUS1aUmstMklEQXZ3dw==

# Install Filebeat
Set-Location 'C:\Program Files\Filebeat'
& .\install-service-filebeat.ps1

# Install Packetbeat
Set-Location 'C:\Program Files\Packetbeat'
& .\install-service-packetbeat.ps1

## Modify Configuration Files
Add-Content -Path 'C:\Program Files\Filebeat\filebeat.yml' -Value 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'
Add-Content -Path 'C:\Program Files\Filebeat\filebeat.yml' -Value 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'
Add-Content -Path 'C:\Program Files\Packetbeat\packetbeat.yml' -Value 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'
Add-Content -Path 'C:\Program Files\Packetbeat\packetbeat.yml' -Value 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'

# Restart Services
sc.exe stop elastic
sc.exe start elastic
sc.exe stop filebeat
sc.exe start filebeat
sc.exe stop packetbeat
sc.exe start packetbeat
