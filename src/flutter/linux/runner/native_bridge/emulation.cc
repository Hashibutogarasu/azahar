#include "emulation.h"

#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <condition_variable>
#include <mutex>
#include <thread>

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <glad/glad.h>

#include "common/logging/backend.h"
#include "common/logging/log.h"
#include "common/microprofile.h"
#include "common/scope_exit.h"
#include "common/settings.h"
#include "core/core.h"
#include "core/frontend/applets/default_applets.h"
#include "core/frontend/emu_window.h"
#include "core/frontend/framebuffer_layout.h"
#include "input_common/main.h"
#include "network/network.h"
#include "user_directory.h"
#include "video_core/gpu.h"
#include "video_core/rasterizer_interface.h"
#include "video_core/renderer_base.h"

namespace Emulation {

namespace {

constexpr std::array<EGLint, 11> kConfigAttribs{
    EGL_SURFACE_TYPE,    EGL_PBUFFER_BIT, EGL_RENDERABLE_TYPE, EGL_OPENGL_BIT, EGL_RED_SIZE, 8,
    EGL_GREEN_SIZE,      8,               EGL_BLUE_SIZE,       8,             EGL_NONE,
};
constexpr std::array<EGLint, 5> kPbufferAttribs{EGL_WIDTH, 1, EGL_HEIGHT, 1, EGL_NONE};
constexpr std::array<EGLint, 7> kContextAttribs{
    EGL_CONTEXT_MAJOR_VERSION, 4, EGL_CONTEXT_MINOR_VERSION, 3, EGL_CONTEXT_OPENGL_PROFILE_MASK,
    EGL_CONTEXT_OPENGL_CORE_PROFILE_BIT, EGL_NONE,
};

// FlTextureGL::populate() only ever runs with Flutter's own EGL context current, and it is the
// only place that context is ever observable from here. The emulation thread waits on this to
// learn which context to create its share group against.
struct FlutterGlContext {
    std::mutex mutex;
    std::condition_variable cv;
    bool ready = false;
    EGLDisplay display = EGL_NO_DISPLAY;
    EGLContext context = EGL_NO_CONTEXT;
};

FlutterGlContext& GetFlutterGlContext() {
    static FlutterGlContext instance;
    return instance;
}

}  // namespace

struct AzaharTextureState {
    std::atomic<GLuint> texture_id{0};
    std::atomic<GLuint> width{1};
    std::atomic<GLuint> height{1};
};

#define AZAHAR_TYPE_TEXTURE (azahar_texture_get_type())
G_DECLARE_FINAL_TYPE(AzaharTexture, azahar_texture, AZAHAR, TEXTURE, FlTextureGL)

struct _AzaharTexture {
    FlTextureGL parent_instance;
    AzaharTextureState* state;
};

G_DEFINE_TYPE(AzaharTexture, azahar_texture, fl_texture_gl_get_type())

static gboolean azahar_texture_populate(FlTextureGL* texture, uint32_t* target, uint32_t* name,
                                        uint32_t* width, uint32_t* height, GError** error) {
    AzaharTexture* self = AZAHAR_TEXTURE(texture);

    FlutterGlContext& ctx = GetFlutterGlContext();
    if (!ctx.ready) {
        std::lock_guard<std::mutex> lock(ctx.mutex);
        if (!ctx.ready) {
            ctx.display = eglGetCurrentDisplay();
            ctx.context = eglGetCurrentContext();
            if (ctx.display != EGL_NO_DISPLAY && ctx.context != EGL_NO_CONTEXT) {
                ctx.ready = true;
                ctx.cv.notify_all();
            }
        }
    }

    *target = GL_TEXTURE_2D;
    *name = self->state->texture_id.load();
    *width = self->state->width.load();
    *height = self->state->height.load();
    return *name != 0;
}

static void azahar_texture_dispose(GObject* object) {
    AzaharTexture* self = AZAHAR_TEXTURE(object);
    delete self->state;
    self->state = nullptr;
    G_OBJECT_CLASS(azahar_texture_parent_class)->dispose(object);
}

static void azahar_texture_class_init(AzaharTextureClass* klass) {
    FL_TEXTURE_GL_CLASS(klass)->populate = azahar_texture_populate;
    G_OBJECT_CLASS(klass)->dispose = azahar_texture_dispose;
}

static void azahar_texture_init(AzaharTexture* self) {
    self->state = new AzaharTextureState();
}

namespace {

class SharedContext_Flutter : public Frontend::GraphicsContext {
public:
    SharedContext_Flutter(EGLDisplay display, EGLConfig config, EGLContext share_context)
        : display_{display},
          surface_{eglCreatePbufferSurface(display, config, kPbufferAttribs.data())},
          context_{eglCreateContext(display, config, share_context, kContextAttribs.data())} {}

