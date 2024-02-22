::NOTE: A number of files, services, and processes may or may not exist
::      Please disregard "Not found/Not running" unless you are certain they exist
::
::  Please add or remove "::" from lines as needed for functions
::  The functions are grouped with descriptions provided in "echo" lines
::
::  Run file from any Admin account
@echo off
::---Logging for Verification---:: 
if not "%1"=="STDOUT_TO_FILE"  %0 STDOUT_TO_FILE %*  >>C:\Temp\Dummy\Win_Clean.log 2>&1
shift /1
::---::

Echo %date% - %time% :: ---Begin Windows and "Dummy" Cleanup v4--- ::

echo %date% - %time% :: ---Stopping Services--- ::
:: may report invalid
net stop "Service1"
net stop "Service-2"
cd C:\windows\system32
taskkill /F /T /IM winvnc.exe
taskkill /F /T /IM mediacheck.exe
taskkill /F /T /IM java.exe
taskkill /F /T /IM javaw.exe
taskkill /F /T /IM pythonw.exe

echo %date% - %time% :: ---Remove Touch Configuration--- ::
taskkill /IM eloservice.exe /F
del /s /q /f C:\ProgramData\elo\elotouchcalibrated.txt

echo %date% - %time% :: ---Remove startup:pmon--- ::
taskkill /IM pmonitor.exe /F
del /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\PenMount Monitor.lnk"

Echo %date% - %time% :: ---Clear Logs--- ::
powershell -command "&{Remove-Item -Path "C:\Temp\Dummy\log\*" -recurse -force -Exclude *.xml}"
powershell -command "&{Remove-Item -Path "C:\ProgramData\Dummy\log\*" -recurse -force -Exclude *.xml}"
Echo > C:\ProgramData\Dummy\log\File1.csv
Echo > C:\ProgramData\Dummy\log\File2.csv
del /s /q /f C:\Temp\Dummy\report\*
del /s /q /f C:\Temp\Dummy\response\*
del /s /q /f C:\Temp\Dummy\data\prog.txt
del /s /q /f C:\Temp\Dummy\data\intern\*
Echo %date% - %time% :: ---Reset Count--- ::
Echo "0" > C:\Temp\Dummy\data\intern\no.txt

Echo %date% - %time% :: ---Clean Windows--- ::

::--Only for use in Single Partition images, will extend first partition to full disk size--::
Echo %date% - %time% :: ---Extend partition to full disk size--- ::
(echo rescan
echo select disk 0
echo select vol 0
echo extend
echo exit
) | diskpart 

Echo %date% - %time% :: ---Allow unsigned drivers--- ::
bcdedit /set nointegritychecks on

Echo %date% - %time% :: ---Set timezone to Eastern Standard Time--- ::
tzutil /s "Eastern Standard Time"

Echo %date% - %time% :: ---Turn off Windows Firewall--- ::
netsh advfirewall set allprofiles state off

Echo %date% - %time% :: ---Set power plan to High Performance--- ::
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

Echo %date% - %time% :: ---Disable Sleep mode--- ::
powercfg -change -standby-timeout-ac 0

Echo %date% - %time% :: ---Turn off display timeout--- ::
powercfg -change -monitor-timeout-ac 0

Echo %date% - %time% :: ---Disable User Account Control (UAC) prompts--- ::
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableInstallerDetection /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f

Echo %date% - %time% :: ---Set USB power configuration, disable suspend--- ::
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags" /v "USB Suspend" /t REG_BINARY /d 0000 /f 
:: (On battery: Disabled)
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
:: (Plugged in: Disabled)
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

Echo %date% - %time% :: ---Disable Hibernate, reclaiming disk space from unused feature--- ::
powercfg.exe /hibernate off
Echo %date% - %time% :: --Force set pagefile space to 2GB-4GB, avoid disk space loss from windows auto-management and improve caching time--- ::
wmic computersystem set AutomaticManagedPagefile=False
wmic pagefileset set InitialSize=2048,MaximumSize=4096
wmic pagefileset where name="_Total" set InitialSize=2048, MaximumSize=4096 

Echo %date% - %time% :: ---Clean */%TEMP% folders--- ::
powershell -command "&{Remove-Item -Path "C:\Users\*\AppData\Local\Temp\*" -recurse -force}"

Echo %date% - %time% ::--- Set Windows Input Language to US-English, place German second--- ::
reg add "HKEY_CURRENT_USER\Keyboard Layout\Preload" /v 1 /t REG_SZ /d "00000409" /f reg delete "HKEY_CURRENT_USER\Keyboard Layout\Preload" /va /f 

Echo %date% - %time% :: ---Disable IPv6 technologies--- ::
netsh interface ipv6 set global state=disabled
netsh interface teredo set state disabled
netsh interface ipv6 6to4 set state state=disabled undoonstop=disabled
netsh interface ipv6 isatap set state state=disabled
powershell -command "&{Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6}

:: Set network profile to private
netsh advfirewall set currentprofile private

:: Allow file and printer sharing on all networks
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes

:: Enable SMB
sc config lanmanworkstation start=auto
sc config lanmanserver start=auto

:: Start the SMB service
net start lanmanworkstation
net start lanmanserver

Echo %date% - %time% :: ---Reclaim disk space from OS via disk manager, and clean/repair OS image--- ::
net start wuauserv
:: Set Variable definition to call 64-bit .exe from 32-bit CMD/bat file
set OS_call=%comspec% /C
if exist %windir%\sysnative\dism.exe set OS_call=%windir%\sysnative\
echo %OS_call%
start "" cleanmgr /verylowdisk
%OS_call%sfc.exe /scannow
%OS_call%dism.exe /online /Cleanup-Image /StartComponentCleanup

Echo %date% - %time% :: ---Diable Windows service "Update"--- ::
net stop wuauserv
sc config "wuauserv" start=disabled
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f

Echo %date% - %time% :: ---Image Clean-up Complete--- :: Error Level = %RETCODE%

Echo %date% - %time% :: ---End Windows Cleanup--- ::
::Echo :: Tool's Dummy specific functions ("Stopping Services" section) derived from 2014 Linux service_cleanupdistr.sh, assumed defunct. ::
::Echo :: This Windows version created by, and provided at discretion of Ethan.R.Hudson@gmail.com ::

goto 2>nul & del "%~f0" & shutdown /r /t 5
