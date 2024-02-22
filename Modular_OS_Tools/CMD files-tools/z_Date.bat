@echo off
setlocal enabledelayedexpansion
:: START DATE ::
    :: Get Date, Time and Timezone
    :: This approach ensures precision and avoids reliance on user preference settings.
    :: Dependencies are expected non-issue, modules present in all major Windows OS since WinXPsp2
        :: wmic:LocalDateTime
        :: systeminfo

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

    echo Year  : %currentYear%
    echo Month : %currentMonth%
    echo Day   : %currentDay%
    echo Hour  : %currentHour%
    echo Minute: %currentMinute%
    echo Offset: %timezoneInfo%
    echo.
    echo Date  : %currDate%
    echo Time  : %currTime%
    echo Full  : %datetime% %timezoneInfo%
    echo.

:: END DATE ::