    ~SharedContext_Flutter() override {
        eglDestroySurface(display_, surface_);
        eglDestroyContext(display_, context_);
    }

    void MakeCurrent() override {
        eglMakeCurrent(display_, surface_, surface_, context_);
    }

    void DoneCurrent() override {
        eglMakeCurrent(display_, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
    }

private:
    EGLDisplay display_;
    EGLSurface surface_;
    EGLContext context_;
};

// Renders into an offscreen FBO instead of a window surface. RendererBase::TryPresent() blits
// into whichever framebuffer is bound on GL_DRAW_FRAMEBUFFER at the time it is called, so binding
// our own export FBO there is enough to redirect presentation into a texture that Flutter's GL
// context can sample, since that texture is created in a context sharing Flutter's share group.
class EmuWindow_Flutter : public Frontend::EmuWindow {
public:
    EmuWindow_Flutter(Core::System& system, AzaharTexture* texture, FlTextureRegistrar* registrar,
                      int width, int height, bool is_secondary_window, EGLDisplay display,
                      EGLContext share_context)
        : Frontend::EmuWindow(is_secondary_window), system_{system}, texture_{texture},
          registrar_{registrar}, display_{display} {
        window_info.type = Frontend::WindowSystemType::Headless;
        window_width_ = width;
        window_height_ = height;

        eglInitialize(display_, nullptr, nullptr);
        EGLint num_configs{};
        eglChooseConfig(display_, kConfigAttribs.data(), &config_, 1, &num_configs);
        surface_ = eglCreatePbufferSurface(display_, config_, kPbufferAttribs.data());
        context_ = eglCreateContext(display_, config_, share_context, kContextAttribs.data());
        core_context_ = CreateSharedContext();

        OnFramebufferSizeChanged();
    }

    ~EmuWindow_Flutter() override {
        DestroyExportTexture();
        eglDestroySurface(display_, surface_);
        eglDestroyContext(display_, context_);
    }

    void PollEvents() override {}

    void MakeCurrent() override {
        core_context_->MakeCurrent();
    }

    void DoneCurrent() override {
        core_context_->DoneCurrent();
    }

    std::unique_ptr<Frontend::GraphicsContext> CreateSharedContext() const override {
        return std::make_unique<SharedContext_Flutter>(display_, config_, context_);
    }

    void Resize(int width, int height) {
        window_width_ = width;
        window_height_ = height;
        OnFramebufferSizeChanged();
    }

    bool OnTouchEvent(int x, int y, bool pressed) {
        if (pressed) {
            return TouchPressed(static_cast<unsigned>(std::max(x, 0)),
                                static_cast<unsigned>(std::max(y, 0)));
        }
        TouchReleased();
        return true;
    }

    void OnTouchMoved(int x, int y) {
        TouchMoved(static_cast<unsigned>(std::max(x, 0)), static_cast<unsigned>(std::max(y, 0)));
    }

    void TryPresenting() {
        if (!system_.IsPoweredOn()) {
            return;
        }
        eglMakeCurrent(display_, surface_, surface_, context_);
        EnsureExportTexture();
        glBindFramebuffer(GL_DRAW_FRAMEBUFFER, export_fbo_);
        glViewport(0, 0, window_width_, window_height_);
        system_.GPU().Renderer().TryPresent(0, is_secondary);
        glFlush();
        glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);

