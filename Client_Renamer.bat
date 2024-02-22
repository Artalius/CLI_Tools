REM Check if the script is running with administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrative privileges. Restarting as administrator...
    timeout 2 >nul
    powershell -Command "Start-Process cmd.exe -ArgumentList '/c %~dpnx0' -Verb RunAs"
    exit
)
@echo off
::---Logging for Verification---:: 
if not "%1"=="STDOUT_TO_FILE"  %0 STDOUT_TO_FILE %*  >C:\temp\log\Windows_Rename.log 2>&1
shift /1
::---::
Echo %date% - %time% :: ---Get the last octet of the IP address from the wireless adapter--- ::
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4 Address"') do (for /f "tokens=4 delims=." %%j in ("%%i") do (set "last_octet=%%j"))
echo Last Octet: %last_octet%

Echo %date% - %time% :: ---Set the new name based on the last octet condition--- ::
REM Max length is 15 Characters
:: if "%last_octet%"=="207" (set "new_name=RFWServer")
:: else if "%last_octet%"=="206" (set "new_name=GreenLaptop")
:: else if "%last_octet%"=="201" (set "new_name=iPhone")
:: else if "%last_octet%"=="191" (set "new_name=GreyLaptop")
:: else if "%last_octet%"=="102" (set "new_name=EmWicon-jjPlus2")
:: else if "%last_octet%"=="101" (set "new_name=EmWicon-jjPlus1")
if "%last_octet%"=="71" (
   set "new_name=MC500ProhTPMWi"
) else if "%last_octet%"=="70" (
   set "new_name=MC500ProCutWi"
) else if "%last_octet%"=="63" (
   set "new_name=XC100ProWi"
) else if "%last_octet%"=="62" (
   set "new_name=XC300ProWi"
) else if "%last_octet%"=="61" (
   set "new_name=XC100ProWi"
) else if "%last_octet%"=="60" (
   set "new_name=XC100nProWi"
) else if "%last_octet%"=="55" (
   set "new_name=K3100Wi"
) else if "%last_octet%"=="52" (
   set "new_name=KH100ProhTPMWi"
) else if "%last_octet%"=="51" (
   set "new_name=KH100ProWi"
) else if "%last_octet%"=="50" (
   set "new_name=KH100nProWi"
) else if "%last_octet%"=="31" (
   set "new_name=MC500ProhTPM"
) else if "%last_octet%"=="30" (
   set "new_name=MC500ProCut"
) else if "%last_octet%"=="23" (
   set "new_name=XC100Pro"
) else if "%last_octet%"=="22" (
   set "new_name=XC300Pro"
) else if "%last_octet%"=="21" (
   set "new_name=XC100Pro"
) else if "%last_octet%"=="20" (
   set "new_name=XC100nPro"
) else if "%last_octet%"=="15" (
   set "new_name=K3100"
) else if "%last_octet%"=="12" (
   set "new_name=KH100ProhTPM"
) else if "%last_octet%"=="11" (
   set "new_name=KH100Pro"
) else if "%last_octet%"=="10" (
   set "new_name=KH100nPro"
) else (
    echo No match found for last octet: %lastOctet%
)

Echo %date% - %time% :: ---Check if a custom name is defined--- ::
if defined new_name (
    Echo %date% - %time% :: ---Rename the computer--- ::
	
echo Current Name: %COMPUTERNAME%
echo New Name: %new_name%
if /i not "%new_name%"=="%COMPUTERNAME%" (

    :: Rename the computer
    wmic computersystem where name="%COMPUTERNAME%" call rename name="%new_name%"
    echo Computer renamed successfully.
    :: Restart the computer for the new name to take effect
    shutdown /r /t 0
) else (
    echo Computer name is already "%new_Name%". No renaming required.
)
) else (
    Echo %date% - %time% :: ---No custom name defined for the last octet %last_octet%. The computer name remains unchanged as: %COMPUTERNAME%.--- ::
)