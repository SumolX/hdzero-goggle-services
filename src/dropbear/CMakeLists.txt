cmake_minimum_required(VERSION 3.14)
project (dropbear C)

include(FetchContent)

FetchContent_Declare(
	dropbear
	GIT_REPOSITORY "https://github.com/mkj/dropbear.git"
	GIT_TAG        "DROPBEAR_2022.83"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_MakeAvailable(dropbear)

execute_process(
	# GCC 4.9 bug, both stddef.h stdlib.h define NULL without inclusion guards.
	COMMAND sed -i "s@#include <stddef.h>@//#include <stddef.h>@g" ${dropbear_SOURCE_DIR}/libtommath/tommath.h
	COMMAND ./configure --host=${TARGET_PLATFORM} --disable-zlib --enable-static
	WORKING_DIRECTORY ${dropbear_SOURCE_DIR}
)

add_custom_command(
	OUTPUT dropbear_build
	COMMENT "Building DROPBEAR..."
	COMMAND cd ${dropbear_SOURCE_DIR} && make PROGRAMS='dropbear dbclient dropbearkey dropbearconvert scp' MULTI=1 SCPPROGRESS=1
	COMMAND cp ${dropbear_SOURCE_DIR}/dropbearmulti ${dropbear_BINARY_DIR}
)

add_custom_command(
	OUTPUT dropbear_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${dropbear_BINARY_DIR}/*
)

add_custom_target(dropbearmulti ALL DEPENDS dropbear_build)
add_custom_target(dropbear_clean DEPENDS dropbear_cleanall)
