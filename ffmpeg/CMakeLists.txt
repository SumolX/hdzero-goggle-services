cmake_minimum_required(VERSION 3.14)
project (ffmpeg C)

# Custom Module Path
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

# Load Modules
include(toolchain)
include(FetchContent)

FetchContent_Declare(
	ffmpeg
	GIT_REPOSITORY "https://github.com/ffmpeg/ffmpeg.git"
	GIT_TAG        "n6.0"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_MakeAvailable(ffmpeg)

set(
	FFMPEG_COMMON
       	--enable-gpl
       	--enable-version3
)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
execute_process(
	COMMAND ./configure ${FFMPEG_COMMON} --enable-cross-compile --cross-prefix=${COMPILER_PATH}/${TARGET_PLATFORM}- --arch=arm --target-os=linux
	WORKING_DIRECTORY ${ffmpeg_SOURCE_DIR}
)
else()
execute_process(
	COMMAND ./configure ${FFMPEG_COMMON}
	WORKING_DIRECTORY ${ffmpeg_SOURCE_DIR}
)
endif()

add_custom_command(
	OUTPUT ffmpeg_build
	COMMAND cd ${ffmpeg_SOURCE_DIR} && make -j6
	COMMAND cp ${ffmpeg_SOURCE_DIR}/ffmpeg ${ffmpeg_BINARY_DIR}
	COMMAND cp ${ffmpeg_SOURCE_DIR}/ffplay ${ffmpeg_BINARY_DIR}
	COMMAND cp ${ffmpeg_SOURCE_DIR}/ffprobe ${ffmpeg_BINARY_DIR}
)

add_custom_command(
	OUTPUT ffmpeg_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${ffmpeg_BINARY_DIR}/*
)

add_custom_target(ffmpeg ALL DEPENDS ffmpeg_build)
add_custom_target(ffmpeg_clean DEPENDS ffmpeg_cleanall)
