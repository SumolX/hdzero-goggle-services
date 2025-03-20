cmake_minimum_required(VERSION 3.14)
project (dosfstools C)

include(FetchContent)

FetchContent_Declare(
	dosfstools
	GIT_REPOSITORY "https://github.com/dosfstools/dosfstools"
	GIT_TAG        "v4.2"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_MakeAvailable(dosfstools)

execute_process(
	# autogen.sh returns ignorable error
	COMMAND ./autogen.sh
	WORKING_DIRECTORY ${dosfstools_SOURCE_DIR}
)

execute_process(
	COMMAND ./configure --host=${TARGET_PLATFORM}
	WORKING_DIRECTORY ${dosfstools_SOURCE_DIR}
)

add_custom_command(
	OUTPUT dosfstools_build
	COMMENT "Building DOSFSTOOLS..."
	COMMAND cd ${dosfstools_SOURCE_DIR} && make
	COMMAND cp ${dosfstools_SOURCE_DIR}/src/fatlabel ${dosfstools_BINARY_DIR}
	COMMAND cp ${dosfstools_SOURCE_DIR}/src/fsck.fat ${dosfstools_BINARY_DIR}
	COMMAND cp ${dosfstools_SOURCE_DIR}/src/mkfs.fat ${dosfstools_BINARY_DIR}
)

add_custom_command(
	OUTPUT dosfstools_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${dosfstools_BINARY_DIR}/*
)

add_custom_target(dosfstools ALL DEPENDS dosfstools_build)
add_custom_target(dosfstools_clean DEPENDS dosfstools_cleanall)
