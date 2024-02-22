@echo off
setlocal enabledelayedexpansion

set "target=127.0.0.1"
set "pingCount=10"
set "firstNumericTTL="

for /l %%i in (1, 1, %pingCount%) do (
    for /f "tokens=9 delims== " %%a in ('ping -n 1 !target! ^| find "TTL=" ^| findstr /r "[0-9]"') do (
        set "ttl=%%a"
        if "!ttl!" neq "TTL" if not defined firstNumericTTL (
            set "firstNumericTTL=!ttl!"
            echo TTL: !firstNumericTTL!
        )
    )
)

endlocal
