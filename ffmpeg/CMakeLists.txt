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
    --enable-pic
    --extra-ldexeflags=-pie
    --enable-shared
    --prefix="${ffmpeg_BINARY_DIR}"
)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
execute_process(
	COMMAND ./configure ${FFMPEG_COMMON} --enable-cross-compile --cross-prefix=${COMPILER_PATH}/${TARGET_PLATFORM}- --arch=arm --target-os=linux --disable-ffplay
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
	COMMAND cd ${ffmpeg_SOURCE_DIR} && make -j6 && make install
)

add_custom_command(
	OUTPUT ffmpeg_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND find . -name '*.so*' -delete
	COMMAND rm -rf ${ffmpeg_BINARY_DIR}/*
)

add_custom_target(ffmpeg ALL DEPENDS ffmpeg_build)
add_custom_target(ffmpeg_clean DEPENDS ffmpeg_cleanall)
