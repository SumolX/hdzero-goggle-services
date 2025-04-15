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
    --disable-runtime-cpudetect
    --enable-shared
    --enable-version3
    
    # libavcodec
    --disable-faan
    --disable-iconv
    --disable-v4l2-m2m
    --disable-vaapi
    --disable-vdpau

    # libavformat
    --enable-network
    --disable-bzlib
    --disable-xlib
    --disable-zlib

    --enable-protocol=file,udp
    --enable-decoder=hevc,aac
    --enable-muxer=hevc,adts,latm,mpegts,mp4,hls,rtsp
    --enable-demuxer=h264,hevc,mpegts,mov,rtsp
    --enable-parser=h264,hevc,ac3
    --enable-bsf=h264_metadata,h264_redundant_pps,h264_mp4toannexb,
    --enable-bsf=hevc_metadata,hevc_mp4toannexb,aac_adtstoasc,extract_extradata
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

add_custom_command(
    OUTPUT ffmpeg_build
    COMMENT "Building FFMPEG..."
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
