@echo off
title Assign IP for WSL2
cd /d %~dp0
wsl -d Ubuntu2 -u root ip addr add 192.0.0.2/29 broadcast 192.168.0.7 dev eth0 label eth0:1
netsh interface ip add address "vEthernet (WSL)" 192.0.0.1 255.255.255.248
powershell.exe -NonInteractive -NoLogo -NoProfile -File DisableWsl2Firewall.ps1
