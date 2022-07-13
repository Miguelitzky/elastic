cls
$cylerianPath = Test-Path 'C:\Program Files\Cylerian'
$elasticPath = Test-Path 'C:\Program Files\Elastic'
$filebeatPath = Test-Path 'C:\Program Files\Filebeat'

if(Get-Service | ?{$_.Name -like "*cagent*"})
{
    Write-Host "Cylerian service exists:  True"
    Write-Host "Cylerian path exists:    " $cylerianPath
}
else{
    Write-Host "Cylerian service exists:  False"
    Write-Host "Cylerian path exists:    " $cylerianPath
    }

Write-Host ""

if(Get-Service | ?{$_.Name -like "*Elastic*"})
{
    Write-Host "Elastic service exists:   True"
    Write-Host "Elastic path exists:     " $elasticPath
}
else{
    Write-Host "Elastic service exists:   False"
    Write-Host "Elastic path exists:     " $elasticPath
    }

Write-Host ""

if(Get-Service | ?{$_.Name -like "*Filebeat*"})
{
    Write-Host "Filebeat service exists:  True"
    Write-Host "Filebeat path exists:    " $filebeatPath
}
else{
    Write-Host "Filebeat service exists:  False"
    Write-Host "Filebeat path exists:    " $filebeatPath
    }

