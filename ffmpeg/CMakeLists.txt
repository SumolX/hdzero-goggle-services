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
	GIT_TAG        "n5.0.1"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_MakeAvailable(ffmpeg)

set(
    FFMPEG_OPTIONS
    --prefix=${ffmpeg_BINARY_DIR}
    --disable-everything
    --disable-static
    --enable-shared
    --enable-version3
    
    # libavcodec
    --disable-faan
    --disable-iconv
    --disable-v4l2-m2m
    --disable-vaapi
    --disable-vdpau

    # libavformat
    --disable-network
    --disable-bzlib
    --disable-xlib
    --disable-zlib

    --enable-avcodec
    --enable-avfilter
    --enable-protocol=file
    --enable-demuxer=h264
    --enable-parser=h264
    --enable-demuxer=hevc
    --enable-parser=hevc
    --enable-bsf=h264_metadata
    --enable-bsf=h264_redundant_pps
    --enable-bsf=hevc_metadata
    --enable-bsf=extract_extradata
    --enable-muxer=mpegts
    --enable-muxer=mp4
    --enable-demuxer=mov
    --enable-demuxer=mpegts 
)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
list(
    APPEND
    FFMPEG_OPTIONS
    --enable-cross-compile
    --cross-prefix=${COMPILER_PATH}/${TARGET_PLATFORM}-
    --arch=arm
    --target-os=linux

    # disable ffplay dependencies
    --disable-swscale
    --disable-swresample
)
endif()

execute_process(
	COMMAND ./configure ${FFMPEG_OPTIONS} 
	WORKING_DIRECTORY ${ffmpeg_SOURCE_DIR}
)

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
