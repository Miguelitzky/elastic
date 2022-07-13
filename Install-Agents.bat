Rem Fleet Agent Variables
set "fleetConfig='--url=https://162b9dcabf0e448a8bd6471a98c3a980.fleet.us-east-1.aws.found.io:443 --enrollment-token=MFJ1djFJRUJaeVlCcjVSZUlIZFo6NS1ONy1QUFNSNksyZXlFSkpuNlVuUQ=='"

Rem Variables
set "filebeatURL=https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.2.0-windows-x86_64.zip"
set "packetbeatURL=https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-8.2.0-windows-x86_64.zip"
set "winlogbeatURL=https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.2.0-windows-x86_64.zip"
set "elasticURL=https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.2.0-windows-x86_64.zip"
set "tempDir=C:\Windows\Temp\"
set "elasticSaveAs=C:\Windows\Temp\elastic.zip"
set "filebeatSaveAs=C:\Windows\Temp\filebeat.zip"
set "packetbeatSaveAs=C:\Windows\Temp\packetbeat.zip"
set "winlogbeatSaveAs=C:\Windows\Temp\winlogbeat.zip"
set "filebeatDest=C:\Program Files\Filebeat"
set "packetbeatDest=C:\Program Files\Packetbeat"
set "winlogbeatDest=C:\Program Files\Winlogbeat"
set "filebeatExtractedPath=C:\Windows\Temp\filebeat-8.2.0-windows-x86_64"
set "packetbeatExtractedPath=C:\Windows\Temp\packetbeat-8.2.0-windows-x86_64"
set "elasticExtractedPath=C:\Windows\Temp\elastic-agent-8.2.0-windows-x86_64"
set "winlogbeatExtractedPath=C:\Windows\Temp\winlogbeat-8.2.0-windows-x86_64"

Rem Download Files
powershell "Import-Module BitsTransfer; Start-BitsTransfer '%filebeatURL%' '%filebeatSaveAs%' "
powershell "Import-Module BitsTransfer; Start-BitsTransfer '%packetbeatURL%' '%packetbeatSaveAs%' "
powershell "Import-Module BitsTransfer; Start-BitsTransfer '%winlogbeatURL%' '%winlogbeatSaveAs%' "
powershell "Import-Module BitsTransfer; Start-BitsTransfer '%elasticURL%' '%elasticSaveAs%' "

Rem Extract Files
powershell "Expand-Archive -Path '%filebeatSaveAs%' -DestinationPath '%tempDir%' " 
powershell "Expand-Archive -Path '%packetbeatSaveAs%' -DestinationPath '%tempDir%' " 
powershell "Expand-Archive -Path '%winlogbeatSaveAs%' -DestinationPath '%tempDir%' "
powershell "Expand-Archive -Path '%elasticSaveAs%' -DestinationPath '%tempDir%' " 

Rem Create Directories
mkdir "'%filebeatDest%'"
mkdir "'%packetbeatDest%'"
mkdir "'%winlogbeatDest%'"

Rem Move Files
powershell "Move-Item -Path '%filebeatExtractedPath%\*' -Destination '%filebeatDest%' "
powershell "Move-Item -Path '%packetbeatExtractedPath%\*' -Destination '%packetbeatDest%' "
powershell "Move-Item -Path '%winlogbeatExtractedPath%\*' -Destination '%winlogbeatDest%' "

Rem Install Elastic
cd %elasticExtractedPath%
powershell "'%elasticExtractedPath%\elastic-agent.exe' install -f '%fleetConfig%' "
powershell "Start-Sleep -Seconds 5"
Rem Restart Elastic services
sc.exe start "Elastic Agent" 
sc.exe start "Elastic Endpoint"

Rem Install Filebeat
cd %filebeatDest%
powershell "& .\install-service-filebeat.ps1"

Rem Configure Filebeat
powershell "Add-Content -Path 'C:\Program Files\Filebeat\filebeat.yml' -Value 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'"
powershell "Add-Content -Path 'C:\Program Files\Filebeat\filebeat.yml' -Value 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'"

Rem Start Filebeat Services
sc.exe start "Filebeat"

Rem Install Packetbeat
cd %packetbeatDest%
powershell "& .\install-service-packetbeat.ps1"

Rem Configure Packetbeat
powershell "Add-Content -Path 'C:\Program Files\Packetbeat\packetbeat.yml' -Value 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'"
powershell "Add-Content -Path 'C:\Program Files\Packetbeat\packetbeat.yml' -Value 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'"

Rem Start Filebeat Services
sc.exe start "Packetbeat"

Rem Install Winlogbeat
cd %winlogbeatDest%
powershell "Remove-Item -Path 'C:\Program Files\Winlogbeat\winlogbeat.yml' -Force"
powershell "Start-BitsTransfer -Source https://raw.githubusercontent.com/arcas-risk/elastic/main/winlogbeat.yml -Destination 'C:\Program Files\Winlogbeat\winlogbeat.yml' "
powershell "& .\install-service-winlogbeat.ps1"

Rem Start Winlogbeat Services
sc.exe start winlogbeat

Rem Nubeva Install
powershell "Start-BitsTransfer -Source https://raw.githubusercontent.com/arcas-risk/elastic/main/nubeva/nubeva-install.bat -Destination C:\Windows\Temp\nubeva-install.bat"
powershell "Start-BitsTransfer -Source https://raw.githubusercontent.com/arcas-risk/elastic/main/nubeva/Nubeva-RN-Sensor.msi -Destination C:\Windows\Temp\Nubeva-RN-Sensor.msi"
powershell "C:\Windows\Temp\nubeva-install.bat"

Rem Remove Cylerian
wmic product where "name like '%%cylerian%%'" call uninstall /nointeractive
sc.exe stop cagent
sc.exe delete cagent
taskkill /F /IM cagent.exe
taskkill /F /IM cagent_monitor.exe
rmdir /S c:\progra~1\cylerian /Q

Rem Cleanup Files
cd C:\Windows\Temp
powershell "Remove-Item -Path '%filebeatExtractedPath%' -Force"
powershell "Remove-Item -Path '%packetbeatExtractedPath%' -Force"
powershell "Remove-Item -Path '%winlogbeatExtractedPath%' -Force"
powershell "Remove-Item -Path '%elasticExtractedPath%' -Force" 
powershell "Remove-Item -Path '%filebeatSaveAs%' -Force" 
powershell "Remove-Item -Path '%packetbeatSaveAs%' -Force" 
powershell "Remove-Item -Path '%winlogbeatSaveAs%' -Force" 
powershell "Remove-Item -Path '%elasticSaveAs%' -Force"