cmake_minimum_required(VERSION 3.10)
project(WebServer_dep)

set(CMAKE_CXX_FLAGS CXX_FLAGS -g -Wall -std=c++11 -D_PTHREADS -Wno-unused-parameter)

get_filename_component(PARENT_DIR ${CMAKE_CURRENT_SOURCE_DIR} DIRECTORY)
get_filename_component(PROJECT_ROOT ${PARENT_DIR} DIRECTORY)
get_filename_component(SRC_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME_WE)
get_filename_component(PROJ_NAME ${SRC_NAME} NAME_WE)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/${PROJ_NAME})
# set(<deps_name>_INSTALL_DIR ${PROJECT_ROOT}/deps/<dep_dir>)

message(STATUS "Compile output save dir is ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

