@echo off
setlocal enabledelayedexpansion

:: Check if %~dp0 (Script location) is on a network path
:: Get the directory of the current script
set "scriptDir=%~dp0"
echo Script on Drive = %scriptDir:~0,2%
echo.

:: Check if the drive is a network drive
for /f "tokens=2* delims= " %%A in ('net use ^| findstr /i "%scriptDir:~0,2%"') do (
    set "driveLetter=%%A"
    set "networkPath=%%B"
    set "networkName=!networkPath:*\\=!"
    :: Remove anything after the first space in networkName
    for /f "tokens=1* delims= " %%C in ("!networkName!") do set "networkName=%%C"
    
)
        :: Replace removed \\ from PATH, was needed for fixing Var
        set "networkName=\\!networkName!"
if defined driveLetter (
    echo The script is located on a network drive
    echo Local      = %driveLetter% 
    echo Network    = %networkName%
) else (
    echo The script is not on a network drive.
)

endlocal
