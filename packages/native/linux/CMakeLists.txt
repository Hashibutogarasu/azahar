cmake_minimum_required(VERSION 3.13)

set(PROJECT_NAME "azahar_for_flutter")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "azahar_for_flutter_plugin")

list(APPEND PLUGIN_SOURCES
  "azahar_for_flutter_plugin.cc"
  "native_bridge/user_directory.cc"
  "native_bridge/game_scanner.cc"
  "native_bridge/system_save_game.cc"
  "native_bridge/emulator_config.cc"
  "native_bridge/cia_install.cc"
  "native_bridge/emulation.cc"
  "native_bridge/system_files.cc"
  "native_bridge/game_actions.cc"
  "native_bridge/wifi.cc"
  "native_bridge/cheats.cc"
  "native_bridge/gamepad.cc"
)

# The core static libraries are linked into the executable, so the plugin is
# a static library that shares the executable's link step instead of a shared
# library that would need position independent core objects.
add_library(${PLUGIN_NAME} STATIC
  ${PLUGIN_SOURCES}
)

apply_standard_settings(${PLUGIN_NAME})

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET default
  POSITION_INDEPENDENT_CODE OFF)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_compile_features(${PLUGIN_NAME} PRIVATE cxx_std_20)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_include_directories(${PLUGIN_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(${PLUGIN_NAME} PUBLIC flutter)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED IMPORTED_TARGET gtk+-3.0)
target_link_libraries(${PLUGIN_NAME} PUBLIC PkgConfig::GTK)

get_filename_component(PLUGIN_LINUX_DIR "${CMAKE_CURRENT_SOURCE_DIR}" REALPATH)
get_filename_component(AZAHAR_ROOT "${PLUGIN_LINUX_DIR}/../../.." REALPATH)
set(AZAHAR_BUILD "${AZAHAR_ROOT}/build")
set(AZAHAR_CORE "${AZAHAR_ROOT}/packages/core")

find_program(NINJA_EXECUTABLE ninja REQUIRED)
add_custom_target(azahar_core_libs
  COMMAND "${NINJA_EXECUTABLE}" citra_core citra_common network input_common web_service
  WORKING_DIRECTORY "${AZAHAR_BUILD}"
  COMMENT "Building azahar core libraries (${AZAHAR_BUILD})"
)
add_dependencies(${PLUGIN_NAME} azahar_core_libs)

target_compile_definitions(${PLUGIN_NAME} PRIVATE
  BOOST_ALL_NO_LIB
  BOOST_ASIO_DISABLE_CONCEPTS
  BOOST_DATE_TIME_NO_LIB
  BOOST_ERROR_CODE_HEADER_ONLY
  BOOST_NO_CXX98_FUNCTION_BASE
  BOOST_REGEX_NO_LIB
  BOOST_SYSTEM_NO_LIB
  ENABLE_OPENGL
  ENABLE_QT
  ENABLE_SCRIPTING
  ENABLE_SOFTWARE_RENDERER
  ENABLE_VULKAN
  ENABLE_WEB_SERVICE
  HAVE_CUBEB
  HAVE_OPENAL
  MICROPROFILE_ENABLED=0
  NDEBUG
  _FILE_OFFSET_BITS=64
  CPPHTTPLIB_OPENSSL_SUPPORT
)

target_include_directories(${PLUGIN_NAME} PRIVATE
  "${AZAHAR_CORE}/src"
  "${AZAHAR_BUILD}/include"
  "${AZAHAR_BUILD}/src"
  "${AZAHAR_CORE}/externals/boost"
  "${AZAHAR_CORE}/externals/lodepng/lodepng"
  "${AZAHAR_CORE}/externals/microprofile"
)

file(GLOB AZAHAR_EXTERNAL_INCLUDE_DIRS
  "${AZAHAR_CORE}/externals/*/include"
  "${AZAHAR_CORE}/externals/*/*/include"
)
target_include_directories(${PLUGIN_NAME} PRIVATE ${AZAHAR_EXTERNAL_INCLUDE_DIRS})

file(GLOB_RECURSE AZAHAR_CORE_LIBS
  "${AZAHAR_BUILD}/src/*.a"
  "${AZAHAR_BUILD}/externals/*.a"
)

target_link_libraries(${PLUGIN_NAME} PUBLIC
  -Wl,--start-group
  ${AZAHAR_CORE_LIBS}
  -Wl,--end-group
)
find_package(Threads REQUIRED)
target_link_libraries(${PLUGIN_NAME} PUBLIC Threads::Threads)

pkg_check_modules(DBUS REQUIRED IMPORTED_TARGET dbus-1)
target_link_libraries(${PLUGIN_NAME} PUBLIC PkgConfig::DBUS)

pkg_check_modules(EGL REQUIRED IMPORTED_TARGET egl)
target_link_libraries(${PLUGIN_NAME} PUBLIC PkgConfig::EGL)

target_link_options(${PLUGIN_NAME} PUBLIC -flto -flto-partition=one -O3 -g0)
target_compile_options(${PLUGIN_NAME} PRIVATE
  -flto
  -fno-fat-lto-objects
  -O3
  -g0
  -fvisibility=default
  -Wp,-D_GLIBCXX_ASSERTIONS
  -fstack-protector-strong
  -fstack-clash-protection
  -Wno-error
)

set(azahar_for_flutter_bundled_libraries
  ""
  PARENT_SCOPE
)
