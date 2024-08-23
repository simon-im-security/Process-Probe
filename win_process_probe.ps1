# Title: Process Probe
# Description: This script performs a process scan, comparing snapshots before and after opening Task Manager, and notifies the user via WPF windows. Includes a WPF window for progress and final completion notification.
# Author: Simon Im
# Date: 23rd August 2024
# Version: 2.9

Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName PresentationFramework

# Function to show WPF message box
function Show-WPFMessage {
    param (
        [string]$message,
        [string]$title = "Information",
        [string]$button = "OK"
    )
    
    [System.Windows.MessageBox]::Show($message, $title, [System.Windows.MessageBoxButton]::$button)
}

# Function to show a WPF progress window
function Show-ProgressWPF {
    param (
        [string]$message
    )

    # Create the WPF window
    $progressWindow = New-Object -TypeName System.Windows.Window
    $progressWindow.Title = "Progress"
    $progressWindow.Width = 400
    $progressWindow.Height = 200
    $progressWindow.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
    $progressWindow.ResizeMode = [System.Windows.ResizeMode]::NoResize
    $progressWindow.Topmost = $true  # Keep the progress window on top

    # Create a TextBlock for displaying progress
    $textBlock = New-Object -TypeName System.Windows.Controls.TextBlock
    $textBlock.Text = $message
    $textBlock.TextWrapping = [System.Windows.TextWrapping]::Wrap
    $textBlock.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
    $textBlock.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
    $textBlock.Margin = [System.Windows.Thickness]::new(20)

    $progressWindow.Content = $textBlock

    # Show the window
    $progressWindow.Show()

    # Return the window for later closure
    return $progressWindow
}

# Function to list all processes
function Get-Processes {
    Get-Process | Select-Object Id, ParentId, Path
}

# Function to close Task Manager if it's open
function Close-TaskManager {
    if (Get-Process -Name "Taskmgr" -ErrorAction SilentlyContinue) {
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

# Introduction WPF Prompt
Show-WPFMessage -message "Do not use the computer while the scan is running. Click OK to begin."

# Show WPF Progress Window
$progressMessage = "Scanning in progress. Please wait for the process to complete. This may take a few moments. The progress window will remain open until the scan is fully completed and the results are ready."
$progressWindow = Show-ProgressWPF -message $progressMessage

# Close Task Manager if it's already open
Close-TaskManager

# Capture initial list of processes
Log-Message "Capturing initial list of processes..."
$initialProcesses = Get-Processes

# Start Task Manager
Log-Message "Starting Task Manager..."
Start-Process "taskmgr.exe"
Start-Sleep -Seconds 5  # Adjust sleep time if necessary

# Capture list of processes after Task Manager opens
Log-Message "Capturing list of processes after Task Manager opens..."
$afterProcesses = Get-Processes

# Compare initial and after lists to find discrepancies
Log-Message "Comparing processes..."
$differences = Compare-Object -ReferenceObject $initialProcesses -DifferenceObject $afterProcesses -Property Id, ParentId, Path | Where-Object { $_.SideIndicator -eq '=>' -or $_.SideIndicator -eq '<=' }

# Generate unique output file name
$outputFile = "$env:TEMP\process_differences_$(Get-Date -Format 'yyyyMMddHHmmss').txt"

# Add introductory section
$introText = @"
Process Probe Results

This file contains the results of the process comparison between the snapshots taken before and after opening Task Manager.

Discrepancies are listed below. Note that:
- Processes with blank "Path" fields were present in one snapshot but not in the other, and the path information was not available.
- Processes may have been started or stopped between snapshots, or their path information could not be retrieved.

Next Steps:
1. Review the differences listed below.
2. Research unfamiliar processes online to determine their legitimacy.
3. If suspicious processes are identified, consider taking appropriate action such as terminating the process or seeking further assistance.

Results:
"@

# Save introductory text and differences to the output file
$introText | Out-File -FilePath $outputFile
$differences | Out-File -FilePath $outputFile -Append

# Log completion message
Log-Message "Process comparison completed. Output saved to $outputFile"

# Wait for the file to be created
Start-Sleep -Seconds 5

# Close Task Manager
Close-TaskManager

# Final WPF Popup
$finalMessage = "Scan complete. Please check the results in the file: $outputFile"
Show-WPFMessage -message $finalMessage -title "Scan Complete" -button "OK"

# Close the WPF Progress Window
$progressWindow.Close()

# Open the file after user clicks OK
if (Test-Path $outputFile) {
    Log-Message "Attempting to open file: $outputFile"
    try {
        Start-Process -FilePath $outputFile
    } catch {
        Log-Message "Error opening output file: $_"
    }
} else {
    Log-Message "Output file does not exist or was not created."
}
