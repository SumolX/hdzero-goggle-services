cmake_minimum_required(VERSION 3.14)
project (ntpclient C)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/out)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
	set(CMAKE_C_FLAGS "-mfpu=neon -mfloat-abi=hard")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -W -Werror -Wno-unused-function -Wno-unused-variable -ffunction-sections -fdata-sections -Wl,-gc-sections -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DPRECISION_SIOCGSTAMP -DENABLE_REPLAY")
set(CMAKE_C_FLAGS_DEBUG "-g -DENABLE_DEBUG")
set(CMAKE_C_FLAGS_RELEASE "-O2")

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

add_executable(adjtimex ${PROJECT_SOURCE_DIR}/source/adjtimex.c)

add_executable(ntpclient
	${PROJECT_SOURCE_DIR}/source/ntpclient.c
	${PROJECT_SOURCE_DIR}/source/phaselock.c
	${PROJECT_SOURCE_DIR}/source/rtc.c
)

add_custom_command(
        OUTPUT ntpclient_cleanall
	COMMAND find . -name '*.o' -delete
        COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${PROJECT_BINARY_DIR}/out/*
)

add_custom_target(ntpclient_clean DEPENDS ntpclient_cleanall)
