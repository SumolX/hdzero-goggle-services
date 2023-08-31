cmake_minimum_required(VERSION 3.14)
project (ffmpeg C)

# Load Modules
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
    --enable-gpl
    
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
    --enable-libx264
    --enable-protocol=file
    --enable-encoder=libx264,aac
    --enable-decoder=hevc,aac
    --enable-muxer=h264,hevc,mpegts,mp4,hls
    --enable-demuxer=h264,hevc,mpegts,mov
    --enable-parser=h264,hevc
    --enable-bsf=h264_metadata,h264_redundant_pps,hevc_metadata,extract_extradata

    --extra-ldflags=-L${PROJECT_BINARY_DIR}/../x264/out/lib
    --extra-cflags=-I${PROJECT_BINARY_DIR}/../x264/out/include
)

message("${PROJECT_BINARY_DIR}")

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

add_custom_command(
	OUTPUT ffmpeg_build
    COMMAND ./configure ${FFMPEG_OPTIONS}
	COMMAND make -j6 && make install
    WORKING_DIRECTORY ${ffmpeg_SOURCE_DIR}
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
