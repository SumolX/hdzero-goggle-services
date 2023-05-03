cmake_minimum_required(VERSION 3.10)

project(HDZGOGGLE-SERVICES)

file(STRINGS ${CMAKE_SOURCE_DIR}/VERSION BUILD_NUMBER)

set(OUTPUT_DIR ${CMAKE_SOURCE_DIR}/out)
set(PACKAGE_DIR ${CMAKE_SOURCE_DIR}/pkg)
set(SCRIPTS_DIR ${CMAKE_SOURCE_DIR}/scripts)
set(ARCHIVE_NAME "hdzgoggle-services-${BUILD_NUMBER}")

add_subdirectory(dropbear)

add_custom_command(
	OUTPUT DROPBEARMULTI
	COMMAND mkdir -p ${OUTPUT_DIR}/dropbear
	COMMAND cp ${PROJECT_BINARY_DIR}/dropbear/out/dropbearmulti ${OUTPUT_DIR}/dropbear/
	DEPENDS dropbearmulti
)

add_custom_command(
	OUTPUT ALL_SCRIPTS
	COMMAND mkdir -p ${OUTPUT_DIR}/scripts
	COMMAND cp ${dropbear_SOURCE_DIR}/scripts/* ${OUTPUT_DIR}/scripts/
	COMMAND cp ${SCRIPTS_DIR}/* ${OUTPUT_DIR}/
	COMMAND cp ${CMAKE_SOURCE_DIR}/VERSION ${OUTPUT_DIR}/
	DEPENDS DROPBEARMULTI
)

add_custom_command(
	OUTPUT CREATE_PACKAGE
	COMMAND mkdir -p ${PACKAGE_DIR}
	COMMAND tar cvf "${PACKAGE_DIR}/${ARCHIVE_NAME}.tar" --transform 's,^.,${ARCHIVE_NAME},' .
	WORKING_DIRECTORY ${OUTPUT_DIR}
	DEPENDS ALL_SCRIPTS
)

add_custom_command(
	OUTPUT PURGE_ALL
	COMMAND rm -rf ${OUTPUT_DIR}
	COMMAND rm -rf ${PACKAGE_DIR}
	depends dropbear_cleanall
)

add_custom_target(
	${PROJECT_NAME} ALL 
	DEPENDS DROPBEARMULTI CREATE_PACKAGE
)

add_custom_target(
	purgeall
	DEPENDS PURGE_ALL
)

add_dependencies(${PROJECT_NAME} dropbearmulti)
