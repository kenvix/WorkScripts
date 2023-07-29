@echo off
cd "C:\Users\Kenvix\AppData\Local\AATUV3\Universal_x86_Tuning_Util_Url_1em4t1cwbdxana5ys0qffhap4urysswy\1.0.0.5"

if exist user.config.bak (
    echo file exists
) else (
    echo file doesnt exist
    exit 17
)
taskkill /f /im "Universal x86 Tuning Utility.exe"
timeout 1
del /f /s /q user.config
ren user.config.bak user.config
start "" "C:\Portable Softwares\!Tools\UXTU\Universal x86 Tuning Utility.exe"
timeout 10
taskkill /f /im "Universal x86 Tuning Utility.exe"