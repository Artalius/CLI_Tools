@echo off
setlocal enabledelayedexpansion

:: INIT Variables
set "source=%~dp0\ipaddr.csv"
set "pingCount=12"
set "firstNumericTTL="

:: Read IP Addresses from ipaddr.csv
for /f "tokens=1 delims=," %%a in (%source%) do (
    set "Remote_IP_Address=%%a"
    if not defined Remote_IP_Address (
        echo Error: IP address not found in %source%!
        exit /b 1
    )

    echo Testing connectivity to !Remote_IP_Address!...

    :: Windows
    for /l %%i in (1, 1, %pingCount%) do (
        rem set "ttl="
        set "firstNumericTTL="
        for /f "tokens=9 delims== " %%b in ('ping -n 1 !Remote_IP_Address! ^| find "TTL=" ^| findstr /r "[0-9]"') do (
            set "ttl=%%b"
            if "!ttl!" neq "TTL" if not defined firstNumericTTL (
                rem echo TTL String: !ttl!
                set "firstNumericTTL=!ttl!"
                rem echo TTL: !firstNumericTTL!
                if !firstNumericTTL! geq 65 (
                    rem echo Operating System: Windows
                    set "OSType=Windows"
                ) else (
                    if !firstNumericTTL! lss 65 (
                        rem echo Operating System: Linux
                        set "OSType=Linux"
                    )
                )
            )
        )
    )
    if not defined firstNumericTTL (
        echo State: Offline ^(Not Reachable or No Reply^)
    )
    if "!OSType!" == "Windows" (
        echo ===Working on ^>!OSType!^< system at ^>%%a^<===
        echo Done with %%a
    )else (
        if "!OSType!" == "Linux" (
            echo ===Working on ^>!OSType!^< system at ^>%%a^<===
            echo Done with %%a
        )
    )

)
endlocal
