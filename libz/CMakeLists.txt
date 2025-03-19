cmake_minimum_required(VERSION 3.14)
project (libz C)

include(FetchContent)

FetchContent_Declare(
	libz
	GIT_REPOSITORY "https://github.com/madler/zlib.git"
	GIT_TAG        "v1.3.1"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_Populate(libz)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
add_custom_command(
	OUTPUT libz_build
	COMMAND . ${PROJECT_BINARY_DIR}/../toolchain.sh && cd ${libz_SOURCE_DIR} && mkdir -p build && cd build && cmake .. && make
	COMMAND mkdir -p ${libz_BINARY_DIR}/lib
	COMMAND mkdir -p ${libz_BINARY_DIR}/include
	COMMAND cp ${libz_SOURCE_DIR}/build/libz.a ${libz_BINARY_DIR}/lib/
	COMMAND cp ${libz_SOURCE_DIR}/build/zconf.h ${libz_BINARY_DIR}/include/
	COMMAND cp ${libz_SOURCE_DIR}/zlib.h ${libz_BINARY_DIR}/include/
)
else()
add_custom_command(
	OUTPUT libz_build
	COMMAND cd ${libz_SOURCE_DIR} && mkdir -p build && cd build && cmake .. && make
	COMMAND mkdir -p ${libz_BINARY_DIR}/lib
	COMMAND mkdir -p ${libz_BINARY_DIR}/include
	COMMAND cp ${libz_SOURCE_DIR}/build/libz.a ${libz_BINARY_DIR}/lib/
	COMMAND cp ${libz_SOURCE_DIR}/build/zconf.h ${libz_BINARY_DIR}/include/
	COMMAND cp ${libz_SOURCE_DIR}/zlib.h ${libz_BINARY_DIR}/include/
)
endif()

add_custom_command(
	OUTPUT libz_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${libz_BINARY_DIR}/*
)

add_custom_target(libz ALL DEPENDS libz_build)
add_custom_target(libz_clean DEPENDS libz_cleanall)
