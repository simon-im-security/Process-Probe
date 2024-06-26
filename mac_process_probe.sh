#!/bin/bash

# Author: Simon Im
# Date: 13th May 2024
# Version: 1.3
# Title: Process Probe
# Description: This script captures a snapshot of running processes before and after opening Activity Monitor,
#              then compares the two lists to identify any discrepancies.

# Function to list all processes
list_processes() {
    ps -axo pid,ppid,command
}

# Function to close Activity Monitor if it's open
close_activity_monitor() {
    if pgrep -x "Activity Monitor" > /dev/null; then
        echo "Closing Activity Monitor..."
        osascript -e 'tell application "Activity Monitor" to quit'
        sleep 2
    fi
}

# Function for logging
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Introduction
log_message "Process Probe - Version 1.3"
log_message "Author: Simon Im"
log_message "Date: 13th May 2024"
log_message "Description: This script captures a snapshot of running processes before and after opening Activity Monitor,"
log_message "             then compares the two lists to identify any discrepancies."

# Close Activity Monitor if it's already open
close_activity_monitor

# Capture initial list of processes
log_message "Capturing initial list of processes..."
initial_processes=$(list_processes)

# Start Activity Monitor
log_message "Opening Activity Monitor..."
open -a "Activity Monitor"

# Wait for Activity Monitor to open
log_message "Waiting for Activity Monitor to open..."
sleep 5

# Capture list of processes after Activity Monitor opens
log_message "Capturing list of processes after Activity Monitor opens..."
after_processes=$(list_processes)

# Compare initial and after lists to find discrepancies
log_message "Comparing processes..."
differences=$(diff -u <(echo "$initial_processes") <(echo "$after_processes") | grep -E '^[+-][0-9]+')

# Create a unique output file name with timestamp
timestamp=$(date +'%Y%m%d%H%M%S')
output_file="/private/tmp/process_differences_$timestamp.txt"

# Save differences to the output file
log_message "Saving differences to $output_file..."
if [ -n "$differences" ]; then
    echo "$differences" > "$output_file"
fi

# Output results to the output file
echo "" >> "$output_file" # Blank space line before the results
echo "RESULTS:" >> "$output_file"
if [ -z "$differences" ]; then
    echo "No discrepancies found." >> "$output_file"
    echo "" >> "$output_file"
    echo "Next Steps:" >> "$output_file"
    echo "1. If you suspect unauthorised activity, investigate further by reviewing system logs." >> "$output_file"
    echo "2. Consider running antivirus or anti-malware scans to ensure system integrity." >> "$output_file"
else
    echo "Discrepancies found. Please review the output file $output_file." >> "$output_file"
    echo "Note: Some differences might be legitimate. It's recommended to look them up online if unsure." >> "$output_file"
    echo "" >> "$output_file"
    echo "Next Steps:" >> "$output_file"
    echo "1. Review the differences in the output file to identify any suspicious processes." >> "$output_file"
    echo "2. Research any unfamiliar processes online to determine their legitimacy." >> "$output_file"
    echo "3. If suspicious, take appropriate action such as terminating the process or seeking further assistance." >> "$output_file"
fi

# Log completion message
log_message "Process comparison completed. Output saved to $output_file"

# Open the file displaying the differences
log_message "Opening $output_file..."
open "$output_file"