        texture_->state->width = static_cast<GLuint>(window_width_);
        texture_->state->height = static_cast<GLuint>(window_height_);
        texture_->state->texture_id = export_texture_;
        fl_texture_registrar_mark_texture_frame_available(registrar_, FL_TEXTURE(texture_));
    }

private:
    void OnFramebufferSizeChanged() {
        const auto layout =
            Layout::SingleFrameLayout(std::max(window_width_, 1), std::max(window_height_, 1),
                                      is_secondary, Settings::values.upright_screen.GetValue());
        NotifyFramebufferLayoutChanged(layout);
    }

    void EnsureExportTexture() {
        if (export_texture_ != 0 && exported_width_ == window_width_ &&
            exported_height_ == window_height_) {
            return;
        }
        DestroyExportTexture();

        glGenTextures(1, &export_texture_);
        glBindTexture(GL_TEXTURE_2D, export_texture_);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, window_width_, window_height_, 0, GL_RGBA,
                    GL_UNSIGNED_BYTE, nullptr);

        glGenFramebuffers(1, &export_fbo_);
        glBindFramebuffer(GL_FRAMEBUFFER, export_fbo_);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D,
                               export_texture_, 0);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        exported_width_ = window_width_;
        exported_height_ = window_height_;
    }

    void DestroyExportTexture() {
        if (export_fbo_ != 0) {
            glDeleteFramebuffers(1, &export_fbo_);
            export_fbo_ = 0;
        }
        if (export_texture_ != 0) {
            glDeleteTextures(1, &export_texture_);
            export_texture_ = 0;
        }
    }

    Core::System& system_;
    AzaharTexture* texture_;
    FlTextureRegistrar* registrar_;

    EGLDisplay display_;
    EGLConfig config_{};
    EGLSurface surface_{};
    EGLContext context_{};
    std::unique_ptr<Frontend::GraphicsContext> core_context_;

    int window_width_{};
    int window_height_{};

    GLuint export_fbo_{};
    GLuint export_texture_{};
    int exported_width_{};
    int exported_height_{};
};

std::unique_ptr<EmuWindow_Flutter> g_window;
std::unique_ptr<EmuWindow_Flutter> g_secondary_window;
AzaharTexture* g_primary_texture{};
AzaharTexture* g_secondary_texture{};
FlTextureRegistrar* g_texture_registrar{};
FlEventChannel* g_shader_progress_channel{};

std::atomic<bool> g_stop_run{true};
std::atomic<bool> g_pause_emulation{false};
std::atomic<bool> g_present_frames{false};
std::atomic<bool> g_present_thread_stop{false};

std::mutex g_paused_mutex;
std::mutex g_running_mutex;
std::condition_variable g_running_cv;

std::thread g_emulation_thread;
std::thread g_present_thread;

EmuWindow_Flutter* GetTouchscreenWindow() {
    return g_secondary_window ? g_secondary_window.get() : g_window.get();
}

const char* ShaderProgressStageName(VideoCore::LoadCallbackStage stage) {
    switch (stage) {
    case VideoCore::LoadCallbackStage::Prepare:
        return "prepare";
    case VideoCore::LoadCallbackStage::Decompile:
        return "decompile";
    case VideoCore::LoadCallbackStage::Build:
        return "build";
    case VideoCore::LoadCallbackStage::Complete:
        return "complete";
    default:
        return nullptr;
    }
}

struct ShaderProgressEvent {
    VideoCore::LoadCallbackStage stage;
    std::size_t progress;
    std::size_t max;
};

gboolean SendShaderProgressEvent(gpointer user_data) {
    std::unique_ptr<ShaderProgressEvent> event(static_cast<ShaderProgressEvent*>(user_data));
    const char* stage_name = ShaderProgressStageName(event->stage);
    if (!g_shader_progress_channel || !stage_name) {
        return G_SOURCE_REMOVE;
    }
    g_autoptr(FlValue) map = fl_value_new_map();
    fl_value_set_string_take(map, "stage", fl_value_new_string(stage_name));
    fl_value_set_string_take(map, "progress",
                             fl_value_new_int(static_cast<int64_t>(event->progress)));
    fl_value_set_string_take(map, "max", fl_value_new_int(static_cast<int64_t>(event->max)));
    fl_event_channel_send(g_shader_progress_channel, map, nullptr, nullptr);
    return G_SOURCE_REMOVE;
}

