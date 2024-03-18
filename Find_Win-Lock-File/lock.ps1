# Define the variable with a default value
$fileToCheck = "C:\log\selling_log.txt"

# Check if an input argument is provided, if yes, use it instead
if ($args.Count -gt 0) {
    $fileToCheck = $args[0]
}
$folderToCheck = Get-Item $fileToCheck | ForEach-Object { $_.Directory.FullName }

# Get the directory where the script is located
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

# Create a new lock_result.log file with date and time in the script directory
$logFilePath = "$scriptDirectory\lock_result_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$null = New-Item -ItemType File -Path $logFilePath -Force


Write-Host "Checking File for Locked Status"
"$(Get-Date -Format 'yyyyMMdd_HHmmss')" | Out-File -Append -FilePath $logFilePath
"" | Out-File -Append -FilePath $logFilePath
"Checking File for Locked Status" | Out-File -Append -FilePath $logFilePath
"" | Out-File -Append -FilePath $logFilePath

$lockedProcesses = Get-Process | Where-Object {
    $_.Modules | ForEach-Object { $_.FileName -eq $fileToCheck }
}

if ($lockedProcesses) {
    $lockedProcesses | ForEach-Object {
        "[$(Get-Date)] Process '$($_.ProcessName) : PID $($_.Id)' is holding the file." | Out-File -Append -FilePath $logFilePath
    }
} else {
    "[$(Get-Date)] File '$fileToCheck' is not in use and can be removed." | Out-File -Append -FilePath $logFilePath
}


Write-Host "Checking Parent Folder for any other lockouts"
"" | Out-File -Append -FilePath $logFilePath
"Checking Parent Folder for any other lockouts" | Out-File -Append -FilePath $logFilePath
"" | Out-File -Append -FilePath $logFilePath
# Adding folder check
$folderProcesses = Get-Process | Where-Object {
    $_.Modules | ForEach-Object { $_.FileName -like "$folderToCheck\*" }
}

if ($folderProcesses) {
    $folderProcesses | ForEach-Object {
        "[$(Get-Date)] Process '$($_.ProcessName) : PID $($_.Id)' is using files in the folder." | Out-File -Append -FilePath $logFilePath
    }
} else {
    "[$(Get-Date)] Folder '$folderToCheck' is not in use by any processes." | Out-File -Append -FilePath $logFilePath
}
Write-Host "Report found here: $logFilePath "
