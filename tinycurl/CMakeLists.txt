cmake_minimum_required(VERSION 3.14)
project (tinycurl C)

# Load Modules
include(FetchContent)

FetchContent_Declare(
	tinycurl
	URL        "https://curl.se/tiny/tiny-curl-7.79.1.tar.gz"
	SOURCE_DIR "src"
	BINARY_DIR "out"
)
FetchContent_Populate(tinycurl)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
add_custom_command(
	OUTPUT tinycurl_build
	COMMAND . ${PROJECT_BINARY_DIR}/../toolchain.sh && ./configure --host=${TARGET_PLATFORM} --prefix=${tinycurl_BINARY_DIR} --with-bearssl=${tinycurl_BINARY_DIR}/../../bearssl/out --disable-shared
	COMMAND cd ${tinycurl_SOURCE_DIR} && make && make install
	WORKING_DIRECTORY ${tinycurl_SOURCE_DIR}
)
else()
add_custom_command(
	OUTPUT tinycurl_build
	COMMAND ./configure --host=${TARGET_PLATFORM} --prefix=${tinycurl_BINARY_DIR} --with-bearssl=${tinycurl_BINARY_DIR}/../../bearssl/out --disable-shared
	COMMAND cd ${tinycurl_SOURCE_DIR} && make && make install
	WORKING_DIRECTORY ${tinycurl_SOURCE_DIR}
)
endif()

add_custom_command(
	OUTPUT tinycurl_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${tinycurl_BINARY_DIR}/*
)

add_custom_target(tinycurl ALL DEPENDS tinycurl_build)
add_custom_target(tinycurl_clean DEPENDS tinycurl_cleanall)
