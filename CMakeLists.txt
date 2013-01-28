# Check http://webdev.elementaryos.org/docs/developer-guide/cmake for documentation

project (user-specific-alternatives)
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala)

#
# Base bits
#

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/user-specific-alternatives")
set (RELEASE_NAME "Obey the user.")
set (VERSION "0.1")
set (VERSION_INFO "Release")
set (CMAKE_C_FLAGS "-ggdb")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DOLLAR "$")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

configure_file (${CMAKE_SOURCE_DIR}/src/config.vala.cmake ${CMAKE_SOURCE_DIR}/src/config.vala)

find_package (PkgConfig)
pkg_check_modules (DEPS REQUIRED gio-2.0 granite)

add_definitions (${DEPS_CFLAGS})

link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.16.0" MINIMUM)

include (ValaPrecompile)
vala_precompile(VALA_C
    src/user-specific-alternatives.vala
PACKAGES
    gio-2.0
    granite
    posix
OPTIONS
    --thread
    --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi/
)

link_libraries (m)

add_executable (user-specific-alternatives ${VALA_C})
find_library (M_LIB m)
target_link_libraries (user-specific-alternatives ${M_LIB})

EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E make_directory lib/user-specific-alternatives)
install (TARGETS user-specific-alternatives RUNTIME DESTINATION lib/user-specific-alternatives)
#install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/user-specific-alternatives.desktop DESTINATION share/applications)
