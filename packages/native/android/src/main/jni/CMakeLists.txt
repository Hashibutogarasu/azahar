set(AZAHAR_RUST_DIR "${AZAHAR_REPO_ROOT}/packages/azahar_rust")

# The same sources are built into two libraries. `citra-android` is the one `System.loadLibrary`
# loads and the application never lets go of. `azahar-session` is loaded and unloaded by the Rust
# crate for every game, so every global of the emulator is gone when the session is dropped.
function(azahar_android_library target)
    add_library(${target} SHARED
        android_common/android_common.cpp
        android_common/android_common.h
        applets/mii_selector.cpp
        applets/mii_selector.h
        applets/swkbd.cpp
        applets/swkbd.h
        input_manager.cpp
        input_manager.h
        camera/ndk_camera.cpp
        camera/ndk_camera.h
        camera/still_image_camera.cpp
        camera/still_image_camera.h
        cheats/cheat.cpp
        cheats/cheat.h
        cheats/cheat_engine.cpp
        cheats/memory_tools.cpp
        config.cpp
        config.h
        default_ini.h
        emu_window/emu_window.cpp
        emu_window/emu_window.h
        game_info.cpp
        id_cache.cpp
        id_cache.h
        native.cpp
        ndk_motion.cpp
        ndk_motion.h
        system_save_game.cpp
        native_log.cpp
        util.cpp
        util.h
    )

    target_include_directories(${target} PRIVATE "${AZAHAR_RUST_DIR}/include")
    target_link_options(${target} PRIVATE -Wl,-z,noexecstack)
    target_link_libraries(${target} PRIVATE audio_core citra_common citra_core input_common network)
    target_link_libraries(${target} PRIVATE android camera2ndk inih jnigraphics log mediandk yuv)

    if (ENABLE_OPENGL)
        target_sources(${target} PRIVATE
            emu_window/emu_window_gl.cpp
            emu_window/emu_window_gl.h
        )
        target_link_libraries(${target} PRIVATE EGL glad)
    endif()
    if (ENABLE_VULKAN)
        target_sources(${target} PRIVATE
            emu_window/emu_window_vk.cpp
            emu_window/emu_window_vk.h
        )
        if ("arm64" IN_LIST ARCHITECTURE)
            target_link_libraries(${target} PRIVATE adrenotools)
        endif()
    endif()
endfunction()

azahar_android_library(citra-android)
azahar_android_library(azahar-session)

if ("${ANDROID_ABI}" STREQUAL "arm64-v8a")
    set(AZAHAR_RUST_TARGET aarch64-linux-android)
elseif ("${ANDROID_ABI}" STREQUAL "x86_64")
    set(AZAHAR_RUST_TARGET x86_64-linux-android)
else()
    message(FATAL_ERROR "azahar_rust does not support the ABI ${ANDROID_ABI}")
endif()
string(REPLACE "-" "_" AZAHAR_RUST_TARGET_ENV "${AZAHAR_RUST_TARGET}")
string(TOUPPER "${AZAHAR_RUST_TARGET_ENV}" AZAHAR_RUST_TARGET_UPPER)
set(AZAHAR_RUST_CLANG "${ANDROID_TOOLCHAIN_ROOT}/bin/${AZAHAR_RUST_TARGET}${ANDROID_PLATFORM_LEVEL}-clang")
set(AZAHAR_RUST_LIB "${AZAHAR_RUST_DIR}/target/${AZAHAR_RUST_TARGET}/release/libazahar_rust.a")
find_program(CARGO_EXECUTABLE cargo REQUIRED)
add_custom_target(azahar_rust_lib
    COMMAND ${CMAKE_COMMAND} -E env
        "CC_${AZAHAR_RUST_TARGET_ENV}=${AZAHAR_RUST_CLANG}"
        "CXX_${AZAHAR_RUST_TARGET_ENV}=${AZAHAR_RUST_CLANG}++"
        "AR_${AZAHAR_RUST_TARGET_ENV}=${ANDROID_TOOLCHAIN_ROOT}/bin/llvm-ar"
        "CARGO_TARGET_${AZAHAR_RUST_TARGET_UPPER}_LINKER=${AZAHAR_RUST_CLANG}"
        "${CARGO_EXECUTABLE}" rustc --release --lib --crate-type staticlib
        --target ${AZAHAR_RUST_TARGET}
    WORKING_DIRECTORY "${AZAHAR_RUST_DIR}"
    BYPRODUCTS "${AZAHAR_RUST_LIB}"
    COMMENT "Building azahar_rust for ${AZAHAR_RUST_TARGET}"
)

# Only the library of the application contains the crate. It loads the library of the session.
add_dependencies(citra-android azahar_rust_lib)
target_link_libraries(citra-android PRIVATE
    -Wl,--whole-archive
    "${AZAHAR_RUST_LIB}"
    -Wl,--no-whole-archive
    OpenSLES
)
target_link_options(citra-android PRIVATE "-Wl,--export-dynamic-symbol=frb_*")

set(CPACK_PACKAGE_EXECUTABLES ${CPACK_PACKAGE_EXECUTABLES} citra-android azahar-session)
