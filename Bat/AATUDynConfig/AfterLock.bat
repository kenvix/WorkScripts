@echo off
cd "C:\Users\Kenvix\AppData\Local\AATUV3\Universal_x86_Tuning_Util_Url_1em4t1cwbdxana5ys0qffhap4urysswy\1.0.0.5"

if exist user.config.bak (
    echo file exists
    exit 17
) else (
    echo file doesnt exist
)

taskkill /f /im  "Universal x86 Tuning Utility.exe"
timeout 1
ren user.config user.config.bak
copy "%~dp0\user.config" "C:\Users\Kenvix\AppData\Local\AATUV3\Universal_x86_Tuning_Util_Url_1em4t1cwbdxana5ys0qffhap4urysswy\1.0.0.5"
start "" "C:\Portable Softwares\!Tools\UXTU\Universal x86 Tuning Utility.exe"
timeout 10
taskkill /f /im  "Universal x86 Tuning Utility.exe"