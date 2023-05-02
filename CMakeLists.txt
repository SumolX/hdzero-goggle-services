cmake_minimum_required(VERSION 3.10)

project(HDZGOGGLE-SERVICES VERSION 1.1)

add_subdirectory(dropbear)

add_custom_command(
	OUTPUT DROPBEARMULTI
	COMMAND mkdir -p ${CMAKE_SOURCE_DIR}/out
	COMMAND cp ${PROJECT_BINARY_DIR}/dropbear/out/dropbearmulti ${CMAKE_SOURCE_DIR}/out
	DEPENDS dropbearmulti
)

add_custom_command(
	OUTPUT ALL_SCRIPTS
	COMMAND mkdir -p ${CMAKE_SOURCE_DIR}/out/scripts
	COMMAND cp ${dropbear_SOURCE_DIR}/scripts/* ${CMAKE_SOURCE_DIR}/out/scripts/
	DEPENDS DROPBEARMULTI
)

add_custom_target(${PROJECT_NAME} ALL DEPENDS DROPBEARMULTI ALL_SCRIPTS)

add_dependencies(${PROJECT_NAME} dropbearmulti)
