# Process Probe

## Overview
Process Probe is a script designed to capture a snapshot of running processes before and after opening Task Manager (Windows), System Monitor (Ubuntu/RHEL), or Activity Monitor (macOS). It then compares the two lists to identify any discrepancies, which could indicate potentially malicious processes or system anomalies.

## Author
Simon Im

## Date
9th May 2024

## Version
1.1

## Usage

### For Ubuntu/RHEL:
```bash
curl -o /tmp/linux_process_probe.sh https://raw.githubusercontent.com/simon-im-security/Process-Probe/main/linux_process_probe.sh && chmod +x /tmp/linux_process_probe.sh && /tmp/linux_process_probe.sh
```

### For Mac:
```bash
curl -o /tmp/mac_process_probe.sh https://raw.githubusercontent.com/simon-im-security/Process-Probe/main/mac_process_probe.sh && chmod +x /tmp/mac_process_probe.sh && /tmp/mac_process_probe.sh
```

### For Windows:
- Ensure PowerShell script execution policy allows running scripts. If not, set the execution policy with administrative privileges using the command:
```powershell
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/simon-im-security/Process-Probe/main/win_process_probe.ps1" -OutFile "$env:TEMP\win_process_probe.ps1"; Set-ExecutionPolicy RemoteSigned -Scope Process; Start-Process -FilePath "powershell.exe" -ArgumentList "-File $env:TEMP\win_process_probe.ps1" -Verb RunAs
```
