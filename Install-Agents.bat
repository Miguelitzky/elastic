Rem This script doesn't currently use any variables as it's the first iteration. 

Rem Variables
set "filebeatURL=https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.2.0-windows-x86_64.zip"
set "packetbeatURL=https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-8.2.0-windows-x86_64.zip"
set "elasticURL=https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.2.0-windows-x86_64.zip"
set "elasticSaveAs=C:\Windows\Temp\elastic.zip"
set "filebeatSaveAs=C:\Windows\Temp\filebeat.zip"
set "packetbeatSaveAs=C:\Windows\Temp\packetbeat.zip"
set "filebeatDest=C:\Program Files\Filebeat"
set "packetbeatDest=C:\Program Files\Packetbeat"
set "testDest=C:\Program Files\Test"
set "filebeatExtractedPath=C:\Windows\Temp\filebeat-8.2.0-windows-x86_64"
set "packetbeatExtractedPath=C:\Windows\Temp\packetbeat-8.2.0-windows-x86_64"
set "elasticExtractedPath=C:\Windows\Temp\elastic-agent-8.2.0-windows-x86_64"
Rem Download Files
powershell "Import-Module BitsTransfer; Start-BitsTransfer '%filebeatURL%' '%filebeatSaveAs%' "
powershell "Import-Module BitsTransfer; Start-BitsTransfer '%packetbeatURL%' '%packetbeatSaveAs%' "
powershell "Import-Module BitsTransfer; Start-BitsTransfer '%elasticURL%' '%elasticSaveAs%' "

Rem Extract Files
powershell "Expand-Archive -Path '%filebeatSaveAs%' -DestinationPath C:\Windows\Temp " 
powershell "Expand-Archive -Path '%packetbeatSaveAs%' -DestinationPath C:\Windows\Temp " 
powershell "Expand-Archive -Path '%elasticSaveAs%' -DestinationPath C:\Windows\Temp " 

Rem Create Directories
mkdir "C:\Program Files\Filebeat"
mkdir "C:\Program Files\Packetbeat"

Rem Move Files
powershell "Move-Item -Path C:\Windows\Temp\filebeat-8.2.0-windows-x86_64\* -Destination '%filebeatDest%' "
powershell "Move-Item -Path C:\Windows\Temp\packetbeat-8.2.0-windows-x86_64\* -Destination '%packetbeatDest%' "

Rem Install Elastic
cd %elasticExtractedPath%
powershell "Write-Output "Y" | .\elastic-agent.exe install --url=https://162b9dcabf0e448a8bd6471a98c3a980.fleet.us-east-1.aws.found.io:443 --enrollment-token=RXdWWjFJRUJaeVlCcjVSZVdQWVk6RWZGWjMxTkNUUS1aUmstMklEQXZ3dw=="
powershell "Get-Service"

Rem Restart Elastic services
sc.exe stop "Elastic Agent"
sc.exe start "Elastic Agent" 
sc.exe stop "Elastic Endpoint"
sc.exe start "Elastic Endpoint"

Rem Install Filebeat
cd %filebeatDest%
powershell "& .\install-service-filebeat.ps1"

Rem Configure Filebeat
powershell "Add-Content -Path 'C:\Program Files\Filebeat\filebeat.yml' -Value 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'"
powershell "Add-Content -Path 'C:\Program Files\Filebeat\filebeat.yml' -Value 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'"

Rem Restart Filebeat Services
sc.exe stop "Filebeat"
sc.exe start "Filebeat"

Rem Install Packetbeat
cd %packetbeatDest%
powershell "& .\install-service-packetbeat.ps1"

Rem Configure Filebeat
powershell "Add-Content -Path 'C:\Program Files\Packetbeat\packetbeat.yml' -Value 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'"
powershell "Add-Content -Path 'C:\Program Files\Packetbeat\packetbeat.yml' -Value 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'"

Rem Restart Filebeat Services
sc.exe stop "Packetbeat"
sc.exe start "Packetbeat"

Rem Cleanup Files
cd C:\Windows\Temp
del *.zip
rmdir %filebeatExtractedPath%
rmdir %packetbeatExtractedPath%
rmdir %elasticExtractedPath%