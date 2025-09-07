#!/bin/bash

read -r -p "Enter The Name File: " name_file

if [[ -f "$name_file" ]]; then
    cat $name_file
else
    echo "This is file not exist
    Creat the $name_file 
    print file "
    touch $name_file
    echo "This is New file by Bash " >> $name_file

    cat $name_file
fi
rm $name_file