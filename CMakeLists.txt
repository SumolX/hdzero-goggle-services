cmake_minimum_required(VERSION 3.10)

project(HDZGOGGLE-SERVICES)

# Custom Module Path
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

# Load Modules
include(toolchain)

file(STRINGS ${CMAKE_SOURCE_DIR}/VERSION BUILD_NUMBER)

set(BIN_DIR ${PROJECT_BINARY_DIR}/bin)
set(OUT_DIR ${CMAKE_SOURCE_DIR}/out)
set(SCRIPTS_DIR ${CMAKE_SOURCE_DIR}/scripts)
set(ARCHIVE_NAME "hdzgoggle-services-${BUILD_NUMBER}")

add_subdirectory(busybox)
add_subdirectory(dosfstools)
add_subdirectory(dropbear)
add_subdirectory(ffmpeg)
add_subdirectory(ntpclient)

add_custom_command(
	OUTPUT BUSYBOX
	COMMAND mkdir -p ${BIN_DIR}/busybox
	COMMAND cp ${PROJECT_BINARY_DIR}/busybox/out/busybox ${BIN_DIR}/busybox/
	DEPENDS busybox
)

add_custom_command(
	OUTPUT DOSFSTOOLS
	COMMAND mkdir -p ${BIN_DIR}/dosfstools
	COMMAND cp ${PROJECT_BINARY_DIR}/dosfstools/out/fatlabel ${BIN_DIR}/dosfstools/
	COMMAND cp ${PROJECT_BINARY_DIR}/dosfstools/out/fsck.fat ${BIN_DIR}/dosfstools/
	COMMAND cp ${PROJECT_BINARY_DIR}/dosfstools/out/mkfs.fat ${BIN_DIR}/dosfstools/
	DEPENDS dosfstools
)

add_custom_command(
	OUTPUT DROPBEARMULTI
	COMMAND mkdir -p ${BIN_DIR}/dropbear
	COMMAND cp ${PROJECT_BINARY_DIR}/dropbear/out/dropbearmulti ${BIN_DIR}/dropbear/
	DEPENDS dropbearmulti
)

add_custom_command(
	OUTPUT FFMPEG
	COMMAND mkdir -p ${BIN_DIR}/ffmpeg
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/* ${BIN_DIR}/ffmpeg/
	DEPENDS ffmpeg
)

add_custom_command(
	OUTPUT NTPCLIENT
	COMMAND mkdir -p ${BIN_DIR}/ntpclient
	COMMAND cp ${PROJECT_BINARY_DIR}/ntpclient/out/ntpclient ${BIN_DIR}/ntpclient/
	DEPENDS ntpclient
)

add_custom_command(
	OUTPUT WEBUI
	COMMAND mkdir -p ${BIN_DIR}/webui
	COMMAND cp -a ${PROJECT_SOURCE_DIR}/webui/source/* ${BIN_DIR}/webui/
)

add_custom_command(
	OUTPUT ALL_SCRIPTS
	COMMAND mkdir -p ${BIN_DIR}/scripts
	COMMAND cp ${busybox_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp ${dosfstools_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp ${dropbear_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp ${ffmpeg_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp ${ntpclient_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp ${ntpclient_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp ${SCRIPTS_DIR}/* ${BIN_DIR}/
	COMMAND cp ${CMAKE_SOURCE_DIR}/VERSION ${BIN_DIR}/
	DEPENDS BUSYBOX DOSFSTOOLS DROPBEARMULTI FFMPEG NTPCLIENT WEBUI
)

add_custom_command(
	OUTPUT CREATE_PACKAGE
	COMMAND mkdir -p ${OUT_DIR}
	COMMAND tar cvf "${OUT_DIR}/${ARCHIVE_NAME}.tar" --transform 's,^.,${ARCHIVE_NAME},' .
	WORKING_DIRECTORY ${BIN_DIR}
	DEPENDS ALL_SCRIPTS
)

add_custom_command(
	OUTPUT CLEAN_ALL
	COMMAND rm -rf ${BIN_DIR} ${OUT_DIR}
	DEPENDS busybox_clean dropbear_clean ffmpeg_clean ntpclient_clean
)

add_custom_target(
	${PROJECT_NAME} ALL 
	DEPENDS CREATE_PACKAGE
)

add_custom_target(
	cleanall
	DEPENDS CLEAN_ALL
)

add_dependencies(${PROJECT_NAME} busybox dropbearmulti ffmpeg ntpclient)
