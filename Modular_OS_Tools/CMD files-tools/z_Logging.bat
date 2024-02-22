@echo off
setlocal enabledelayedexpansion
:: START DATE ::
    :: Get Date, Time and Timezone
    :: This approach ensures precision and avoids reliance on user preference settings.

    :: Extracting components from the System
    for /f "delims=" %%Y in ('wmic path win32_operatingsystem get LocalDateTime ^| find "."') do set "systemtime=%%Y"
    set "currentYear=!systemtime:~0,4!"
    set "numericMonth=!systemtime:~4,2!"
    set "currentDay=!systemtime:~6,2!"
    set "currentHour=!systemtime:~8,2!"
    set "currentMinute=!systemtime:~10,2!"
    :: Convert numeric month to three-letter abbreviation
    for /f "tokens=%numericMonth%" %%M in ("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec") do set "currentMonth=%%M"
    :: Get Timezone like (UTC-05:00)
    for /f "tokens=3" %%A in ('systeminfo 2^>nul ^| find "Time Zone"') do set "timezoneInfo=%%A"
    ::Set Friendly Variables
    set "currDate=!currentYear!!currentMonth!!currentDay!"
    set "currTime=!currentHour!!currentMinute!"
    set "datetime=!currDate!-!currTime!"

    :: Validate all Variables

    rem echo Year  : %currentYear%
    rem echo Month : %currentMonth%
    rem echo Day   : %currentDay%
    rem echo Hour  : %currentHour%
    rem echo Minute: %currentMinute%
    rem echo Offset: %timezoneInfo%
    rem echo.
    rem echo Date  : %currDate%
    rem echo Time  : %currTime%
    rem echo Full  : %datetime% %timezoneInfo%
    echo.
:: END DATE ::

:: START LOGGING SETUP ::
    :: Get the directory of the current script
    set "scriptDir=%~dp0"

    :: Enclose scriptDir in double quotes to handle spaces
    set "scriptDir=!scriptDir!"
    echo %scriptDir%

    :: Check if the log directory exists
    if not exist "!scriptDir!log\" (
        :: If not exist, create the log directory
        echo Log directory not found, creating...
        mkdir "!scriptDir!log\"
    ) else (
        echo Log directory exists.
    )

    :: Set logFile variable before using it
    set "logFilePath=%scriptDir%log\logfile_!datetime!.log"
    echo logFilePath value = %logFilePath%
    :: END LOGGING SETUP ::

:: Ensure log always created
    ::This sounds obvious, after the fact :)
echo. > !logFilePath!
    echo =========================================================================== >> "%logFilePath%"
    echo ============= Begin Logging at %datetime% %timezoneInfo% ============= >> "%logFilePath%"
    echo =========================================================================== >> "%logFilePath%"
    :: Start capturing logs
:WORK
(
echo Begin Work

:: Example void block capturing output to log
echo Inside the void block
echo Additional logs or commands
echo Any command outputs or variables can be redirected here


goto EXIT
echo You should not see me!
) >> "%logFilePath%" 2>&1
:EXIT
(
echo ===========================================================================
echo ============================ Finish Logging ============================
echo ===========================================================================
) >> "%logFilePath%" 2>&1
endlocal
rem Pause
goto :EOF
