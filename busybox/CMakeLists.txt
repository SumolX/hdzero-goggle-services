cmake_minimum_required(VERSION 3.14)
project (busybox C)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
	set(CMAKE_C_FLAGS "-mfpu=neon -mfloat-abi=hard")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-unused-function -Wno-unused-variable -ffunction-sections -fdata-sections -Wl,-gc-sections -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64")
set(CMAKE_C_FLAGS_DEBUG "-g")
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG")

if(DEFINED CMAKE_TOOLCHAIN_FILE)
	get_filename_component(COMPILER_NAME ${CMAKE_C_COMPILER} NAME)
	get_filename_component(COMPILER_PATH ${CMAKE_C_COMPILER} PATH)
	string(REGEX REPLACE "(.*)-gcc" "\\1" TARGET_PLATFORM "${COMPILER_NAME}")
	set(TARGET_OPTIONS
		"CFLAGS=${CMAKE_C_FLAGS}"
		"CC=${COMPILER_PATH}/${TARGET_PLATFORM}-gcc"
		"AR=${COMPILER_PATH}/${TARGET_PLATFORM}-ar"
		"LD=${COMPILER_PATH}/${TARGET_PLATFORM}-ld"
		"RANLIB=${COMPILER_PATH}/${TARGET_PLATFORM}-ranlib"
		"NM=${COMPILER_PATH}/${TARGET_PLATFORM}-nm"
		"AS=${COMPILER_PATH}/${TARGET_PLATFORM}-as"
		"OBJDUMP=${COMPILER_PATH}/${TARGET_PLATFORM}-objdump"
		"OBJCOPY=${COMPILER_PATH}/${TARGET_PLATFORM}-objcopy"
		"STRIP=${COMPILER_PATH}/${TARGET_PLATFORM}-strip"
		"STRINGS=${COMPILER_PATH}/${TARGET_PLATFORM}-strings"
		"SIZE=${COMPILER_PATH}/${TARGET_PLATFORM}-size"
	)
	set(ENV ${TARGET_OPTIONS})
endif()

include(FetchContent)

FetchContent_Declare(
	busybox
	GIT_REPOSITORY "https://git.busybox.net/busybox.git"
	GIT_TAG        "1_27_2"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_MakeAvailable(busybox)

execute_process(
	COMMAND cp ${PROJECT_SOURCE_DIR}/config .config
	COMMAND patch coreutils/date.c -i ${PROJECT_SOURCE_DIR}/patch/coreutils/date.diff
	COMMAND patch util-linux/rdate.c -i ${PROJECT_SOURCE_DIR}/patch/util-linux/rdate.diff
	WORKING_DIRECTORY ${busybox_SOURCE_DIR}
)

add_custom_command(
	OUTPUT busybox_build
	COMMAND cd ${busybox_SOURCE_DIR} && make
	COMMAND cp ${busybox_SOURCE_DIR}/busybox ${busybox_BINARY_DIR}
)

add_custom_command(
	OUTPUT busybox_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${busybox_BINARY_DIR}/*
)

add_custom_target(busybox ALL DEPENDS busybox_build)
add_custom_target(busybox_clean DEPENDS busybox_cleanall)
