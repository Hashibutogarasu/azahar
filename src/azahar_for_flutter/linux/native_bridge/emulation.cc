#include "emulation.h"

#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <condition_variable>
#include <deque>
#include <mutex>
#include <string>
#include <string_view>
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
#include "core/hle/service/service.h"
#include "input_common/main.h"
#include "network/network.h"
#include "user_directory.h"
#include "video_core/gpu.h"
#include "video_core/rasterizer_interface.h"
#include "video_core/renderer_base.h"

namespace Emulation {

namespace {

constexpr std::array<EGLint, 11> kConfigAttribs{
    EGL_SURFACE_TYPE, EGL_PBUFFER_BIT,     EGL_RENDERABLE_TYPE, EGL_OPENGL_ES3_BIT_KHR,
    EGL_RED_SIZE,     8,                   EGL_GREEN_SIZE,      8,
    EGL_BLUE_SIZE,    8,                   EGL_NONE,
};
constexpr std::array<EGLint, 5> kPbufferAttribs{EGL_WIDTH, 1, EGL_HEIGHT, 1, EGL_NONE};
constexpr std::array<EGLint, 3> kContextAttribs{EGL_CONTEXT_CLIENT_VERSION, 3, EGL_NONE};

// FlTextureGL::populate() only ever runs with Flutter's own EGL context current, and it is the
// only place that context is ever observable from here. The emulation thread waits on this to
// learn which context to create its share group against.
struct FlutterGlContext {
    std::mutex mutex;
    bool ready = false;
    EGLDisplay display = EGL_NO_DISPLAY;
    EGLContext context = EGL_NO_CONTEXT;
    bool has_pending_start = false;
    std::string pending_path;
};

struct PendingEmulationStart {
    std::string path;
    EGLDisplay display;
    EGLContext context;
};

gboolean StartEmulationOnMainThread(gpointer user_data);

FlutterGlContext& GetFlutterGlContext() {
    static FlutterGlContext instance;
    return instance;
}

std::recursive_mutex& GetGlOperationMutex() {
    static std::recursive_mutex mutex;
    return mutex;
}

std::mutex g_console_log_mutex;
bool g_console_log_enabled{true};
bool g_logging_initialized{false};

constexpr std::size_t kMaxPendingLogLines = 20000;
constexpr guint kLogDeliveryIntervalMs = 50;

std::mutex g_log_lines_mutex;
std::deque<std::string> g_pending_log_lines;
FlEventChannel* g_log_lines_channel{};
bool g_log_delivery_scheduled{false};

gboolean DeliverLogLines(gpointer user_data);

void ScheduleLogDeliveryLocked() {
    if (g_log_delivery_scheduled || g_log_lines_channel == nullptr ||
        g_pending_log_lines.empty()) {
        return;
    }
    g_log_delivery_scheduled = true;
    g_timeout_add(kLogDeliveryIntervalMs, DeliverLogLines, nullptr);
}

gboolean DeliverLogLines(gpointer user_data) {
    std::deque<std::string> lines;
    FlEventChannel* channel = nullptr;
    {
        std::lock_guard<std::mutex> lock(g_log_lines_mutex);
        g_log_delivery_scheduled = false;
        channel = g_log_lines_channel;
        if (channel == nullptr) {
            return G_SOURCE_REMOVE;
        }
        lines.swap(g_pending_log_lines);
    }
    if (lines.empty()) {
        return G_SOURCE_REMOVE;
    }
    g_autoptr(FlValue) list = fl_value_new_list();
    for (const std::string& line : lines) {
        g_autofree gchar* valid_line =
            g_utf8_make_valid(line.data(), static_cast<gssize>(line.size()));
        fl_value_append_take(list, fl_value_new_string(valid_line));
    }
    fl_event_channel_send(channel, list, nullptr, nullptr);
    return G_SOURCE_REMOVE;
}

void QueueLogLine(std::string_view line) {
    std::lock_guard<std::mutex> lock(g_log_lines_mutex);
    if (g_pending_log_lines.size() >= kMaxPendingLogLines) {
        g_pending_log_lines.pop_front();
    }
    g_pending_log_lines.emplace_back(line);
    ScheduleLogDeliveryLocked();
}

void EnsureLoggingInitialized() {
    static const bool initialized = [] {
        Settings::values.instant_debug_log = true;
        Common::Log::Initialize();
        Common::Log::SetSink(Common::Log::Sink{.write = QueueLogLine});
        {
            std::lock_guard<std::mutex> lock(g_console_log_mutex);
            Common::Log::SetColorConsoleBackendEnabled(g_console_log_enabled);
            g_logging_initialized = true;
        }
        Common::Log::Start();
        return true;
    }();
    (void)initialized;
}

const char* SafeGlString(GLenum name) {
    const GLubyte* value = glGetString(name);
    return value ? reinterpret_cast<const char*>(value) : "unknown";
}

bool EnsureGlFunctionsLoaded() {
    static const bool loaded = [] {
        const bool ok = gladLoadGLES2Loader((GLADloadproc)eglGetProcAddress);
        if (!ok) {
            LOG_CRITICAL(Frontend, "gladLoadGLES2Loader() failed");
        } else {
            LOG_INFO(Frontend, "GL_VENDOR: {}, GL_RENDERER: {}, GL_VERSION: {}",
                    SafeGlString(GL_VENDOR), SafeGlString(GL_RENDERER), SafeGlString(GL_VERSION));
        }
        return ok;
    }();
    return loaded;
}

void EnsureLleModulesInitialized() {
    static const bool initialized = [] {
        for (const auto& service_module : Service::service_module_map) {
            Settings::values.lle_modules.emplace(service_module.name, false);
        }
        return true;
    }();
    (void)initialized;
}

void EnsureInputProfileInitialized() {
    static const bool initialized = [] {
        if (Settings::values.current_input_profile.touch_device.empty()) {
            Settings::values.current_input_profile.touch_device = "engine:emu_window";
        }
        return true;
    }();
    (void)initialized;
}

}  // namespace

struct AzaharTextureState {
    std::atomic<GLuint> texture_id{0};
    std::atomic<GLuint> width{1};
    std::atomic<GLuint> height{1};
    GLuint placeholder_texture_id{0};
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
    try {
        EnsureLoggingInitialized();
        std::lock_guard<std::recursive_mutex> gl_lock(GetGlOperationMutex());
        AzaharTexture* self = AZAHAR_TEXTURE(texture);

        FlutterGlContext& ctx = GetFlutterGlContext();
        if (!ctx.ready) {
            PendingEmulationStart* to_start = nullptr;
            {
                std::lock_guard<std::mutex> lock(ctx.mutex);
                if (!ctx.ready) {
                    ctx.display = eglGetCurrentDisplay();
                    ctx.context = eglGetCurrentContext();
                    if (ctx.display != EGL_NO_DISPLAY && ctx.context != EGL_NO_CONTEXT) {
                        ctx.ready = true;
                        if (ctx.has_pending_start) {
                            to_start = new PendingEmulationStart{std::move(ctx.pending_path),
                                                                 ctx.display, ctx.context};
                            ctx.has_pending_start = false;
                        }
                    }
                }
            }
            if (to_start) {
                g_idle_add(StartEmulationOnMainThread, to_start);
            }
        }

        uint32_t real_name = self->state->texture_id.load();
        if (real_name == 0 && EnsureGlFunctionsLoaded()) {
            if (self->state->placeholder_texture_id == 0) {
                GLuint placeholder = 0;
                glGenTextures(1, &placeholder);
                glBindTexture(GL_TEXTURE_2D, placeholder);
                const std::array<uint8_t, 4> black_pixel{0, 0, 0, 255};
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                            black_pixel.data());
                glBindTexture(GL_TEXTURE_2D, 0);
                self->state->placeholder_texture_id = placeholder;
            }
            real_name = self->state->placeholder_texture_id;
        }

