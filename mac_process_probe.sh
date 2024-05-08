#!/bin/bash

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

# Save differences to a file in /private/tmp
output_file="/private/tmp/process_differences.txt"
log_message "Saving differences to $output_file..."
echo "$differences" > "$output_file"

# Log completion message
log_message "Process comparison completed. Output saved to $output_file"

# Open the file displaying the differences
log_message "Opening $output_file..."
open "$output_file"
