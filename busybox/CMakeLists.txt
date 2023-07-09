cmake_minimum_required(VERSION 3.14)
project (busybox C)

include(FetchContent)

FetchContent_Declare(
	busybox
	GIT_REPOSITORY "https://git.busybox.net/busybox.git"
	GIT_TAG        "1_27_2"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_MakeAvailable(busybox)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
execute_process(
	COMMAND cp ${PROJECT_SOURCE_DIR}/config.cross .config
	WORKING_DIRECTORY ${busybox_SOURCE_DIR}
)

add_custom_command(
	OUTPUT busybox_build
	COMMAND cd ${busybox_SOURCE_DIR} && . ${PROJECT_BINARY_DIR}/../toolchain.sh && make && make install
	COMMAND ${PROJECT_SOURCE_DIR}/generate.sh ${busybox_SOURCE_DIR} ${PROJECT_SOURCE_DIR}
	COMMAND cp ${busybox_SOURCE_DIR}/busybox ${busybox_BINARY_DIR}
)
else()
execute_process(
	COMMAND cp ${PROJECT_SOURCE_DIR}/config.host .config
	COMMAND patch coreutils/date.c -i ${PROJECT_SOURCE_DIR}/patch/coreutils/date.diff
	COMMAND patch util-linux/rdate.c -i ${PROJECT_SOURCE_DIR}/patch/util-linux/rdate.diff
	WORKING_DIRECTORY ${busybox_SOURCE_DIR}
)

add_custom_command(
	OUTPUT busybox_build
	COMMAND cd ${busybox_SOURCE_DIR} && make && make install
	COMMAND ${PROJECT_SOURCE_DIR}/generate.sh ${busybox_SOURCE_DIR} ${PROJECT_SOURCE_DIR}
	COMMAND cp ${busybox_SOURCE_DIR}/busybox ${busybox_BINARY_DIR}
)
endif()

add_custom_command(
	OUTPUT busybox_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${busybox_BINARY_DIR}/* ${PROJECT_SOURCE_DIR}/scripts
)

add_custom_target(busybox ALL DEPENDS busybox_build)
add_custom_target(busybox_clean DEPENDS busybox_cleanall)
