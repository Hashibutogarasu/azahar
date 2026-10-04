// Copyright 2019 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <vector>
#include "core/frontend/emu_window.h"

namespace Core {
class System;
}

class EmuWindow_Android : public Frontend::EmuWindow {
public:
    /**
     * @param surface The native window to render into.
     * @param is_secondary_ When true, this window always renders the 3DS bottom screen, fit to
     *        the whole surface, instead of the top screen. Android renders the top and bottom
     *        screens into two independent windows/surfaces; layout, sizing and on-screen ordering
     *        of the two is entirely decided by the app, not by this class.
     */
    EmuWindow_Android(ANativeWindow* surface, bool is_secondary_ = false);
    ~EmuWindow_Android();

    /// Called by the onSurfaceChanges() method to change the surface
    bool OnSurfaceChanged(ANativeWindow* surface);

    /// Handles touch event that occur.(Touched or released)
    bool OnTouchEvent(int x, int y, bool pressed);

    /// Handles movement of touch pointer
    void OnTouchMoved(int x, int y);

    void MakeCurrent() override;

    void DoneCurrent() override;

    virtual void TryPresenting() {}

    virtual void StopPresenting() {}

protected:
    void OnFramebufferSizeChanged();

    /// Creates the API specific window surface
    virtual bool CreateWindowSurface() {
        return false;
    }

    /// Destroys the API specific window surface
    virtual void DestroyWindowSurface() {}

    /// Destroys the graphics context
    virtual void DestroyContext() {}

protected:
    ANativeWindow* render_window{};
    ANativeWindow* host_window{};

    int window_width{};
    int window_height{};

    std::unique_ptr<Frontend::GraphicsContext> core_context;
};
