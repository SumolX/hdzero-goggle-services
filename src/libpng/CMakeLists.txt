cmake_minimum_required(VERSION 3.14)
project (libpng C)

include(FetchContent)

FetchContent_Declare(
	libpng
	GIT_REPOSITORY "https://github.com/pnggroup/libpng.git"
	GIT_TAG        "v1.6.47"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_Populate(libpng)

if(DEFINED CMAKE_TOOLCHAIN_FILE)
add_custom_command(
	OUTPUT libpng_build
	COMMENT "Building LIBPNG (Toolchain)..."
	# CMakeLists.txt 1.6.47 bug, not able to override PNG_TARGET_ARCHITECTURE
	COMMAND patch ${libpng_SOURCE_DIR}/CMakeLists.txt -i ${PROJECT_SOURCE_DIR}/patch/CMakeLists.diff
	COMMAND cd ${libpng_SOURCE_DIR} && mkdir -p build && cd build && cmake .. -DPNG_SHARED=OFF -DZLIB_ROOT=${PROJECT_BINARY_DIR}/../libz/out && make
	COMMAND mkdir -p ${libpng_BINARY_DIR}/lib
	COMMAND mkdir -p ${libpng_BINARY_DIR}/include
	COMMAND cp ${libpng_SOURCE_DIR}/build/libpng16.a ${libpng_BINARY_DIR}/lib/
	COMMAND cp ${libpng_SOURCE_DIR}/build/libpng.a ${libpng_BINARY_DIR}/lib/
	COMMAND cp ${libpng_SOURCE_DIR}/build/pnglibconf.h ${libpng_BINARY_DIR}/include/
	COMMAND cp ${libpng_SOURCE_DIR}/pngconf.h ${libpng_BINARY_DIR}/include/
	COMMAND cp ${libpng_SOURCE_DIR}/png.h ${libpng_BINARY_DIR}/include/
)
else()
add_custom_command(
	OUTPUT libpng_build
	COMMENT "Building LIBPNG (Native)..."
	COMMAND cd ${libpng_SOURCE_DIR} && mkdir -p build && cd build && cmake .. -DZLIB_ROOT=${PROJECT_BINARY_DIR}/../libz/out && make
	COMMAND mkdir -p ${libpng_BINARY_DIR}/lib
	COMMAND mkdir -p ${libpng_BINARY_DIR}/include
	COMMAND cp ${libpng_SOURCE_DIR}/build/libpng16.a ${libpng_BINARY_DIR}/lib/
	COMMAND cp ${libpng_SOURCE_DIR}/build/libpng.a ${libpng_BINARY_DIR}/lib/
	COMMAND cp ${libpng_SOURCE_DIR}/build/pnglibconf.h ${libpng_BINARY_DIR}/include/
	COMMAND cp ${libpng_SOURCE_DIR}/pngconf.h ${libpng_BINARY_DIR}/include/
	COMMAND cp ${libpng_SOURCE_DIR}/png.h ${libpng_BINARY_DIR}/include/
)
endif()

add_custom_command(
	OUTPUT libpng_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${libpng_BINARY_DIR}/*
)

add_custom_target(libpng ALL DEPENDS libpng_build)
add_custom_target(libpng_clean DEPENDS libpng_cleanall)
