cmake_minimum_required(VERSION 3.10)

project(HDZGOGGLE-SERVICES)

# Configuration
option(BEARSSL    "" ON)
option(BUSYBOX    "" ON)
option(DOSFSTOOLS "" ON)
option(DROPBEAR   "" ON)
option(FBGRAB     "" ON)
option(FFMPEG     "" ON)
option(IPERF      "" ON)
option(LIBPNG     "" ON)
option(LIBX264    "" ON)
option(LIBZ       "" ON)
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
if(BEARSSL)
	message("Configuring BEARSSL...")
	add_dependencies(${PROJECT_NAME} bearssl)
	add_subdirectory(src/bearssl)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/bearssl
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/bearssl/out/* ${BIN_DIR}/bearssl/
		COMMAND cp -a ${bearssl_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS bearssl
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS bearssl_clean)
endif()

if(BUSYBOX)
	message("Configuring BUSYBOX...")
	add_dependencies(${PROJECT_NAME} busybox)
	add_subdirectory(src/busybox)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/busybox
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/busybox/out/busybox ${BIN_DIR}/busybox/
		COMMAND cp -a ${busybox_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS busybox
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS busybox_clean)
endif()

if(DROPBEAR)
	message("Configuring DROPBEAR...")
	add_dependencies(${PROJECT_NAME} dropbearmulti)
	add_subdirectory(src/dropbear)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/dropbear
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/dropbear/out/dropbearmulti ${BIN_DIR}/dropbear/
		COMMAND cp -a ${dropbear_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS dropbearmulti
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS dropbear_clean)
endif()

if(DOSFSTOOLS)
	message("Configuring DOSFSTOOLS...")
	add_dependencies(${PROJECT_NAME} dosfstools)
	add_subdirectory(src/dosfstools)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/dosfstools
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/dosfstools/out/fatlabel ${BIN_DIR}/dosfstools/
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/dosfstools/out/fsck.fat ${BIN_DIR}/dosfstools/
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/dosfstools/out/mkfs.fat ${BIN_DIR}/dosfstools/
		COMMAND cp -a ${dosfstools_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS dosfstools
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS dosfstools_clean)
endif()

if(FBGRAB)
	message("Configuring FBGRAB...")
	add_dependencies(${PROJECT_NAME} fbgrab)
	add_subdirectory(src/fbgrab)
	add_dependencies(fbgrab libpng)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/fbgrab
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/fbgrab/out/fbgrab ${BIN_DIR}/fbgrab/
		DEPENDS fbgrab
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS fbgrab_clean)
endif()

if(FFMPEG)
	message("Configuring FFMPEG...")
	add_dependencies(${PROJECT_NAME} ffmpeg)
	add_subdirectory(src/ffmpeg)
	add_dependencies(ffmpeg libx264)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/ffmpeg/lib
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/ffmpeg/out/bin ${BIN_DIR}/ffmpeg/
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/ffmpeg/out/lib/libavcodec.so.59.18.100 ${BIN_DIR}/ffmpeg/lib/libavcodec.so.59
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/ffmpeg/out/lib/libavdevice.so.59.4.100 ${BIN_DIR}/ffmpeg/lib/libavdevice.so.59
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/ffmpeg/out/lib/libavfilter.so.8.24.100 ${BIN_DIR}/ffmpeg/lib/libavfilter.so.8
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/ffmpeg/out/lib/libavformat.so.59.16.100 ${BIN_DIR}/ffmpeg/lib/libavformat.so.59
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/ffmpeg/out/lib/libavutil.so.57.17.100 ${BIN_DIR}/ffmpeg/lib/libavutil.so.57
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/ffmpeg/out/lib/libpostproc.so.56.3.100 ${BIN_DIR}/ffmpeg/lib/libpostproc.so.56
		COMMAND cp -a ${ffmpeg_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS ffmpeg
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS ffmpeg_clean)
endif()

if(IPERF)
	message("Configuring IPERF...")
	add_dependencies(${PROJECT_NAME} iperf)
	add_subdirectory(src/iperf)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/iperf
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/iperf/out/iperf3 ${BIN_DIR}/iperf/
		DEPENDS iperf
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS iperf_clean)
endif()

if(LIBPNG)
	message("Configuring LIBPNG...")
	add_dependencies(${PROJECT_NAME} libpng)
	add_subdirectory(src/libpng)
	add_dependencies(libpng libz)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/libpng
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/libpng/out/* ${BIN_DIR}/libpng/
		DEPENDS libpng
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS libpng_clean)
endif()

if(LIBX264)
	message("Configuring LIBX264...")
	add_dependencies(${PROJECT_NAME} libx264)
	add_subdirectory(src/libx264)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/libx264
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/libx264/out/* ${BIN_DIR}/libx264/
		COMMAND cp -a ${libx264_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS libx264
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS libx264_clean)
endif()

if(LIBZ)
	message("Configuring LIBZ...")
	add_dependencies(${PROJECT_NAME} libz)
	add_subdirectory(src/libz)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/libz
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/libz/out/* ${BIN_DIR}/libz/
		DEPENDS libz
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS libz_clean)
endif()

if(NTPCLIENT)
	message("Configuring NTPCLIENT...")
	add_dependencies(${PROJECT_NAME} ntpclient)
	add_subdirectory(src/ntpclient)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/ntpclient
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/ntpclient/out/ntpclient ${BIN_DIR}/ntpclient/
		COMMAND cp -a ${ntpclient_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS ntpclient
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS ntpclient_clean)
endif()

if(UNTRUNC)
	message("Configuring UNTRUNC...")
	add_dependencies(${PROJECT_NAME} untrunc)
	add_subdirectory(src/untrunc)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/untrunc
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/untrunc/out/untrunc ${BIN_DIR}/untrunc/
		DEPENDS untrunc
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS untrunc_clean)  
endif()

if(TINYCURL)
	message("Configuring TINYCURL...")
	add_dependencies(${PROJECT_NAME} tinycurl)
	add_subdirectory(src/tinycurl)
	add_dependencies(tinycurl bearssl)
	add_custom_command(
		OUTPUT ALL_TARGETS APPEND
		COMMAND mkdir -p ${BIN_DIR}/tinycurl
		COMMAND cp -a ${PROJECT_BINARY_DIR}/src/tinycurl/out/bin/curl ${BIN_DIR}/tinycurl/
		COMMAND cp -a ${tinycurl_SOURCE_DIR}/scripts/* ${BIN_DIR}/scripts/
		DEPENDS tinycurl
	)
	add_custom_command(OUTPUT CLEAN_ALL APPEND DEPENDS tinycurl_clean)
endif()

# Final Operation
add_custom_command(
	OUTPUT ALL_TARGETS APPEND
	COMMAND cp -a ${SCRIPTS_DIR}/* ${BIN_DIR}/
	COMMAND cp -a ${CMAKE_SOURCE_DIR}/VERSION ${BIN_DIR}/
)
