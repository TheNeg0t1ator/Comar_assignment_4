#!/bin/bash
# only if you have bash 4 in your CentOS system
shopt -s globstar
for file in **/*
do
    slash=${file//[^\/]}
    case "${#slash}" in
        0) echo "|-- ${file}";;
        1) echo "|   |--  ${file}";;
        2) echo "|   |   |--  ${file}";;
    esac
done
