cmake_minimum_required(VERSION 3.16)

project(vala-texteditor LANGUAGES C)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")

find_package(Vala REQUIRED)
include(cmake/ValaPrecompile.cmake)

vala_precompile(VALA_SRC texteditor
    texteditor.vala
    PACKAGES gtk+-3.0
)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED IMPORTED_TARGET gtk+-3.0)

add_executable(texteditor ${VALA_SRC})
target_link_libraries(test PUBLIC PkgConfig::GTK)
