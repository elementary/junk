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
#set (GETTEXT_PACKAGE "user-specific-alternatives"")
#set (RELEASE_NAME "Fast and connected.")
set (VERSION "0.1")
#set (VERSION_INFO "Release")
set (CMAKE_C_FLAGS "-ggdb")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DOLLAR "$")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

configure_file (${CMAKE_SOURCE_DIR}/src/config.vala.cmake ${CMAKE_SOURCE_DIR}/src/config.vala)
#add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")_l

find_package (PkgConfig)
pkg_check_modules (DEPS REQUIRED gio-2.0 granite) #posix is not required but I'm getting a posix compile error anyway

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

#include (GSettings)
#add_schema ("org.elementary.pantheon-terminal.gschema.xml")

link_libraries (m)
#add_subdirectory (po)

add_executable (user-specific-alternatives ${VALA_C})
find_library (M_LIB m)
target_link_libraries (user-specific-alternatives ${M_LIB})

install (TARGETS user-specific-alternatives RUNTIME DESTINATION bin)
#install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/pantheon-terminal.desktop DESTINATION share/applications)
