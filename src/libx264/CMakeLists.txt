cmake_minimum_required(VERSION 3.14)
project (libx264 C)

# Load Modules
include(FetchContent)

FetchContent_Declare(
	libx264
	GIT_REPOSITORY "https://code.videolan.org/videolan/x264.git"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_MakeAvailable(libx264)

set(
    LIBX264_OPTIONS
    --prefix=${libx264_BINARY_DIR}
    --enable-shared
    --enable-pic
)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
list(
    APPEND
    LIBX264_OPTIONS
    --host=${TARGET_PLATFORM}
    --cross-prefix=${COMPILER_PATH}/${TARGET_PLATFORM}-
    --extra-cflags=${CMAKE_C_FLAGS}
    --extra-ldflags=${CMAKE_C_FLAGS}
)
endif()

execute_process(
	COMMAND ./configure ${LIBX264_OPTIONS} 
	WORKING_DIRECTORY ${libx264_SOURCE_DIR}
)

add_custom_command(
	OUTPUT libx264_build
	COMMENT "Building LIBX264..."
	COMMAND make -j6 && make install
	WORKING_DIRECTORY ${libx264_SOURCE_DIR}
)

add_custom_command(
	OUTPUT libx264_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND find . -name '*.so*' -delete
	COMMAND rm -rf ${libx264_BINARY_DIR}/*
)

add_custom_target(libx264 ALL DEPENDS libx264_build)
add_custom_target(libx264_clean DEPENDS libx264_cleanall)
