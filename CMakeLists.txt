cmake_minimum_required(VERSION 3.10)

project(HDZGOGGLE-SERVICES)

file(STRINGS ${CMAKE_SOURCE_DIR}/VERSION BUILD_NUMBER)

set(OUTPUT_DIR ${CMAKE_SOURCE_DIR}/out)
set(SCRIPTS_DIR ${OUTPUT_DIR}/scripts)
set(PACKAGE_DIR ${CMAKE_SOURCE_DIR}/pkg)
set(ARCHIVE_NAME "hdzgoggle-services-${BUILD_NUMBER}")


add_subdirectory(dropbear)

add_custom_command(
	OUTPUT DROPBEARMULTI
	COMMAND mkdir -p ${OUTPUT_DIR}
	COMMAND cp ${PROJECT_BINARY_DIR}/dropbear/out/dropbearmulti ${OUTPUT_DIR}/
	DEPENDS dropbearmulti
)

add_custom_command(
	OUTPUT ALL_SCRIPTS
	COMMAND mkdir -p ${SCRIPTS_DIR}
	COMMAND cp ${dropbear_SOURCE_DIR}/scripts/* ${SCRIPTS_DIR}/
	DEPENDS DROPBEARMULTI
)

add_custom_command(
	OUTPUT CREATE_PACKAGE
	COMMAND mkdir -p ${PACKAGE_DIR}
	COMMAND tar czf "${PACKAGE_DIR}/${ARCHIVE_NAME}.tgz" --transform 's,^.,${ARCHIVE_NAME},' .
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
	purgeall ALL 
	DEPENDS PURGE_ALL
)

add_dependencies(${PROJECT_NAME} dropbearmulti)
