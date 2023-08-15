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

add_subdirectory(bearssl)
add_subdirectory(busybox)
add_subdirectory(dosfstools)
add_subdirectory(dropbear)
add_subdirectory(ffmpeg)
add_subdirectory(ntpclient)
add_subdirectory(tinycurl)
add_subdirectory(untrunc)

add_dependencies(
	tinycurl
	bearssl
)

add_custom_command(
	OUTPUT ALL_TARGETS
	COMMAND mkdir -p ${BIN_DIR}/busybox
	COMMAND cp -a ${PROJECT_BINARY_DIR}/busybox/out/busybox ${BIN_DIR}/busybox/

	COMMAND mkdir -p ${BIN_DIR}/dosfstools
	COMMAND cp -a ${PROJECT_BINARY_DIR}/dosfstools/out/fatlabel ${BIN_DIR}/dosfstools/
	COMMAND cp -a ${PROJECT_BINARY_DIR}/dosfstools/out/fsck.fat ${BIN_DIR}/dosfstools/
	COMMAND cp -a ${PROJECT_BINARY_DIR}/dosfstools/out/mkfs.fat ${BIN_DIR}/dosfstools/
	
	COMMAND mkdir -p ${BIN_DIR}/dropbear
	COMMAND cp -a ${PROJECT_BINARY_DIR}/dropbear/out/dropbearmulti ${BIN_DIR}/dropbear/

	COMMAND mkdir -p ${BIN_DIR}/ffmpeg
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/* ${BIN_DIR}/ffmpeg/

	COMMAND mkdir -p ${BIN_DIR}/ntpclient
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ntpclient/out/ntpclient ${BIN_DIR}/ntpclient/

	COMMAND mkdir -p ${BIN_DIR}/tinycurl
	COMMAND cp -a ${PROJECT_BINARY_DIR}/tinycurl/out/bin/curl ${BIN_DIR}/tinycurl/

	COMMAND mkdir -p ${BIN_DIR}/untrunc
	COMMAND cp -a ${PROJECT_BINARY_DIR}/untrunc/out/untrunc ${BIN_DIR}/untrunc/

	COMMAND mkdir -p ${BIN_DIR}/webui
	COMMAND cp -a ${PROJECT_SOURCE_DIR}/webui/source/* ${BIN_DIR}/webui/

	COMMAND mkdir -p ${BIN_DIR}/scripts
	COMMAND cp -a ${busybox_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${dosfstools_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${dropbear_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${ffmpeg_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${ntpclient_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${tinycurl_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${SCRIPTS_DIR}/* ${BIN_DIR}/
	COMMAND cp -a ${CMAKE_SOURCE_DIR}/VERSION ${BIN_DIR}/
	DEPENDS bearssl busybox dosfstools dropbear ffmpeg ntpclient tinycurl untrunc
)

add_custom_command(
	OUTPUT CREATE_PACKAGE
	COMMAND mkdir -p ${OUT_DIR}
	COMMAND tar cvf "${OUT_DIR}/${ARCHIVE_NAME}.tar" --transform 's,^.,${ARCHIVE_NAME},' .
	WORKING_DIRECTORY ${BIN_DIR}
	DEPENDS ALL_TARGETS
)

add_custom_command(
	OUTPUT CLEAN_ALL
	COMMAND rm -rf ${BIN_DIR} ${OUT_DIR}
	DEPENDS bearssl_clean busybox_clean dropbear_clean ffmpeg_clean ntpclient_clean tinycurl_clean untrunc_clean
)

add_custom_target(
	${PROJECT_NAME} ALL 
	DEPENDS CREATE_PACKAGE
)

add_custom_target(
	cleanall
	DEPENDS CLEAN_ALL
)

add_dependencies(${PROJECT_NAME} bearssl busybox dosfstools dropbearmulti ffmpeg ntpclient tinycurl untrunc)
