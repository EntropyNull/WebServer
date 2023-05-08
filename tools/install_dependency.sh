#!/bin/bash

# Consle log output with color
function print_log() {
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    RESET=$(tput sgr0)
    log_level=$1
    log=$2
    if [ "$log_level" = "info" -o "$log_level" = "INFO" ]; then
        echo "${GREEN}[INFO] $log ${RESET}"
    elif [ "$log_level" = "warn" -o "$log_level" = "WARN" ]; then
        echo "${YELLOW}[WARN] $log ${RESET}"
    elif [ "$log_level" = "error" -o "$log_level" = "error" ]; then
        echo "${RED}[ERROR] $log ${RESET}"
    else
        echo "${RED}[ERROR] Invalid function arguments, please input \"info\, \"warn\" or \"error\". ${RESET}"
    fi
}

function install_deps() {
    root_dir=$PWD
    dep_install_dir=$root_dir/deps

    ## install deps
    sudo apt update
    sudo apt install gcc g++ cmake pkg-config clang-tidy python3 -y

    ## other deps can be installed to $root_dir/deps path
}

install_deps