void ReportShaderProgress(VideoCore::LoadCallbackStage stage, std::size_t progress,
                          std::size_t max) {
    g_idle_add(SendShaderProgressEvent, new ShaderProgressEvent{stage, progress, max});
}

void EnsureLoggingInitialized() {
    static const bool initialized = [] {
        Common::Log::Initialize();
        Common::Log::Start();
        return true;
    }();
    (void)initialized;
}

// The texture id returned to Dart is only useful once Flutter has actually sampled it at least
// once, which is when populate() observes Flutter's EGL context. Block the emulation thread on
// that instead of guessing at Flutter's scheduling.
bool WaitForFlutterGlContext(EGLDisplay& display, EGLContext& context) {
    FlutterGlContext& ctx = GetFlutterGlContext();
    std::unique_lock<std::mutex> lock(ctx.mutex);
    if (!ctx.cv.wait_for(lock, std::chrono::seconds(5), [&] { return ctx.ready; })) {
        LOG_CRITICAL(Frontend, "Timed out waiting for Flutter's GL context");
        return false;
    }
    display = ctx.display;
    context = ctx.context;
    return true;
}

void ShutdownWindows() {
    g_present_thread_stop = true;
    if (g_present_thread.joinable()) {
        g_present_thread.join();
    }

    if (g_window) {
        g_window->DoneCurrent();
    }
    if (g_secondary_window) {
        g_secondary_window->DoneCurrent();
    }
    Core::System::GetInstance().Shutdown();
    g_secondary_window.reset();
    g_window.reset();
    InputCommon::Shutdown();
    MicroProfileShutdown();
}

void RunEmulation(std::string path) {
    std::scoped_lock lock(g_running_mutex);

    EnsureUserPathInitialized();
    EnsureLoggingInitialized();
    MicroProfileOnThreadCreate("EmuThread");

    EGLDisplay flutter_display{};
    EGLContext flutter_context{};
    if (!WaitForFlutterGlContext(flutter_display, flutter_context)) {
        g_present_thread_stop = true;
        if (g_present_thread.joinable()) {
            g_present_thread.join();
        }
        return;
    }

    InputCommon::Init();
    Network::Init();

    Core::System& system = Core::System::GetInstance();

    g_window = std::make_unique<EmuWindow_Flutter>(
        system, g_primary_texture, g_texture_registrar,
        static_cast<int>(g_primary_texture->state->width.load()),
        static_cast<int>(g_primary_texture->state->height.load()), false, flutter_display,
        flutter_context);
    if (g_secondary_texture) {
        g_secondary_window = std::make_unique<EmuWindow_Flutter>(
            system, g_secondary_texture, g_texture_registrar,
            static_cast<int>(g_secondary_texture->state->width.load()),
            static_cast<int>(g_secondary_texture->state->height.load()), true, flutter_display,
            flutter_context);
    }

    system.ApplySettings();
    Settings::LogSettings();

    Frontend::RegisterDefaultApplets(system);

    g_window->MakeCurrent();
    if (g_secondary_window) {
        g_secondary_window->MakeCurrent();
        g_window->MakeCurrent();
    }

    const Core::System::ResultStatus load_result =
        system.Load(*g_window, path, g_secondary_window.get());
    if (load_result != Core::System::ResultStatus::Success) {
        LOG_CRITICAL(Frontend, "Failed to load {}: {}", path, static_cast<int>(load_result));
        ShutdownWindows();
        return;
    }

    g_stop_run = false;
    g_pause_emulation = false;
    g_present_frames = true;

    system.GPU().Renderer().Rasterizer()->LoadDiskResources(g_stop_run, &ReportShaderProgress);

    SCOPE_EXIT({ ShutdownWindows(); });

    while (!g_stop_run) {
        if (!g_pause_emulation) {
            const auto result = system.RunLoop();
            if (result == Core::System::ResultStatus::Success ||
                result == Core::System::ResultStatus::ShutdownRequested) {
                if (result == Core::System::ResultStatus::ShutdownRequested) {
                    break;
                }
                continue;
            }
            LOG_CRITICAL(Frontend, "RunLoop failed: {}", system.GetStatusDetails());
            break;
        }

        const float volume = Settings::values.volume.GetValue();
        SCOPE_EXIT({ Settings::values.volume = volume; });
        Settings::values.volume = 0;

        std::unique_lock<std::mutex> pause_lock(g_paused_mutex);
        g_running_cv.wait(pause_lock, [] { return !g_pause_emulation || g_stop_run; });
    }
}

