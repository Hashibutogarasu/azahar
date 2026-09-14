// Copyright 2019 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <algorithm>
#include <array>
#include <cstdlib>
#include <string>
#include <android/native_window_jni.h>
#include "common/logging/log.h"
#include "common/settings.h"
#include "input_common/main.h"
#include "jni/emu_window/emu_window.h"
#include "jni/id_cache.h"
#include "jni/input_manager.h"
#include "jni/util.h"
#include "core/frontend/framebuffer_layout.h"
#include "network/network.h"
#include "video_core/renderer_base.h"

bool EmuWindow_Android::OnSurfaceChanged(ANativeWindow* surface) {
    if (render_window == surface) {
        return false;
    }

    render_window = surface;
    window_info.type = Frontend::WindowSystemType::Android;
    window_info.render_surface = surface;

    StopPresenting();
    OnFramebufferSizeChanged();
    return true;
}

bool EmuWindow_Android::OnTouchEvent(int x, int y, bool pressed) {
    if (pressed) {
        return TouchPressed((unsigned)std::max(x, 0), (unsigned)std::max(y, 0));
    }

    TouchReleased();
    return true;
}

void EmuWindow_Android::OnTouchMoved(int x, int y) {
    TouchMoved((unsigned)std::max(x, 0), (unsigned)std::max(y, 0));
}

/// Always fits this window's single screen (top, or bottom when is_secondary) to its own
/// surface. Layout, sizing and swapping of the two screens on-screen is entirely up to the app
/// (Compose); this class never consults Settings::values.layout_option/swap_screen.
void EmuWindow_Android::OnFramebufferSizeChanged() {
    const auto layout = Layout::SingleFrameLayout(std::max(window_width, 1),
                                                  std::max(window_height, 1), is_secondary,
                                                  Settings::values.upright_screen.GetValue());
    NotifyFramebufferLayoutChanged(layout);
}

EmuWindow_Android::EmuWindow_Android(ANativeWindow* surface, bool is_secondary_)
    : Frontend::EmuWindow(is_secondary_), host_window{surface} {
    LOG_DEBUG(Frontend, "Initializing EmuWindow_Android");

    if (!surface) {
        LOG_CRITICAL(Frontend, "surface is nullptr");
        return;
    }

    window_width = ANativeWindow_getWidth(surface);
    window_height = ANativeWindow_getHeight(surface);

    Network::Init();
}

EmuWindow_Android::~EmuWindow_Android() {
    DestroyWindowSurface();
    DestroyContext();
}

void EmuWindow_Android::MakeCurrent() {
    core_context->MakeCurrent();
}

void EmuWindow_Android::DoneCurrent() {
    core_context->DoneCurrent();
}
