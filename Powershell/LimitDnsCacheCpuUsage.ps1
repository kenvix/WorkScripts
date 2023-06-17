#Requires -RunAsAdministrator

$svcPid = Get-WMIObject Win32_service | where Started -eq "True" | where Name -eq "DnsCache" | select ProcessId
$process = Get-Process -Id $svcPid.ProcessId
$process.ProcessorAffinity = 8
$process.PriorityClass="Idle"