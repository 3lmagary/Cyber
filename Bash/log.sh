#!/bin/bash

read -r -p "Enter the log file name: " logfile

if [[ -f "$logfile" ]]; then
    echo "✅ File found: $logfile"
    echo "---------------------------"
    
    echo "📌 Number of lines:"
    wc -l < "$logfile"

    echo "📌 Number of words:"
    wc -w < "$logfile"

    echo "📌 Lines containing 'error':"
    grep -i "error" "$logfile"

else
    echo "❌ File not found!"
fi
