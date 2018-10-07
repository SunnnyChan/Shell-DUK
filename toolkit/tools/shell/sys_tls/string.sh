#!/bin/bash

function  underline2camelCase(){
    echo "$1" | awk -F "_" '{
        for (i=1; i<= NF; i++) {
            printf(toupper(substr($i, 1, 1)));
            printf(substr($i, 2, length($i)));
        }
    }'
}
