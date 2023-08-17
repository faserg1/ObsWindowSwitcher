cmake_minimum_required (VERSION 3.12)
project (ObsWindowSwitcher C CXX)

set(CMAKE_CXX_STANDARD 20)
set(TARGET_CXX_STD cxx_std_20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(WINDOW_BUILD_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/window/bin/$<CONFIG>/)

add_subdirectory(godot-cpp)

if("${CMAKE_BUILD_TYPE}" STREQUAL "")
	set(CMAKE_BUILD_TYPE Debug)
endif()

if(NOT DEFINED BITS)
	set(BITS 32)
	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		set(BITS 64)
	endif(CMAKE_SIZEOF_VOID_P EQUAL 8)
endif()

add_subdirectory(src/window)
