cmake_minimum_required(VERSION 3.14)
project (iperf C)

include(FetchContent)

FetchContent_Declare(
	iperf
	GIT_REPOSITORY "https://github.com/esnet/iperf.git"
	GIT_TAG        "3.18"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_Populate(iperf)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
add_custom_command(
	OUTPUT iperf_build
	COMMENT "Building IPERF (Toolchain)..."
	COMMAND . ${CMAKE_BINARY_DIR}/toolchain.sh && cd ${iperf_SOURCE_DIR} && ./configure --enable-static-bin --host=x86_64-pc-linux-gnu --build=arm-buildroot-linux-musleabihf && make -j
	COMMAND cp ${iperf_SOURCE_DIR}/src/iperf3 ${iperf_BINARY_DIR}
)
else()
add_custom_command(
	OUTPUT iperf_build
	COMMENT "Building IPERF (Native)..."
	COMMAND cd ${iperf_SOURCE_DIR} && ./configure && make
	COMMAND cp ${iperf_SOURCE_DIR}/src/iperf3 ${iperf_BINARY_DIR}
)
endif()

add_custom_command(
	OUTPUT iperf_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${iperf_BINARY_DIR}/*
)

add_custom_target(iperf ALL DEPENDS iperf_build)
add_custom_target(iperf_clean DEPENDS iperf_cleanall)
