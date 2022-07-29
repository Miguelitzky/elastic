@REM Uninstall Cylerian
wmic product where "name like '%%cylerian%%'" call uninstall /nointeractive
sc.exe stop cagent
sc.exe delete cagent
taskkill /F /IM cagent.exe
taskkill /F /IM cagent_monitor.exe
rmdir /S c:\progra~1\cylerian /Q
