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
    install_flag=$1
    tool_dir=$2
    if [ "$install_flag" = "yes" -o "$install_flag" = "Yes" ]; then
        chmod +x $tool_dir/install_dependency.sh
        cd $tool_dir
        ./install_dependency.sh
    elif [ "$install_flag" = "no" -o "$install_flag" = "No" ]; then
        print_log info "Dependencies installtion skipped"
    else
        print_log error "Only accept \"Yes\" or \"No\" for dependencies installation"
        exit 1
    fi
}

function mkdir_new() {
    dir=$1
    if [ ! -d "$dir" ]; then
        mkdir -p $dir
        print_log info "Directory $dir not exists, create one"
    else
        rm -rf $dir && mkdir -p $dir
        print_log warn "Directory $dir exixts, will remove and create new one"
    fi
}

function mkdir_exists_ok() {
    dir=$1
    if [ ! -d "$dir" ]; then
        mkdir -p $dir
        print_log info "Directory $dir not exists, create one"
    else
        print_log info "Directory $dir exixts"
    fi
}


function build() {
    build_dir=$1
    cd $build_dir
    cmake ../
    make -j8
}

function static_code_scan() {
    cache_dir=$1
    build_dir=$2
    run-clang-tidy \
    -p=$build_dir \
    -extra-arg=-Wno-unknown-warning-option \
    -checks='*' \
    -quiet \
    -header-filter=.* 2>&1 \
    | tee -a static_code_check.log

    mv static_code_check.log $cache_dir
    print_log info "Static code analyze finised, result is saved to $cache_dir/static_code_check.log"
}

function cp_output() {
    build_dir=$1
    output_dir=$2
    mv $build_dir/bin/* $output_dir/
}

install_dep_flag=$1
project_name=$2


if [ -z "$project_name" ]; then
    print_log error "Please provide project name to generate outter CMakeLists.txt file"
    exit -1
fi


root_dir=$PWD
tool_dir=$root_dir/tools
cache_dir=$root_dir/cache
build_dir=$root_dir/build
deps_dir=$root_dir/deps
output_dir=$root_dir/output

mkdir_new $build_dir
mkdir_new $output_dir
mkdir_exists_ok $cache_dir

## Update cmake config first
python3 $tool_dir/generate_cmake_cfg.py --project_name $project_name

install_deps $install_dep_flag $tool_dir

build $build_dir

cp_output $build_dir $output_dir

static_code_scan $cache_dir $build_dir

