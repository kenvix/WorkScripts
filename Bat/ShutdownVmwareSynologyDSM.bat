@echo off
title ShutdownVmwareSynologyDSM
echo Shuting Down Synology DSM VM
echo.
echo This script will shut down the Synology DSM VM on VMware Workstation.
echo Make sure to run this script with administrative privileges.
echo.
echo Shutting down Synology DSM VM...
echo.
"%programfiles(x86)%\VMware\VMware Workstation\vmrun.exe" -T ws stop "C:\VM\DS918\DS918.vmx"
echo.
echo Synology DSM VM has been shut down.