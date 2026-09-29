cmake_minimum_required(VERSION 3.13)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME}
  "main.cc"
  "my_application.cc"
  "native_bridge/user_directory.cc"
  "native_bridge/game_scanner.cc"
  "native_bridge/system_save_game.cc"
  "native_bridge/emulator_config.cc"
  "native_bridge/cia_install.cc"
  "native_bridge/emulation.cc"
  "native_bridge/system_files.cc"
  "native_bridge/game_actions.cc"
  "native_bridge/wifi.cc"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
)

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the application ID.
add_definitions(-DAPPLICATION_ID="${APPLICATION_ID}")

# Add dependency libraries. Add any application-specific dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTK)

target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

target_compile_features(${BINARY_NAME} PRIVATE cxx_std_20)

get_filename_component(AZAHAR_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../../../.." REALPATH)
set(AZAHAR_BUILD "${AZAHAR_ROOT}/build")

find_program(NINJA_EXECUTABLE ninja REQUIRED)
add_custom_target(azahar_core_libs
  COMMAND "${NINJA_EXECUTABLE}" citra_core citra_common network input_common web_service
  WORKING_DIRECTORY "${AZAHAR_BUILD}"
  COMMENT "Building azahar core libraries (${AZAHAR_BUILD})"
)
add_dependencies(${BINARY_NAME} azahar_core_libs)

target_compile_definitions(${BINARY_NAME} PRIVATE
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
)

target_include_directories(${BINARY_NAME} PRIVATE
  "${AZAHAR_ROOT}/src"
  "${AZAHAR_BUILD}/include"
  "${AZAHAR_BUILD}/src"
  "${AZAHAR_ROOT}/externals/boost"
  "${AZAHAR_ROOT}/externals/lodepng/lodepng"
  "${AZAHAR_ROOT}/externals/microprofile"
)

file(GLOB AZAHAR_EXTERNAL_INCLUDE_DIRS
  "${AZAHAR_ROOT}/externals/*/include"
  "${AZAHAR_ROOT}/externals/*/*/include"
)
target_include_directories(${BINARY_NAME} PRIVATE ${AZAHAR_EXTERNAL_INCLUDE_DIRS})

file(GLOB_RECURSE AZAHAR_CORE_LIBS
  "${AZAHAR_BUILD}/src/*.a"
  "${AZAHAR_BUILD}/externals/*.a"
)

target_link_libraries(${BINARY_NAME} PRIVATE
  -Wl,--start-group
  ${AZAHAR_CORE_LIBS}
  -Wl,--end-group
)
find_package(Threads REQUIRED)
target_link_libraries(${BINARY_NAME} PRIVATE Threads::Threads)

find_package(PkgConfig REQUIRED)
pkg_check_modules(DBUS REQUIRED IMPORTED_TARGET dbus-1)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::DBUS)

pkg_check_modules(EGL REQUIRED IMPORTED_TARGET egl)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::EGL)

target_link_options(${BINARY_NAME} PRIVATE -flto -flto-partition=one -O3 -g0)
target_compile_options(${BINARY_NAME} PRIVATE
  -flto
  -fno-fat-lto-objects
  -O3
  -g0
  -fvisibility=default
  -Wp,-D_GLIBCXX_ASSERTIONS
  -fstack-protector-strong
  -fstack-clash-protection
)
target_compile_definitions(${BINARY_NAME} PRIVATE CPPHTTPLIB_OPENSSL_SUPPORT)

target_compile_options(${BINARY_NAME} PRIVATE -Wno-error)
