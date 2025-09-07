#! /bin/bash
echo "Hi , Calculator App "
echo "Enter The First Number:" 
read -r num1
echo "Enter The Second Number:" 
read -r num2
echo "choose the prosses ( + , - , \ , * )"
read -r prosses 

if [[ $prosses == "+" ]]; then
        echo "Result : $(( num1 + num2))"
fi 

echo "$pwd"
