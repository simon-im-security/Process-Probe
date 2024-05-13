# Author: Simon Im
# Date: 13th May 2024
# Version: 1.2
# Title: Process Probe
# Description: This script captures a snapshot of running processes before and after opening Task Manager,
#              then compares the two lists to identify any discrepancies.

# Function to list all processes
function Get-Processes {
    Get-Process | Select-Object Id, ParentId, Path
}

# Function to close Task Manager if it's open
function Close-TaskManager {
    if (Get-Process -Name "Taskmgr" -ErrorAction SilentlyContinue) {
        Write-Host "Closing Task Manager..."
        Stop-Process -Name "Taskmgr" -Force
        Start-Sleep -Seconds 2
    }
}

# Function for logging
function Log-Message {
    param (
        [string]$Message
    )
    Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
}

# Introduction
Log-Message "Process Probe - Version 1.2"
Log-Message "Author: Simon Im"
Log-Message "Date: 13th May 2024"
Log-Message "Description: This script captures a snapshot of running processes before and after opening Task Manager,"
Log-Message "             then compares the two lists to identify any discrepancies."

# Close Task Manager if it's already open
Close-TaskManager

# Capture initial list of processes
Log-Message "Capturing initial list of processes..."
$initialProcesses = Get-Processes

# Start Task Manager
Log-Message "Opening Task Manager..."
Start-Process "taskmgr.exe" -NoNewWindow

# Wait for Task Manager to open
Log-Message "Waiting for Task Manager to open..."
Start-Sleep -Seconds 5

# Capture list of processes after Task Manager opens
Log-Message "Capturing list of processes after Task Manager opens..."
$afterProcesses = Get-Processes

# Compare initial and after lists to find discrepancies
Log-Message "Comparing processes..."
$differences = Compare-Object -ReferenceObject $initialProcesses -DifferenceObject $afterProcesses -Property Id, ParentId, Path | Where-Object { $_.SideIndicator -eq '=>' -or $_.SideIndicator -eq '<=' }

# Generate unique output file name
$outputFile = "$env:TEMP\process_differences_$(Get-Date -Format 'yyyyMMddHHmmss').txt"

# Header for the output file
if ($differences.Count -eq 0) {
    "No discrepancies found.`n`nNext Steps:`n1. If you suspect unauthorized activity, investigate further by reviewing system logs.`n2. Consider running antivirus or anti-malware scans to ensure system integrity." | Out-File -FilePath $outputFile
} else {
    "Discrepancies found. Please review the output file $outputFile.`nNote: Some differences might be legitimate. It's recommended to look them up online if unsure.`n`nNext Steps:`n1. Review the differences in the output file to identify any suspicious processes.`n2. Research any unfamiliar processes online to determine their legitimacy. Websites like ProcessLibrary.com can be helpful.`n3. If suspicious, take appropriate action such as terminating the process or seeking further assistance." | Out-File -FilePath $outputFile
}

# Save differences to the unique file
Log-Message "Saving differences to $outputFile..."
$differences | Out-File -FilePath $outputFile -Append

# Log completion message
Log-Message "Process comparison completed. Output saved to $outputFile"

# Open the file displaying the differences
Log-Message "Opening $outputFile..."
Start-Process $outputFile
