cls
$downloadPath = "C:\Users\" + ([Environment]::UserName) + "\Downloads"
cd $downloadPath
wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.2.0-windows-x86_64.zip -OutFile elastic-agent-8.2.0-windows-x86_64.zip
Expand-Archive .\elastic-agent-8.2.0-windows-x86_64.zip
cd elastic-agent-8.2.0-windows-x86_64\elastic-agent-8.2.0-windows-x86_64
ECHO Y | .\elastic-agent.exe install --url=https://162b9dcabf0e448a8bd6471a98c3a980.fleet.us-east-1.aws.found.io:443 --enrollment-token=Z2hPTHpZQUJqeF9LdEM2ZjFkQUo6eDlsVEs4bkNRWXFCWWc5eXgwTTg1QQ==
cd ../.. 
Remove-Item -Recurse -Force elastic-agent-8.2.0-windows-x86_64*


# Uninstall
#ECHO Y | ./elastic-agent.exe uninstall
#Remove-Item -Recurse -Force 'C:\Program Files\Elastic'