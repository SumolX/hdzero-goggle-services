cmake_minimum_required(VERSION 3.14)
project (bearssl C)

# Load Modules
include(FetchContent)

FetchContent_Declare(
	bearssl
	GIT_REPOSITORY "https://www.bearssl.org/git/BearSSL"
	GIT_TAG        "v0.6"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_MakeAvailable(bearssl)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
add_custom_command(
	OUTPUT bearssl_build
	COMMAND cp ${PROJECT_SOURCE_DIR}/hdzero.mk ${bearssl_SOURCE_DIR}/conf/
	COMMAND . ${PROJECT_BINARY_DIR}/../toolchain.sh && make CONF=hdzero
	WORKING_DIRECTORY ${bearssl_SOURCE_DIR}
)
else()
add_custom_command(
	OUTPUT bearssl_build
	COMMAND make
	WORKING_DIRECTORY ${bearssl_SOURCE_DIR}
)
endif()

add_custom_command(
	OUTPUT bearssl_postbuild
	COMMAND mkdir -p ${bearssl_BINARY_DIR}/bin
	COMMAND mkdir -p ${bearssl_BINARY_DIR}/include
	COMMAND mkdir -p ${bearssl_BINARY_DIR}/lib
	COMMAND cp ${bearssl_SOURCE_DIR}/build/brssl ${bearssl_BINARY_DIR}/bin/
	COMMAND cp ${bearssl_SOURCE_DIR}/build/libbearssl.* ${bearssl_BINARY_DIR}/lib/
	COMMAND cp ${bearssl_SOURCE_DIR}/inc/* ${bearssl_BINARY_DIR}/include/
	DEPENDS bearssl_build
)

add_custom_command(
	OUTPUT bearssl_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${bearssl_BINARY_DIR}/*
)

add_custom_target(bearssl ALL DEPENDS bearssl_postbuild)
add_custom_target(bearssl_clean DEPENDS bearssl_cleanall)
