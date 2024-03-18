@echo off
setlocal

REM Get the directory of the executing batch file
for %%I in ("%~dp0.") do set "scriptDirectory=%%~fI"

REM Assuming "lock.ps1" is located in the same directory as the executing batch file
set "scriptPath=%scriptDirectory%\lock.ps1"

REM Execute the script with the updated path
powershell -command "Set-ExecutionPolicy Bypass -Scope Process -Force; %scriptPath%"
