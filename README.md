# Process Probe: Uncover Hidden Malware

Welcome to the Process Probe project! This tool assists in capturing and comparing the list of running processes before and after launching Task Manager, generating a comprehensive report on any differences.

## Getting Started

To start using Process Probe, follow the steps below:

### 1. Open PowerShell with Elevated Privileges

Before running the script, you’ll need to open PowerShell as an Administrator to ensure you have the necessary permissions. Here’s how to do this on Windows 11:

1. **Click on the Start menu** (Windows icon) or press the **Windows key** on your keyboard.
2. In the search bar, type `PowerShell`.
3. Right-click on the `Windows PowerShell` app from the search results.
4. Select **Run as administrator** from the context menu.
5. If prompted by User Account Control (UAC), click **Yes** to allow PowerShell to make changes to your device.

### 2. Request Temporary Bypass of Execution Policy and Run the Script

With the elevated PowerShell session open, you can temporarily bypass the PowerShell execution policy and run the script by pasting the following command and then pressing Enter:

```powershell
# Temporarily bypass the execution policy and run the script directly from GitHub
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/simon-im-security/Process-Probe/main/win_process_probe.ps1" -OutFile "$env:TEMP\win_process_probe.ps1"; Start-Sleep -Seconds 1; & "$env:TEMP\win_process_probe.ps1"
```

### 3. Review the Output
Upon execution, the script will generate a detailed report highlighting the differences in running processes before and after starting Task Manager. This report is saved in the Security Operations folder on your Desktop, with a timestamped filename for easy identification.
