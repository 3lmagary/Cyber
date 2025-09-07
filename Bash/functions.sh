#!/bin/bash

is_even () {
    if [[ $(( $1 % 2 )) = 0 ]]; then
        echo "The Number is a even + "
    else
        echo "The Number is a odd - "
    fi 
}


square () {
    echo " $(( $1 * $1 )) "
}



menu () {
    read -r -p "1 - Number even or odd
    2 - Number Square
    Choose The option: " choose 
    case choose in 
        1) is_even
        2) square
    }