# Process Probe

## Overview
Process Probe captures process snapshots before and after opening system monitors. It then compares them, uncovering hidden or harmful processes, targetting those that evade detection when activity monitors are activated.

### Terminal Screenshot:
![Terminal](https://github.com/simon-im-security/Process-Probe/blob/main/1_terminal.png)

### Output Screenshot:
![Output](https://github.com/simon-im-security/Process-Probe/blob/main/2_output.png)

## Author
Simon Im (simon-im-security)

## Version
1.1 (9th May 2024)

## Usage

### Ubuntu/RHEL:
Open Terminal and paste the following command:
```bash
curl -o /tmp/linux_process_probe.sh https://raw.githubusercontent.com/simon-im-security/Process-Probe/main/linux_process_probe.sh && chmod +x /tmp/linux_process_probe.sh && /tmp/linux_process_probe.sh
```

### Mac:
Open Terminal and paste the following command:
```bash
curl -o /tmp/mac_process_probe.sh https://raw.githubusercontent.com/simon-im-security/Process-Probe/main/mac_process_probe.sh && chmod +x /tmp/mac_process_probe.sh && /tmp/mac_process_probe.sh
```

### Windows:
Ensure PowerShell script execution policy allows running scripts. If not, set the execution policy with administrative privileges using the command:
```powershell
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/simon-im-security/Process-Probe/main/win_process_probe.ps1" -OutFile "$env:TEMP\win_process_probe.ps1"; Set-ExecutionPolicy RemoteSigned -Scope Process; Start-Process -FilePath "powershell.exe" -ArgumentList "-File $env:TEMP\win_process_probe.ps1" -Verb RunAs
```
