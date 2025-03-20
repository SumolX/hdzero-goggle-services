cmake_minimum_required(VERSION 3.14)
project (ntpclient C)
message("Building NTPCLIENT...")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/out)

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
