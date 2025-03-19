cmake_minimum_required(VERSION 3.14)
project (fbgrab C)

include(FetchContent)

FetchContent_Declare(
	fbgrab
	GIT_REPOSITORY "https://github.com/GunnarMonell/fbgrab.git"
	GIT_TAG        "1.5"
	SOURCE_DIR     "src"
	BINARY_DIR     "out"
)
FetchContent_Populate(fbgrab)

set(CFLAGS "${CFLAGS} -I../../libpng/out/include -I../../libz/out/include")
set(LDFLAGS "${LDFLAGS} -L../../libpng/out/lib -L../../libz/out/lib")

if(DEFINED CMAKE_TOOLCHAIN_FILE)
add_custom_command(
	OUTPUT fbgrab_build
	# Forcing static build type
	COMMAND patch ${fbgrab_SOURCE_DIR}/Makefile -i ${PROJECT_SOURCE_DIR}/patch/Makefile.diff
	COMMAND . ${PROJECT_BINARY_DIR}/../toolchain.sh && cd ${fbgrab_SOURCE_DIR} && CFLAGS=${CFLAGS} LDFLAGS=${LDFLAGS} make
	COMMAND cp ${fbgrab_SOURCE_DIR}/fbgrab ${fbgrab_BINARY_DIR}
)
else()
add_custom_command(
	OUTPUT fbgrab_build
	COMMAND cd ${fbgrab_SOURCE_DIR} && make
	COMMAND cp ${fbgrab_SOURCE_DIR}/fbgrab ${fbgrab_BINARY_DIR}
)
endif()

add_custom_command(
	OUTPUT fbgrab_cleanall
	COMMAND find . -name '*.o' -delete
	COMMAND find . -name '*.a' -delete
	COMMAND rm -rf ${fbgrab_BINARY_DIR}/*
)

add_custom_target(fbgrab ALL DEPENDS fbgrab_build)
add_custom_target(fbgrab_clean DEPENDS fbgrab_cleanall)
