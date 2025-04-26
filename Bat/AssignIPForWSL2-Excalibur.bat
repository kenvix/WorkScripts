@echo off
title Assign IP for WSL2
cd /d %~dp0
echo Launching WSL2...
wsl -d Ubuntu2 -u root ifconfig

echo Setting firewall rules...
powershell.exe -File "C:\Work-Station\Scripts\Bat\DisableWsl2Firewall.ps1"

echo Assing IP for WSL2...
wsl -d Ubuntu2 -u root sleep 3s; ip addr add 192.0.0.2/29 broadcast 192.168.0.7 dev eth0 label eth0:1
netsh interface ip add address "vEthernet (WSL)" 192.0.0.1 255.255.255.248
WSLAttachSwitch.exe --mac 9e:d5:8b:58:85:a7  Ethernet-Virt
@REM WSLAttachSwitch.exe --mac 9e:d5:8b:58:85:a8  Ethernet-Virt

echo Setting network metric...
wsl -d Ubuntu2 -u root "/mnt/c/Work-Station/Scripts/Shell/WslSetNetworkMetric.sh"
@REM wsl -d Ubuntu2 -u root ip link set dev eth1 address 9e:d5:8b:58:85:a7
WSLHostPatcher.exe

rem echo Disable eth0 to avoid network issues...
rem wsl -d Ubuntu2 -u root ip link set down dev eth0

echo All done !

:loop
rem 运行 WSL 并检查退出码
wsl -d Ubuntu2
EXIT /B %ERRORLEVEL%

@REM if %errorlevel% neq 0 (
@REM     echo 程序退出码不是 0，10 秒后重启...
@REM     timeout /t 10
@REM     goto loop
@REM )
@REM echo 程序正常退出。