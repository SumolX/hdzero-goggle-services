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
add_subdirectory(x264)

add_dependencies(
	tinycurl
	bearssl
)

add_dependencies(
	ffmpeg
	x264
)

add_custom_command(
	OUTPUT ALL_TARGETS

	COMMAND mkdir -p ${BIN_DIR}/bearssl
	COMMAND cp -a ${PROJECT_BINARY_DIR}/bearssl/out/* ${BIN_DIR}/bearssl/

	COMMAND mkdir -p ${BIN_DIR}/busybox
	COMMAND cp -a ${PROJECT_BINARY_DIR}/busybox/out/busybox ${BIN_DIR}/busybox/

	COMMAND mkdir -p ${BIN_DIR}/dosfstools
	COMMAND cp -a ${PROJECT_BINARY_DIR}/dosfstools/out/fatlabel ${BIN_DIR}/dosfstools/
	COMMAND cp -a ${PROJECT_BINARY_DIR}/dosfstools/out/fsck.fat ${BIN_DIR}/dosfstools/
	COMMAND cp -a ${PROJECT_BINARY_DIR}/dosfstools/out/mkfs.fat ${BIN_DIR}/dosfstools/
	
	COMMAND mkdir -p ${BIN_DIR}/dropbear
	COMMAND cp -a ${PROJECT_BINARY_DIR}/dropbear/out/dropbearmulti ${BIN_DIR}/dropbear/

	COMMAND mkdir -p ${BIN_DIR}/ffmpeg/lib
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/bin ${BIN_DIR}/ffmpeg/
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libavcodec.so.59.18.100 ${BIN_DIR}/ffmpeg/lib/libavcodec.so.59
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libavdevice.so.59.4.100 ${BIN_DIR}/ffmpeg/lib/libavdevice.so.59
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libavfilter.so.8.24.100 ${BIN_DIR}/ffmpeg/lib/libavfilter.so.8
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libavformat.so.59.16.100 ${BIN_DIR}/ffmpeg/lib/libavformat.so.59
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libavutil.so.57.17.100 ${BIN_DIR}/ffmpeg/lib/libavutil.so.57
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ffmpeg/out/lib/libpostproc.so.56.3.100 ${BIN_DIR}/ffmpeg/lib/libpostproc.so.56

	COMMAND mkdir -p ${BIN_DIR}/ntpclient
	COMMAND cp -a ${PROJECT_BINARY_DIR}/ntpclient/out/ntpclient ${BIN_DIR}/ntpclient/

	COMMAND mkdir -p ${BIN_DIR}/tinycurl
	COMMAND cp -a ${PROJECT_BINARY_DIR}/tinycurl/out/bin/curl ${BIN_DIR}/tinycurl/

	COMMAND mkdir -p ${BIN_DIR}/untrunc
	COMMAND cp -a ${PROJECT_BINARY_DIR}/untrunc/out/untrunc ${BIN_DIR}/untrunc/

	COMMAND mkdir -p ${BIN_DIR}/x264/lib
	COMMAND cp -a ${PROJECT_BINARY_DIR}/x264/out/lib/libx264.so.164 ${BIN_DIR}/x264/lib/

	COMMAND mkdir -p ${BIN_DIR}/scripts
	COMMAND cp -a ${bearssl_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${busybox_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${dosfstools_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${dropbear_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${ffmpeg_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${ntpclient_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${tinycurl_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${x264_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
	COMMAND cp -a ${SCRIPTS_DIR}/* ${BIN_DIR}/
	COMMAND cp -a ${CMAKE_SOURCE_DIR}/VERSION ${BIN_DIR}/

	DEPENDS bearssl busybox dosfstools dropbear ffmpeg ntpclient tinycurl untrunc x264
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
	DEPENDS bearssl_clean busybox_clean dropbear_clean ffmpeg_clean ntpclient_clean tinycurl_clean untrunc_clean x264_clean
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
