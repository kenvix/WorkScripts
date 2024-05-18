@echo off
cd /d "%~dp0"
REM Get the hostname and store it in a variable
for /f "tokens=* delims=" %%x in ('hostname') do set HOSTNAME=%%x

REM Construct the filename
set FILENAME=AssignIPForWSL2-%HOSTNAME%.bat

REM Check if the file exists
if exist "%FILENAME%" (
    REM Execute the file
    call "%FILENAME%"
) else (
    echo The file %FILENAME% does not exist.
)

