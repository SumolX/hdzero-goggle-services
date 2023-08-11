cmake_minimum_required(VERSION 3.14)
project (untrunc C)

include(FetchContent)

FetchContent_Declare(
	untrunc
	GIT_REPOSITORY "https://github.com/SumolX/untrunc.git"
	GIT_TAG        "origin/hdz-goggle-services"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_MakeAvailable(untrunc)

set(
    FFMPEG_OPTIONS
    --prefix=${untrunc_BINARY_DIR}
    --disable-everything
    --enable-version3
    
    # libavcodec
    --disable-faan
    --disable-vaapi
    --disable-vdpau

    # libavformat
    --disable-network
    --disable-bzlib
    --disable-zlib

    --enable-avcodec
    --enable-avfilter
    --enable-protocol=file
    --enable-demuxer=h264,hevc,mov,mpegts
    --enable-parser=h264,hevc,mpegaudio
    --enable-decoder=aac
    --enable-bsf=h264_metadata,h264_redundant_pps,hevc_metadata,extract_extradata
    --enable-muxer=mpegts,mp4
)

file(GLOB UNTRUNC_SRCS "${untrunc_SOURCE_DIR}/*.cpp")

set(
    UNTRUNC_LIBS
    -L./libav/libavformat -lavformat
    -L./libav/libavcodec -lavcodec
    -L./libav/libavresample -lavresample
    -L./libav/libavutil -lavutil
    -lpthread
    -std=c++11
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
)
else()
list(
    APPEND
    UNTRUNC_LIBS
    -lz
    -lX11
    -lvdpau
)

set(
    CMAKE_CXX_COMPILER
    g++
)
endif()

execute_process(
	COMMAND ./configure ${FFMPEG_OPTIONS}
	WORKING_DIRECTORY ${untrunc_SOURCE_DIR}/libav
)

add_custom_command(
	OUTPUT untrunc_build_libav
	COMMAND cd ${untrunc_SOURCE_DIR}/libav && make -j6 && make install
)

add_custom_command(
	OUTPUT untrunc_build
	COMMAND cd ${untrunc_SOURCE_DIR} && ${CMAKE_CXX_COMPILER} -o untrunc -I./libav ${UNTRUNC_SRCS} ${UNTRUNC_LIBS}
	COMMAND cp ${untrunc_SOURCE_DIR}/untrunc ${untrunc_BINARY_DIR}
	DEPENDS untrunc_build_libav
)

add_custom_command(
	OUTPUT untrunc_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND find . -name '*.so*' -delete
	COMMAND rm -rf ${untrunc_BINARY_DIR}/*
)

add_custom_target(untrunc ALL DEPENDS untrunc_build)
add_custom_target(untrunc_clean DEPENDS untrunc_cleanall)
