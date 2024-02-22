# Windows Golden Image Cleaning Script

## Overview

This script is designed for cleaning Windows Images on Client machines. Follow the steps below to use the script.

## Usage

1. Transfer the script to the machine via FTP to `C:\Temp\Dummy\`.
2. Connect a physical keyboard to the Client or use VNC.
3. Log out of the user Client and log into user Dummy.
4. Using File Explorer, navigate to and run the file `Win-Clean.bat` as an Administrator.
   - Check the log file if enabled and needed.
5. Turn off or reboot the machine and perform a backup.

## Logging for Verification

This section can be toggled to enable logging by removing "rem" from lines 4 thru 6 of the .bat file. A file named `C:\Temp\Dummy\Win_Clean.log` will be created if enabled, allowing for inspection of issues. If the file is run more than once, expect "file not found" entries.

## Stopping Services

This step attempts to end services and programs that may or may not be present in the system, intended for releasing locks on files being removed further down in the script.

## Remove Touch Configuration

This step removes touch configuration settings.

## Remove startup:pmon

Case-specific use, injected for use on old ELO enabled systems but may be used elsewhere if needed.

## Clear Logs

The main event,

- "del" lines are used to completely clear contents of a folder.
- "power … -Exclude *.xml" is used when clearing all items in a folder except a single extension type.
- "Echo > " is used to recreate a file with null contents as needed for Client use. If clearing the Log folder via PowerShell -Exclude, be sure to recreate Device start and stop.CSV files.

Additional lines may be added for use-case. If a function would be applicable to more than two customers or is in response to a bug/issue, please provide these new lines for addition to the standard script.

## Clean Windows

This section is again case-specific and intended to reduce disk usage.

- **DISM:** Currently, a one-liner is not apparent for broad use.
- **SFC:** Filesystem integrity, can clear "Windows Update" loops.
