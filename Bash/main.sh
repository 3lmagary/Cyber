#!/bin/bash

# # read -r -p "Enter The Name: " name
# # echo "Hello, $name"
# # # -----------------------------------------------
# # read -r -p "Enter  2 Number: " num1 num2
# # echo "++  >> $((num1 + num2))"
# # echo "--  >> $((num1 - num2))"
# # echo "**  >> $((num1 * num2))"
# # echo "//  >> $((num1 / num2))"
# # # -----------------------------------------------------
# # read -r -p "Enter a age: " age
# # if [[ $age -ge 18 ]]; then
# #     echo "You are an adult"
# # else
# #     echo "You are young"
# # fi
# # # --------------------------------------------------
# # read -r -p "Entre The Number chick: " number
# # if [ $number -gt 0 ]; then
# #     echo "The Number Is Positive"
# # elif [ $number -lt 0 ]; then 
# #     echo "The Number Is Negative"
# # else
# #     echo "The Number Is Zero"
# # fi
# # # ------------------------------------------------------------
# # read -r -p "Enter The Number: " num
# # if [ $num = 0 ]; then 
# #     echo "No, The Number Is zero"
# # elif [ $(( num  % 2 )) = 0 ]; then 
# #     echo "The Number Is Even"
# # elif [ $(( num  % 2 )) != 0 ]; then
# #     echo "The Number Is Odd"
# # fi 
# # ------------------------------------------------------------------------
# # read -r -p "Enter The Password: " passwd
# # if [ $passwd = "1234" ]; then 
# #     echo "The Password Is Correct"
# # else
# #     echo "The Password Is Incorrect"
# # fi
# # ========================================================================================

# # --------------------------- Loop ------------------------------

# # for i in {1..100}; do 
# #     echo "Number: $i"
# # done
# # ------------------------------------------------
# # for i in {1..50}; do 
# #     if [ $(( i % 2 )) = 0 ]; then
# #     echo "Number: $i"
# #     fi
# # done
# # ---------------------------------------------------------------------
# # read -r -p "Enter The Number: " sum
# # sum=0
# # for i in $(seq 5 ); do 
# #     (( sum += i )) # let sum+=i
# # done
# # echo $sum
# # -----------------------------------------------------------------
# # read -r -p "Enter The Number: " num
# # for i in {1..12}; do
# #     echo " $num x $i = $(( $i * $num )) "
# # done
# # ----------------------------------------------------------------------------
# # read -r -p "1) Print numbers from 1 up to a specific number
# # 2) Check if a number is even or odd
# # 3) Calculate the sum of numbers from 1 up to a specific number
# # 4) Exit
# # :::::---> " choose
# # if [[ $choose = 1 ]]; then
# #     read -r -p "Enter The Number: " n
# #     for i in $(seq $n ); do 
# #         echo "Number: $i"
# #     done

# # elif [[ $choose = 2 ]]; then
# #     read -r -p "Enter The Number: " num
# #     if [ $num = 0 ]; then 
# #         echo "No, The Number Is zero"
# #     elif [ $(( num  % 2 )) = 0 ]; then 
# #         echo "The Number Is Even"
# #     elif [ $(( num  % 2 )) != 0 ]; then
# #         echo "The Number Is Odd"
# #     fi 

# # elif [[ $choose = 3 ]]; then
# #     read -r -p "Enter The Number: " s
# #     sum=0
# #     for i in $(seq $s ); do 
# #         let sum+=i
# #     done
# #     echo $sum
# # elif [ $choose = 4 ]; then 
# #     echo "Thank You "

# # fi

# # ===================================================================------=============================================


# # برنامج بسيط فيه منيو (قائمة) لتجربة أوامر Bash
# # هنخليه يشتغل في حلقة لحد ما المستخدم يختار Exit

# while true; do
#     echo "==============================="
#     echo "         Main Menu"
#     echo "==============================="
#     echo "1) Print numbers from 1 up to a specific number"
#     echo "2) Check if a number is even or odd"
#     echo "3) Calculate the sum of numbers from 1 up to a specific number"
#     echo "4) Square a number (n^2)"
#     echo "5) Multiplication table of a number"
#     echo "6) Exit"
#     echo "==============================="
#     read -r -p "Choose an option: " choice

#     case $choice in
#         1)  # طباعة الأرقام من 1 لحد رقم معين
#             read -r -p "Enter The Number: " n
#             for i in $(seq "$n"); do
#                 echo "Number: $i"
#             done
#             ;;
#         2)  # التحقق إذا الرقم زوجي أو فردي أو صفر
#             read -r -p "Enter The Number: " num
#             if [ "$num" -eq 0 ]; then
#                 echo "The Number Is Zero"
#             elif [ $(( num % 2 )) -eq 0 ]; then
#                 echo "The Number Is Even"
#             else
#                 echo "The Number Is Odd"
#             fi
#             ;;
#         3)  # مجموع الأرقام من 1 لحد رقم معين
#             read -r -p "Enter The Number: " s
#             sum=0
#             for i in $(seq "$s"); do
#                 (( sum += i ))
#             done
#             echo "Sum = $sum"
#             ;;
#         4)  # مربع الرقم (n^2)
#             read -r -p "Enter The Number: " x
#             echo "$x squared = $(( x * x ))"
#             ;;
#         5)  # جدول الضرب
#             read -r -p "Enter The Number: " t
#             for i in {1..12}; do
#                 echo "$t x $i = $(( t * i ))"
#             done
#             ;;
#         6)  # الخروج
#             echo "Thank You :)"
#             break
#             ;;
#         *)  # لو المستخدم دخل اختيار غلط
#             echo "Invalid choice, try again!"
#             ;;
#     esac
# done
