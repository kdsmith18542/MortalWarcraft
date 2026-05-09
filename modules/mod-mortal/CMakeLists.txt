cmake_minimum_required(VERSION 3.16)
project(mod-mortal)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

find_package(AzerothCore REQUIRED CONFIG)
find_package(Eluna REQUIRED CONFIG)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DAC_CORE_COMPILATION")

file(GLOB_RECURSE SOURCES src/*.cpp src/*.h)

add_module(mod-mortal SOURCES ${SOURCES})

target_include_directories(mod-mortal PRIVATE src)
target_link_libraries(mod-mortal PRIVATE Eluna::Eluna)

install(TARGETS mod-mortal
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
