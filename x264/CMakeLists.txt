cmake_minimum_required(VERSION 3.14)
project (x264 C)

# Load Modules
include(FetchContent)

FetchContent_Declare(
	x264
	GIT_REPOSITORY "https://code.videolan.org/videolan/x264.git"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_MakeAvailable(x264)

set(
    X264_OPTIONS
    --prefix=${x264_BINARY_DIR}
    --enable-shared
    --enable-pic
)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
list(
    APPEND
    X264_OPTIONS
    --host=${TARGET_PLATFORM}
    --cross-prefix=${COMPILER_PATH}/${TARGET_PLATFORM}-
    --extra-cflags=${CMAKE_C_FLAGS}
    --extra-ldflags=${CMAKE_C_FLAGS}
)
endif()

execute_process(
	COMMAND ./configure ${X264_OPTIONS} 
	WORKING_DIRECTORY ${x264_SOURCE_DIR}
)

add_custom_command(
	OUTPUT x264_build
	COMMAND make -j6 && make install
	WORKING_DIRECTORY ${x264_SOURCE_DIR}
)

add_custom_command(
	OUTPUT x264_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND find . -name '*.so*' -delete
	COMMAND rm -rf ${x264_BINARY_DIR}/*
)

add_custom_target(x264 ALL DEPENDS x264_build)
add_custom_target(x264_clean DEPENDS x264_cleanall)
