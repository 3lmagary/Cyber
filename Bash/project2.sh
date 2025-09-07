#!/usr/bin/env bash
read -r -p "Enter A Number: " number
for i in $(seq $number); do 
    echo "$i"
    
done