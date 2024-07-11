@echo off
title Assign IP for WSL2
cd /d %~dp0
echo Launching WSL2...
wsl -d Ubuntu2 -u root ifconfig

echo Setting firewall rules...
powershell.exe -File "C:\Work-Station\Scripts\Bat\DisableWsl2Firewall.ps1"

echo Assing IP for WSL2...
wsl -d Ubuntu2 -u root ip addr add 192.0.0.2/29 broadcast 192.168.0.7 dev eth0 label eth0:1
netsh interface ip add address "vEthernet (WSL)" 192.0.0.1 255.255.255.248
WSLAttachSwitch.exe --mac 9e:d5:8b:58:85:a7  Ethernet-Virt

wsl -d Ubuntu2 -u root "/mnt/c/Work-Station/Scripts/Shell/WslSetNetworkMetric.sh"

WSLHostPatcher.exe

rem echo Disable eth0 to avoid network issues...
rem wsl -d Ubuntu2 -u root ip link set down dev eth0

echo All done !
wsl -d Ubuntu2