        *target = GL_TEXTURE_2D;
        *name = real_name;
        *width = self->state->width.load();
        *height = self->state->height.load();
        return *name != 0;
    } catch (...) {
        *target = GL_TEXTURE_2D;
        *name = 0;
        *width = 1;
        *height = 1;
        return FALSE;
    }
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
          context_{eglCreateContext(display, config, share_context, kContextAttribs.data())} {
        if (surface_ == EGL_NO_SURFACE) {
            LOG_CRITICAL(Frontend, "eglCreatePbufferSurface() failed: {:#x}", eglGetError());
        }
        if (context_ == EGL_NO_CONTEXT) {
            LOG_CRITICAL(Frontend, "eglCreateContext() failed: {:#x}", eglGetError());
        }
    }

    ~SharedContext_Flutter() override {
        std::lock_guard<std::recursive_mutex> gl_lock(GetGlOperationMutex());
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
        std::lock_guard<std::recursive_mutex> gl_lock(GetGlOperationMutex());

        const EGLenum previous_api = eglQueryAPI();
        const EGLDisplay previous_display = eglGetCurrentDisplay();
        const EGLContext previous_context = eglGetCurrentContext();
        const EGLSurface previous_draw_surface = eglGetCurrentSurface(EGL_DRAW);
        const EGLSurface previous_read_surface = eglGetCurrentSurface(EGL_READ);

        window_info.type = Frontend::WindowSystemType::Headless;
        window_width_ = width;
        window_height_ = height;

        if (!eglBindAPI(EGL_OPENGL_ES_API)) {
            LOG_CRITICAL(Frontend, "eglBindAPI() failed: {:#x}", eglGetError());
        }
        if (eglInitialize(display_, nullptr, nullptr) != EGL_TRUE) {
            LOG_CRITICAL(Frontend, "eglInitialize() failed: {:#x}", eglGetError());
        }
        EGLint num_configs{};
        if (eglChooseConfig(display_, kConfigAttribs.data(), &config_, 1, &num_configs) !=
                EGL_TRUE ||
            num_configs == 0) {
            LOG_CRITICAL(Frontend, "eglChooseConfig() failed: {:#x}", eglGetError());
        }
        if (surface_ = eglCreatePbufferSurface(display_, config_, kPbufferAttribs.data());
            surface_ == EGL_NO_SURFACE) {
            LOG_CRITICAL(Frontend, "eglCreatePbufferSurface() failed: {:#x}", eglGetError());
        }
        if (context_ = eglCreateContext(display_, config_, share_context, kContextAttribs.data());
            context_ == EGL_NO_CONTEXT) {
            LOG_CRITICAL(Frontend, "eglCreateContext() failed: {:#x}", eglGetError());
        }
        if (eglMakeCurrent(display_, surface_, surface_, context_) != EGL_TRUE) {
            LOG_CRITICAL(Frontend, "eglMakeCurrent() failed: {:#x}", eglGetError());
        }

        EnsureGlFunctionsLoaded();

        core_context_ = CreateSharedContext();

        const EGLBoolean restored =
            previous_context != EGL_NO_CONTEXT
                ? eglMakeCurrent(previous_display, previous_draw_surface, previous_read_surface,
                                 previous_context)
                : eglMakeCurrent(display_, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
        if (restored != EGL_TRUE) {
            LOG_CRITICAL(Frontend, "eglMakeCurrent(restore) failed: {:#x}", eglGetError());
        }
        if (previous_api != EGL_NONE) {
            eglBindAPI(previous_api);
        }

        OnFramebufferSizeChanged();
    }

    ~EmuWindow_Flutter() override {
        std::lock_guard<std::recursive_mutex> gl_lock(GetGlOperationMutex());
        if (eglMakeCurrent(display_, surface_, surface_, context_) == EGL_TRUE) {
            DestroyExportTexture();
            eglMakeCurrent(display_, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
        }
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
        std::lock_guard<std::recursive_mutex> gl_lock(GetGlOperationMutex());
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

    void ReleaseCurrent() {
        eglMakeCurrent(display_, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
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

        glBindFramebuffer(GL_READ_FRAMEBUFFER, export_fbo_);
        glBindFramebuffer(GL_DRAW_FRAMEBUFFER, flip_fbo_);
        glBlitFramebuffer(0, 0, window_width_, window_height_, 0, window_height_, window_width_, 0,
                          GL_COLOR_BUFFER_BIT, GL_LINEAR);
        glBindFramebuffer(GL_READ_FRAMEBUFFER, 0);
        glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);

        texture_->state->width = static_cast<GLuint>(window_width_);
        texture_->state->height = static_cast<GLuint>(window_height_);
        texture_->state->texture_id = flip_texture_;
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

        glGenTextures(1, &flip_texture_);
        glBindTexture(GL_TEXTURE_2D, flip_texture_);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, window_width_, window_height_, 0, GL_RGBA,
                    GL_UNSIGNED_BYTE, nullptr);

        glGenFramebuffers(1, &flip_fbo_);
        glBindFramebuffer(GL_FRAMEBUFFER, flip_fbo_);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, flip_texture_,
                               0);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        exported_width_ = window_width_;
        exported_height_ = window_height_;
    }

    void DestroyExportTexture() {
        if (flip_fbo_ != 0) {
            glDeleteFramebuffers(1, &flip_fbo_);
            flip_fbo_ = 0;
        }
        if (flip_texture_ != 0) {
            glDeleteTextures(1, &flip_texture_);
            flip_texture_ = 0;
        }
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
    GLuint flip_fbo_{};
    GLuint flip_texture_{};
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
std::atomic<bool> g_session_active{false};
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

bool ConsumeFlutterGlContextOrRegisterPendingStart(const std::string& path, EGLDisplay& display,
                                                   EGLContext& context) {
    FlutterGlContext& ctx = GetFlutterGlContext();
    std::lock_guard<std::mutex> lock(ctx.mutex);
    if (ctx.ready) {
        display = ctx.display;
        context = ctx.context;
        return true;
    }
    ctx.has_pending_start = true;
    ctx.pending_path = path;
    return false;
}

gboolean ReleaseTexturesOnMainThread(gpointer user_data) {
    AzaharTexture* textures[] = {g_primary_texture, g_secondary_texture};
    g_primary_texture = nullptr;
    g_secondary_texture = nullptr;
    for (AzaharTexture* texture : textures) {
        if (texture == nullptr) {
            continue;
        }
        if (g_texture_registrar != nullptr) {
            fl_texture_registrar_unregister_texture(g_texture_registrar, FL_TEXTURE(texture));
        }
        g_object_unref(texture);
    }
    g_texture_registrar = nullptr;
    return G_SOURCE_REMOVE;
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
    g_idle_add(ReleaseTexturesOnMainThread, nullptr);
    g_session_active = false;
}

void RunEmulation(std::string path) {
    std::scoped_lock lock(g_running_mutex);

    EnsureUserPathInitialized();
    EnsureLoggingInitialized();
    EnsureLleModulesInitialized();
    EnsureInputProfileInitialized();
    MicroProfileOnThreadCreate("EmuThread");

    Core::System& system = Core::System::GetInstance();

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
    ReportShaderProgress(VideoCore::LoadCallbackStage::Complete, 0, 0);

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
    if (g_window) {
        g_window->ReleaseCurrent();
    }
    if (g_secondary_window) {
        g_secondary_window->ReleaseCurrent();
    }
}

void CreateWindowsAndStartEmulation(const std::string& path, EGLDisplay display,
                                    EGLContext context) {
    Core::System& system = Core::System::GetInstance();
    g_window = std::make_unique<EmuWindow_Flutter>(
        system, g_primary_texture, g_texture_registrar,
        static_cast<int>(g_primary_texture->state->width.load()),
        static_cast<int>(g_primary_texture->state->height.load()), false, display, context);
    if (g_secondary_texture) {
        g_secondary_window = std::make_unique<EmuWindow_Flutter>(
            system, g_secondary_texture, g_texture_registrar,
            static_cast<int>(g_secondary_texture->state->width.load()),
            static_cast<int>(g_secondary_texture->state->height.load()), true, display, context);
    }

    g_present_thread_stop = false;
    g_session_active = true;
    g_emulation_thread = std::thread(RunEmulation, path);
    g_present_thread = std::thread(PresentLoop);
}

gboolean StartEmulationOnMainThread(gpointer user_data) {
    std::unique_ptr<PendingEmulationStart> pending(static_cast<PendingEmulationStart*>(user_data));
    CreateWindowsAndStartEmulation(pending->path, pending->display, pending->context);
    return G_SOURCE_REMOVE;
}

}  // namespace

void SetShaderProgressChannel(FlEventChannel* channel) {
    g_shader_progress_channel = channel;
}

void SetLogLinesChannel(FlEventChannel* channel) {
    std::lock_guard<std::mutex> lock(g_log_lines_mutex);
    g_log_lines_channel = channel;
    ScheduleLogDeliveryLocked();
}

void SetConsoleLogEnabled(bool enabled) {
    std::lock_guard<std::mutex> lock(g_console_log_mutex);
    g_console_log_enabled = enabled;
    if (g_logging_initialized) {
        Common::Log::SetColorConsoleBackendEnabled(enabled);
    }
}

int64_t CreateTexture(FlTextureRegistrar* registrar, int width, int height, bool secondary) {
    EnsureLoggingInitialized();
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

bool IsRunning() {
    return !g_stop_run;
}

bool IsSessionActive() {
    return g_session_active;
}

void StartEmulation(const std::string& path) {
    EnsureLoggingInitialized();
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

    static bool input_and_network_initialized = false;
    if (!input_and_network_initialized) {
        InputCommon::Init();
        Network::Init();
        input_and_network_initialized = true;
    }

    EGLDisplay flutter_display{};
    EGLContext flutter_context{};
    if (ConsumeFlutterGlContextOrRegisterPendingStart(path, flutter_display, flutter_context)) {
        CreateWindowsAndStartEmulation(path, flutter_display, flutter_context);
    }
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

void StopPresentingAndWait() {
    g_present_frames = false;
    g_present_thread_stop = true;
    if (g_present_thread.joinable()) {
        g_present_thread.join();
    }
}

void StopAndWait() {
    StopEmulation();
    if (g_emulation_thread.joinable()) {
        g_emulation_thread.join();
    }
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
