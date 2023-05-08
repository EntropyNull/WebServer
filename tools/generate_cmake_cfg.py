import argparse
import os

from logger import *

## some const 
PROJ = "source"
CMAKEFILENAME = "CMakeLists.txt"

root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
projs_dir = os.path.join(root_dir, PROJ)
cmake_pth = os.path.join(root_dir, CMAKEFILENAME)
projs_list = os.listdir(projs_dir)
log = Logger(log_level=INFO)


## find sub-project dir with cmake file
sub_projs_list = []
for each_proj in projs_list:
    sub_proj_dir = os.path.join(projs_dir, each_proj)
    if os.path.isfile(sub_proj_dir):
        log.warning("{} is a file, skipped".format(sub_proj_dir))
        continue
    sub_proj_cmake_pth = os.path.join(sub_proj_dir, CMAKEFILENAME)
    if os.path.exists(sub_proj_cmake_pth):
        sub_projs_list.append(os.path.join(PROJ, each_proj))
        log.info("Find sub-project {}".format(each_proj))\

## generate CMakeLists.txt
parser = argparse.ArgumentParser()
parser.add_argument('--project_name', '-n', type=str, required=True)
args = parser.parse_args()
project_name = args.project_name


CMAKELIST = "cmake_minimum_required(VERSION 3.10)\n\
project(%s)\n\n\
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)\n\
set(CMAKE_CXX_STANDARD 11)\n\
set(CXX_FLAGS -g -Wall -std=c++11 -D_PTHREADS -Wno-unused-parameter)\n\n\
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)\n\
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)\n\
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)\n\n" %project_name

cmake_ctx = CMAKELIST
for each_sub_proj in sub_projs_list:
    cmake_ctx = cmake_ctx + "add_subdirectory({})\n".format(each_sub_proj)


with open(CMAKEFILENAME, "w") as fp:
    fp.write(cmake_ctx)

log.info("{} is generated".format(cmake_pth))
