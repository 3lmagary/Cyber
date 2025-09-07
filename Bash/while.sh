#!/bin/bash

count=4
while [[ $count -le 5 ]]; do
echo "Counter: $count"
    count=$((count + 1))
done
# ------------------------------------


ls -l | while read -r line; do
    echo "File: $line"
done
# ----------------------------------
# while true; do
#     echo "Running..."
#     sleep 1
# done
# ------------------------
age=18
while [[ $age -ge 15 ]]; do 
    echo "You $age"
    ((age--))
done
# ---------------
counter=1
until [[ $counter -gt 5 ]]; do
    echo "Counter: $counter"
    ((counter++))
done