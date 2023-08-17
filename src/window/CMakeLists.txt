project(avatar)

set(CMAKE_CXX_STANDARD 20)
set(TARGET_CXX_STD cxx_std_20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/*.h"
    "${CMAKE_CURRENT_LIST_DIR}/*.hpp"
    "${CMAKE_CURRENT_LIST_DIR}/*.cpp")

string(TOLOWER "${CMAKE_SYSTEM_NAME}" SYSTEM_NAME)
string(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)

if(ANDROID)
    # Added the android abi after system name
    set(SYSTEM_NAME ${SYSTEM_NAME}.${ANDROID_ABI})

    # Android does not have the bits at the end if you look at the main godot repo build
    set(OUTPUT_NAME "window.${SYSTEM_NAME}.${BUILD_TYPE}")
else()
    set(OUTPUT_NAME "window.${SYSTEM_NAME}.${BUILD_TYPE}.${BITS}")
endif()

add_library(window SHARED ${SOURCES})
target_link_libraries(window PRIVATE godot::cpp)

set_target_properties( window
    PROPERTIES
    BUILD_OUTPUT_DIRECTORY "${WINDOW_BUILD_OUTPUT_DIRECTORY}/$<0:>"
    LIBRARY_OUTPUT_DIRECTORY "${WINDOW_BUILD_OUTPUT_DIRECTORY}/$<0:>"
	RUNTIME_OUTPUT_DIRECTORY "${WINDOW_BUILD_OUTPUT_DIRECTORY}/$<0:>"
    OUTPUT_NAME "${OUTPUT_NAME}"
)