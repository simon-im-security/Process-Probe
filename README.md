# Welcome to the Process Probe

Welcome to the Process Probe project! This tool helps in capturing and comparing the list of running processes before and after starting Task Manager, and generating a report on the differences.

## Getting Started

To get started with the Process Probe, follow these steps:

### 1. Adjust Execution Policy

Before running the script, you'll need to ensure that your PowerShell execution policy allows the script to run. This can be done by setting the execution policy to `RemoteSigned` or `Unrestricted`. Run the following command in an elevated PowerShell session (Run as Administrator):

```powershell
# Set the execution policy to RemoteSigned (allows running scripts downloaded from the internet if they are signed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force

# Define the URL of the script
$scriptUrl = "https://raw.githubusercontent.com/simon-im-security/Process-Probe/main/win_process_probe.ps1"

# Define the path where the script will be downloaded
$tempScriptPath = "$env:TEMP\win_process_probe.ps1"

# Download the script
Invoke-WebRequest -Uri $scriptUrl -OutFile $tempScriptPath

# Execute the downloaded script
. $tempScriptPath
