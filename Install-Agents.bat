Rem Variables
@REM set "filebeatURL=https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.2.0-windows-x86_64.zip"
@REM set "packetbeatURL=https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-8.2.0-windows-x86_64.zip"
@REM set "winlogbeatURL=https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.2.0-windows-x86_64.zip"
set "elasticURL=https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.2.0-windows-x86_64.zip"

set "elasticSaveAs=C:\Windows\Temp\elastic.zip"
@REM set "filebeatSaveAs=C:\Windows\Temp\filebeat.zip"
@REM set "packetbeatSaveAs=C:\Windows\Temp\packetbeat.zip"
@REM set "winlogbeatSaveAs=C:\Windows\Temp\winlogbeat.zip"

@REM set "filebeatDest=C:\Program Files\Filebeat"
@REM set "packetbeatDest=C:\Program Files\Packetbeat"
@REM set "winlogbeatDest=C:\Program Files\Winlogbeat"
@REM set "filebeatExtractedPath=C:\Windows\Temp\filebeat-8.2.0-windows-x86_64"
@REM set "packetbeatExtractedPath=C:\Windows\Temp\packetbeat-8.2.0-windows-x86_64"
set "elasticExtractedPath=C:\Windows\Temp\elastic-agent-8.2.0-windows-x86_64"
@REM set "winlogbeatExtractedPath=C:\Windows\Temp\winlogbeat-8.2.0-windows-x86_64"

Rem Download Files
@REM powershell "Import-Module BitsTransfer; Start-BitsTransfer '%filebeatURL%' '%filebeatSaveAs%' "
@REM powershell "Import-Module BitsTransfer; Start-BitsTransfer '%packetbeatURL%' '%packetbeatSaveAs%' "
@REM powershell "Import-Module BitsTransfer; Start-BitsTransfer '%winlogbeatURL%' '%winlogbeatSaveAs%' "
powershell "Import-Module BitsTransfer; Start-BitsTransfer '%elasticURL%' '%elasticSaveAs%' "

@REM Rem Extract Files
@REM powershell "Expand-Archive -Path '%filebeatSaveAs%' -DestinationPath C:\Windows\Temp " 
@REM powershell "Expand-Archive -Path '%packetbeatSaveAs%' -DestinationPath C:\Windows\Temp " 
@REM powershell "Expand-Archive -Path '%winlogbeatSaveAs%' -DestinationPath C:\Windows\Temp "
powershell "Expand-Archive -Path '%elasticSaveAs%' -DestinationPath C:\Windows\Temp " 

Rem Create Directories
mkdir "C:\Program Files\Filebeat"
mkdir "C:\Program Files\Packetbeat"
mkdir "C:\Program Files\Winlogbeat"

Rem Move Files
powershell "Move-Item -Path C:\Windows\Temp\filebeat-8.2.0-windows-x86_64\* -Destination '%filebeatDest%' "
powershell "Move-Item -Path C:\Windows\Temp\packetbeat-8.2.0-windows-x86_64\* -Destination '%packetbeatDest%' "
powershell "Move-Item -Path C:\Windows\Temp\winlogbeat-8.2.0-windows-x86_64\* -Destination '%winlogbeatDest%' "

Rem Install Elastic
cd %elasticExtractedPath%
powershell "C:\Windows\Temp\elastic-agent-8.2.0-windows-x86_64\elastic-agent.exe install -f --url=https://162b9dcabf0e448a8bd6471a98c3a980.fleet.us-east-1.aws.found.io:443 --enrollment-token=RXdWWjFJRUJaeVlCcjVSZVdQWVk6RWZGWjMxTkNUUS1aUmstMklEQXZ3dw=="

@REM Rem Restart Elastic services
@REM sc.exe stop "Elastic Agent"
@REM sc.exe start "Elastic Agent" 
@REM sc.exe stop "Elastic Endpoint"
@REM sc.exe start "Elastic Endpoint"

@REM Rem Install Filebeat
@REM cd %filebeatDest%
@REM powershell "& .\install-service-filebeat.ps1"

@REM Rem Configure Filebeat
@REM powershell "Add-Content -Path 'C:\Program Files\Filebeat\filebeat.yml' -Value 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'"
@REM powershell "Add-Content -Path 'C:\Program Files\Filebeat\filebeat.yml' -Value 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'"

@REM Rem Start Filebeat Services
@REM sc.exe start "Filebeat"

@REM Rem Install Packetbeat
@REM cd %packetbeatDest%
@REM powershell "& .\install-service-packetbeat.ps1"

@REM Rem Configure Packetbeat
@REM powershell "Add-Content -Path 'C:\Program Files\Packetbeat\packetbeat.yml' -Value 'cloud.id: "Baseline-Data-Retention-Cluster:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRkZGEzNmNmYjI3MDE0MjI2OWU1MTZjM2JmY2M5ODE0NiQ4NzJmMTcxOTVhNWI0M2FlYWM4YjhkMGFiOWY4NDg2OQ=="'"
@REM powershell "Add-Content -Path 'C:\Program Files\Packetbeat\packetbeat.yml' -Value 'cloud.auth: "elastic:P29ajGcQDKlJfXjvTca5Bli6"'"

@REM Rem Start Filebeat Services
@REM sc.exe start "Packetbeat"

@REM Rem Install Winlogbeat
@REM cd %winlogbeatDest%
@REM powershell "Remove-Item -Path 'C:\Program Files\Winlogbeat\winlogbeat.yml' -Force"
@REM powershell "Start-BitsTransfer -Source https://raw.githubusercontent.com/arcas-risk/elastic/main/winlogbeat.yml -Destination 'C:\Program Files\Winlogbeat\winlogbeat.yml' "
@REM powershell "& .\install-service-winlogbeat.ps1"

@REM Rem Start Winlogbeat Services
@REM sc.exe start winlogbeat

@REM Rem Cleanup Files
@REM cd C:\Windows\Temp
@REM del *.zip
@REM powershell "Remove-Item -Path '%filebeatExtractedPath%' -Force"
@REM powershell "Remove-Item -Path '%packetbeatExtractedPath%' -Force"
@REM powershell "Remove-Item -Path '%winlogbeatExtractedPath%' -Force"
@REM powershell "Remove-Item -Path '%elasticExtractedPath%' -Force" 

@REM Rem Nubeva Install
@REM powershell "Start-BitsTransfer -Source https://raw.githubusercontent.com/arcas-risk/elastic/main/nubeva/nubeva-install.bat -Destination C:\Windows\Temp\nubeva-install.bat"
@REM powershell "Start-BitsTransfer -Source https://raw.githubusercontent.com/arcas-risk/elastic/main/nubeva/Nubeva-RN-Sensor.msi -Destination C:\Windows\Temp\Nubeva-RN-Sensor.msi"
@REM powershell "C:\Windows\Temp\nubeva-install.bat"

@REM Rem Remove Cylerian
@REM wmic product where "name like '%%cylerian%%'" call uninstall /nointeractive
@REM sc.exe stop cagent
@REM sc.exe delete cagent
@REM taskkill /F /IM cagent.exe
@REM taskkill /F /IM cagent_monitor.exe
@REM rmdir /S c:\progra~1\cylerian /Q