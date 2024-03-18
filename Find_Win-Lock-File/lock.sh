fileToCheck="/bizstorecard/bizerba/log/selling_log.txt"
folderToCheck=$(dirname "$fileToCheck")

# Get the directory where the script is located
scriptDirectory=$(dirname "$(realpath "$0")")

# Create a new lock_result.log file with date and time in the script directory
logFilePath="$scriptDirectory/lock_result_$(date +'%Y%m%d_%H%M%S').log"
touch "$logFilePath"

echo "Checking File for Locked Status" >> "$logFilePath"
echo "$(date +'%Y%m%d_%H%M%S')" >> "$logFilePath"
echo "" >> "$logFilePath"

# Checking if file is locked
lockedProcesses=$(lsof "$fileToCheck" | tail -n +2 | awk '{print $2}')

if [ -n "$lockedProcesses" ]; then
    echo "[$(date)] Processes holding '$fileToCheck':" >> "$logFilePath"
    for pid in $lockedProcesses; do
        echo "[$(date)] Process '$(ps -p "$pid" -o comm=) : PID $pid'" >> "$logFilePath"
    done
else
    echo "[$(date)] File '$fileToCheck' is not in use and can be removed." >> "$logFilePath"
fi

echo "" >> "$logFilePath"
echo "Checking Parent Folder for any other lockouts" >> "$logFilePath"
echo "" >> "$logFilePath"

# Checking if parent folder is in use by any processes
folderProcesses=$(lsof "$folderToCheck" | tail -n +2 | awk '{print $2}')

if [ -n "$folderProcesses" ]; then
    echo "[$(date)] Processes using files in folder '$folderToCheck':" >> "$logFilePath"
    for pid in $folderProcesses; do
        echo "[$(date)] Process '$(ps -p "$pid" -o comm=) : PID $pid'" >> "$logFilePath"
    done
else
    echo "[$(date)] Folder '$folderToCheck' is not in use by any processes." >> "$logFilePath"
fi

echo "Report found here: $logFilePath"
