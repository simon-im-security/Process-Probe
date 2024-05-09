#!/bin/bash

# Author: Simon Im
# Date: 9th May 2024
# Version: 1.1
# Title: Process Probe
# Description: This script captures a snapshot of running processes before and after opening System Monitor,
#              then compares the two lists to identify any discrepancies.

# Function to list all processes
list_processes() {
    ps -axo pid,ppid,command
}

# Function to close System Monitor if it's open (for Ubuntu)
close_system_monitor_ubuntu() {
    if pgrep -x "gnome-system-monitor" > /dev/null; then
        echo "Closing System Monitor (Ubuntu)..."
        pkill -x gnome-system-monitor
        sleep 2
    fi
}

# Function to close System Monitor if it's open (for RHEL)
close_system_monitor_rhel() {
    if pgrep -x "gnome-system-monitor" > /dev/null; then
        echo "Closing System Monitor (RHEL)..."
        pkill -x gnome-system-monitor
        sleep 2
    fi
}

# Function for logging
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Introduction
log_message "Process Probe - Version 1.1"
log_message "Author: Simon Im"
log_message "Date: 9th May 2024"
log_message "Description: This script captures a snapshot of running processes before and after opening System Monitor,"
log_message "             then compares the two lists to identify any discrepancies."

# Determine Linux distribution (Ubuntu or RHEL)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
        close_system_monitor_ubuntu
    elif [[ "$ID" == "rhel" ]]; then
        close_system_monitor_rhel
    fi
fi

# Capture initial list of processes
log_message "Capturing initial list of processes..."
initial_processes=$(list_processes)

# Start System Monitor
log_message "Opening System Monitor..."
if [[ "$ID" == "ubuntu" ]]; then
    gnome-system-monitor &
elif [[ "$ID" == "rhel" ]]; then
    gnome-system-monitor &
fi

# Wait for System Monitor to open
log_message "Waiting for System Monitor to open..."
sleep 5

# Capture list of processes after System Monitor opens
log_message "Capturing list of processes after System Monitor opens..."
after_processes=$(list_processes)

# Compare initial and after lists to find discrepancies
log_message "Comparing processes..."
differences=$(diff -u <(echo "$initial_processes") <(echo "$after_processes") | grep -E '^[+-][0-9]+')

# Save differences to a file in /tmp
output_file="/tmp/process_differences.txt"
log_message "Saving differences to $output_file..."
echo "$differences" > "$output_file"

# Log completion message
log_message "Process comparison completed. Output saved to $output_file"

# Open the file displaying the differences
log_message "Opening $output_file..."
xdg-open "$output_file" >/dev/null 2>&1 &
