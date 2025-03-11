#!/bin/bash

LOCK_FILE="$TMPDIR/.show_bar.lock"

# Check if the script is already running
if [ -f "$LOCK_FILE" ]; then
  # Extend the sleep timer
  END_TIME=$(cat "$LOCK_FILE")
  NEW_END_TIME=$((END_TIME + 3))
  exit 0
fi

# Create new start and end times
touch "$LOCK_FILE"

START_TIME=$(date +%s)
END_TIME=$((START_TIME + 3))

sketchybar --bar hidden=false topmost=true position=bottom

# Loop until the end time is reached
while [[ $(date +%s) -lt $END_TIME ]]; do
  sleep 1 # to reduce CPU usage
  CURRENT_TIME=$(date +%s)
  if [[ -f "$LOCK_FILE" ]]; then
    LOCK_FILE_END_TIME=$(cat "$LOCK_FILE")
    if [[ $LOCK_FILE_END_TIME -gt $END_TIME ]]; then
      END_TIME=$LOCK_FILE_END_TIME
    fi
  fi
done

sketchybar --bar hidden=true

# Remove the lock file
rm "$LOCK_FILE"