// Linux has no Choreographer/vsync callback to piggyback on, so a dedicated thread paces
// presentation itself, mirroring the role of EmulationController's frame callback on Android.
void PresentLoop() {
    auto next_frame = std::chrono::steady_clock::now();
    while (!g_present_thread_stop) {
        if (g_present_frames) {
            if (g_window) {
                g_window->TryPresenting();
            }
            if (g_secondary_window) {
                g_secondary_window->TryPresenting();
            }
        }
        next_frame += std::chrono::milliseconds(16);
        std::this_thread::sleep_until(next_frame);
    }
}

}  // namespace

void SetShaderProgressChannel(FlEventChannel* channel) {
    g_shader_progress_channel = channel;
}

int64_t CreateTexture(FlTextureRegistrar* registrar, int width, int height, bool secondary) {
    AzaharTexture* texture = AZAHAR_TEXTURE(g_object_new(AZAHAR_TYPE_TEXTURE, nullptr));
    texture->state->width = static_cast<GLuint>(std::max(width, 1));
    texture->state->height = static_cast<GLuint>(std::max(height, 1));

    if (!fl_texture_registrar_register_texture(registrar, FL_TEXTURE(texture))) {
        g_object_unref(texture);
        return -1;
    }

    g_texture_registrar = registrar;
    if (secondary) {
        g_secondary_texture = texture;
    } else {
        g_primary_texture = texture;
    }
    return fl_texture_get_id(FL_TEXTURE(texture));
}

void StartEmulation(const std::string& path) {
    if (g_primary_texture == nullptr) {
        LOG_CRITICAL(Frontend, "StartEmulation called before CreateTexture");
        return;
    }

    if (!g_stop_run) {
        g_pause_emulation = false;
        g_running_cv.notify_all();
        g_present_frames = true;
        return;
    }

    g_present_thread_stop = false;
    g_emulation_thread = std::thread(RunEmulation, path);
    g_emulation_thread.detach();
    g_present_thread = std::thread(PresentLoop);
}

void PauseEmulation() {
    g_pause_emulation = true;
}

void ResumeEmulation() {
    g_pause_emulation = false;
    g_running_cv.notify_all();
}

void PauseRendering() {
    g_present_frames = false;
}

void ResumeRendering() {
    g_present_frames = true;
}

void StopEmulation() {
    g_stop_run = true;
    g_pause_emulation = false;
    g_present_frames = false;
    g_present_thread_stop = true;
    g_running_cv.notify_all();
}

bool OnTouchEvent(double x, double y, bool pressed) {
    EmuWindow_Flutter* window = GetTouchscreenWindow();
    if (!window) {
        return false;
    }
    return window->OnTouchEvent(static_cast<int>(x + 0.5), static_cast<int>(y + 0.5), pressed);
}

void OnTouchMoved(double x, double y) {
    EmuWindow_Flutter* window = GetTouchscreenWindow();
    if (window) {
        window->OnTouchMoved(static_cast<int>(x), static_cast<int>(y));
    }
}

bool SwapScreens() {
    const bool swapped = !Settings::values.swap_screen.GetValue();
    Settings::values.swap_screen = swapped;
    Core::System& system = Core::System::GetInstance();
    if (system.IsPoweredOn()) {
        system.GPU().Renderer().UpdateCurrentFramebufferLayout(false);
    }
    return swapped;
}

}  // namespace Emulation
