cmake_minimum_required(VERSION 3.10)

project(HDZGOGGLE-SERVICES)

# Configuration
option(BUSYBOX    "" ON)
option(DOSFSTOOLS "" ON)
option(DROPBEAR   "" ON)
option(FFMPEG     "" ON)
option(NTPCLIENT  "" ON)
option(TINYCURL   "" ON)
option(UNTRUNC    "" ON)

# Custom Module Path
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

# Load Modules
include(toolchain)

file(STRINGS ${CMAKE_SOURCE_DIR}/VERSION BUILD_NUMBER)

set(BIN_DIR ${PROJECT_BINARY_DIR}/bin)
set(OUT_DIR ${CMAKE_SOURCE_DIR}/out)
set(SCRIPTS_DIR ${CMAKE_SOURCE_DIR}/scripts)
set(ARCHIVE_NAME "hdzgoggle-services-${BUILD_NUMBER}")

# Preperation of Targets
add_custom_target(
	PREPARE_ENVIRONMENT
	COMMAND mkdir -p ${BIN_DIR}/scripts
)

# Main Command for All Targets
add_custom_command(
	OUTPUT ALL_TARGETS
	DEPENDS PREPARE_ENVIRONMENT
)

add_custom_command(
	OUTPUT CLEAN_ALL
	COMMAND rm -rf ${BIN_DIR} ${OUT_DIR}
)

add_custom_command(
	OUTPUT CREATE_PACKAGE
	COMMAND mkdir -p ${OUT_DIR}
	COMMAND tar cvf "${OUT_DIR}/${ARCHIVE_NAME}.tar" --transform 's,^.,${ARCHIVE_NAME},' .
	WORKING_DIRECTORY ${BIN_DIR}
	DEPENDS ALL_TARGETS
)

add_custom_target(
	${PROJECT_NAME} ALL 
	DEPENDS CREATE_PACKAGE
)

add_custom_target(
	cleanall
	DEPENDS CLEAN_ALL
)

# Configured Targets
if(BUSYBOX)
	add_dependencies(${PROJECT_NAME} busybox)
	add_subdirectory(busybox)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/busybox
		COMMAND cp -a ${PROJECT_BINARY_DIR}/busybox/out/busybox ${BIN_DIR}/busybox/
		COMMAND cp -a ${busybox_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS busybox
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS busybox_clean)
endif()

if(DROPBEAR)
	add_dependencies(${PROJECT_NAME} dropbearmulti)
	add_subdirectory(dropbear)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/dropbear
		COMMAND cp -a ${PROJECT_BINARY_DIR}/dropbear/out/dropbearmulti ${BIN_DIR}/dropbear/
		COMMAND cp -a ${dropbear_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS dropbear
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS dropbear_clean)
endif()

if(DOSFSTOOLS)
	add_dependencies(${PROJECT_NAME} dosfstools)
	add_subdirectory(dosfstools)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/dosfstools
		COMMAND cp -a ${PROJECT_BINARY_DIR}/dosfstools/out/fatlabel ${BIN_DIR}/dosfstools/
		COMMAND cp -a ${PROJECT_BINARY_DIR}/dosfstools/out/fsck.fat ${BIN_DIR}/dosfstools/
		COMMAND cp -a ${PROJECT_BINARY_DIR}/dosfstools/out/mkfs.fat ${BIN_DIR}/dosfstools/
		COMMAND cp -a ${dosfstools_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS dosfstools
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS dosfstools_clean)
endif()

if(FFMPEG)
	add_dependencies(${PROJECT_NAME} ffmpeg)
	add_subdirectory(ffmpeg)
	add_subdirectory(x264)
	add_dependencies(
		ffmpeg
		x264
	)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/x264/lib
		COMMAND cp -a ${PROJECT_BINARY_DIR}/x264/out/lib/libx264.so.164 ${BIN_DIR}/x264/lib/
		COMMAND mkdir -p ${BIN_DIR}/ffmpeg/lib
		COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/bin ${BIN_DIR}/ffmpeg/
		COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libavcodec.so.59.18.100 ${BIN_DIR}/ffmpeg/lib/libavcodec.so.59
		COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libavdevice.so.59.4.100 ${BIN_DIR}/ffmpeg/lib/libavdevice.so.59
		COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libavfilter.so.8.24.100 ${BIN_DIR}/ffmpeg/lib/libavfilter.so.8
		COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libavformat.so.59.16.100 ${BIN_DIR}/ffmpeg/lib/libavformat.so.59
		COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libavutil.so.57.17.100 ${BIN_DIR}/ffmpeg/lib/libavutil.so.57
		COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libpostproc.so.56.3.100 ${BIN_DIR}/ffmpeg/lib/libpostproc.so.56
		COMMAND cp -a ${x264_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		COMMAND cp -a ${ffmpeg_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS x264 ffmpeg
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS x264_clean ffmpeg_clean)
endif()

if(NTPCLIENT)
	add_dependencies(${PROJECT_NAME} ntpclient)
	add_subdirectory(ntpclient)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/ntpclient
		COMMAND cp -a ${PROJECT_BINARY_DIR}/ntpclient/out/ntpclient ${BIN_DIR}/ntpclient/
		COMMAND cp -a ${ntpclient_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS ntpclient
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS ntpclient_clean)
endif()

if(UNTRUNC)
	add_dependencies(${PROJECT_NAME} untrunc)
	add_subdirectory(untrunc)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/untrunc
		COMMAND cp -a ${PROJECT_BINARY_DIR}/untrunc/out/untrunc ${BIN_DIR}/untrunc/
		DEPENDS untrunc
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS untrunc_clean)  
endif()

if(TINYCURL)
	add_dependencies(${PROJECT_NAME} bearssl tinycurl)
	add_subdirectory(bearssl)
	add_subdirectory(tinycurl)
	add_dependencies(
		tinycurl
		bearssl
	)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/bearssl
		COMMAND cp -a ${PROJECT_BINARY_DIR}/bearssl/out/* ${BIN_DIR}/bearssl/
		COMMAND cp -a ${bearssl_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		COMMAND mkdir -p ${BIN_DIR}/tinycurl
		COMMAND cp -a ${PROJECT_BINARY_DIR}/tinycurl/out/bin/curl ${BIN_DIR}/tinycurl/
		COMMAND cp -a ${tinycurl_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS bearssl tinycurl
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS bearssl_clean tinycurl_clean)
endif()

# Final Operation
add_custom_command(
	OUTPUT ALL_TARGETS APPEND
	COMMAND cp -a ${SCRIPTS_DIR}/* ${BIN_DIR}/
	COMMAND cp -a ${CMAKE_SOURCE_DIR}/VERSION ${BIN_DIR}/
)
