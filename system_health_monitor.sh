#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80  # CPU usage in percentage
MEM_THRESHOLD=80  # Memory usage in percentage
DISK_THRESHOLD=80 # Disk usage in percentage

# Log file location
LOG_FILE="$HOME/system_health.log"

# Ensure the log file exists
if [ ! -f "$LOG_FILE" ]; then
  touch "$LOG_FILE"
fi

# CPU Check Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
CPU_INT=${CPU_USAGE%.*}
echo "CPU Usage: $CPU_INT%"  # Debugging line

if [ "$CPU_INT" -gt "$CPU_THRESHOLD" ]; then
  echo "High Cpu Usage: ${CPU_USAGE}% at $(date)" >> "$LOG_FILE"
fi

# Check Memory Usage
MEMORY=$(free -m | awk '/^Mem:/ {print $3/$2 * 100.0}')
MEM_INT=${MEMORY%.*}
echo "Memory Usage: $MEM_INT%"  # Debugging line

if [ "$MEM_INT" -gt "$MEM_THRESHOLD" ]; then
  echo "High Memory Usage: ${MEMORY}% at $(date)" >> "$LOG_FILE"
fi

# Check Disk Usage
DISK_USAGE=$(df -h / | awk '/\// {print $5}' | sed 's/%//')
echo "Disk Usage: $DISK_USAGE%"  # Debugging line

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
  echo "High Disk Usage: ${DISK_USAGE}% at $(date)" >> "$LOG_FILE"
fi

# Send email alert (optional, requires mailutils installed)
if grep -q "High" "$LOG_FILE"; then
  mail -s "System Health Alert" jangidbharat519@gmail.com < "$LOG_FILE"
fi

