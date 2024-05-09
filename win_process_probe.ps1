# Author: Simon Im
# Date: 9th May 2024
# Version: 1.1
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
Log-Message "Process Probe - Version 1.1"
Log-Message "Author: Simon Im"
Log-Message "Date: 9th May 2024"
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

# Save differences to a file
$outputFile = "$env:TEMP\process_differences.txt"
Log-Message "Saving differences to $outputFile..."
$differences | Out-File -FilePath $outputFile

# Log completion message
Log-Message "Process comparison completed. Output saved to $outputFile"

# Open the file displaying the differences
Log-Message "Opening $outputFile..."
Start-Process $outputFile
