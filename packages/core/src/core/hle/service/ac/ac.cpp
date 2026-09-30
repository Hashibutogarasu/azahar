// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <algorithm>
#include <array>
#include <chrono>
#include <cstring>
#include <mutex>
#include <optional>
#include <vector>
#include "common/archives.h"
#include "common/common_types.h"
#include "common/logging/log.h"
#include "common/settings.h"
#include "common/swap.h"
#include "core/core.h"
#include "core/hle/ipc.h"
#include "core/hle/ipc_helpers.h"
#include "core/hle/kernel/event.h"
#include "core/hle/kernel/handle_table.h"
#include "core/hle/kernel/resource_limit.h"
#include "core/hle/kernel/shared_page.h"
#include "core/hle/result.h"
#include "core/hle/service/ac/ac.h"
#include "core/hle/service/ac/ac_i.h"
#include "core/hle/service/ac/ac_u.h"
#include "core/hle/service/soc/soc_u.h"
#include "core/memory.h"

SERIALIZE_EXPORT_IMPL(Service::AC::Module)
SERVICE_CONSTRUCT_IMPL(Service::AC::Module)

namespace Service::AC {

namespace {

constexpr std::chrono::nanoseconds ScanDuration{3'210'000'000};

std::mutex host_wifi_scanner_mutex;
HostWifiScanner host_wifi_scanner;

/**
 * Runs the registered host scanner.
 * @return The access points seen by the host, nothing when no scanner is registered or when the
 * host cannot scan.
 */
std::optional<std::vector<HostApInfo>> ScanHostAccessPoints() {
    HostWifiScanner scanner;
    {
        std::scoped_lock lock{host_wifi_scanner_mutex};
        scanner = host_wifi_scanner;
    }
    if (!scanner) {
        return std::nullopt;
    }
    return scanner();
}

/**
 * Builds the access points reported when the host cannot scan.
 * The guest still receives a well formed list, so that games relying on nearby networks keep
 * working without wireless access.
 */
std::vector<HostApInfo> MakeDefaultAccessPoints() {
    struct DefaultAccessPoint {
        u8 channel;
        s16 rssi;
    };
    static constexpr std::array<DefaultAccessPoint, 4> default_access_points{{
        {1, -60},
        {6, -68},
        {11, -77},
        {1, -85},
    }};

    std::vector<HostApInfo> access_points;
    for (std::size_t i = 0; i < default_access_points.size(); ++i) {
        HostApInfo info;
        info.ssid = "AzaharAP" + std::to_string(i + 1);
        info.bssid = {0x00, 0x1A, 0x2B, 0x3C, 0x4D, static_cast<u8>(i + 1)};
        info.rssi = default_access_points[i].rssi;
        info.channel = default_access_points[i].channel;
        info.security = ApSecurity::Secured;
        access_points.push_back(std::move(info));
    }
    return access_points;
}

} // namespace

void RegisterHostWifiScanner(HostWifiScanner scanner) {
    std::scoped_lock lock{host_wifi_scanner_mutex};
    host_wifi_scanner = std::move(scanner);
}

void Module::Interface::CreateDefaultConfig(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);

    std::vector<u8> buffer(sizeof(ACConfig));
    std::memcpy(buffer.data(), &ac->default_config, buffer.size());

    IPC::RequestBuilder rb = rp.MakeBuilder(1, 2);
    rb.Push(ResultSuccess);
    rb.PushStaticBuffer(std::move(buffer), 0);

    LOG_WARNING(Service_AC, "(STUBBED) called");
}

void Module::Interface::ConnectAsync(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);

    rp.Skip(2, false); // ProcessId descriptor
    ac->connect_event = rp.PopObject<Kernel::Event>();
    rp.Skip(2, false); // Buffer descriptor

    if (ac->connect_event) {
        ac->connect_event->SetName("AC:connect_event");
        ac->connect_event->Signal();
        ac->ac_connected = true;
    }

    IPC::RequestBuilder rb = rp.MakeBuilder(1, 0);
    rb.Push(ResultSuccess);

    LOG_WARNING(Service_AC, "(STUBBED) called");
}

void Module::Interface::GetConnectResult(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);
    rp.Skip(2, false); // ProcessId descriptor

    IPC::RequestBuilder rb = rp.MakeBuilder(1, 0);
    rb.Push(ResultSuccess);
}

void Module::Interface::CloseAsync(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);
    rp.Skip(2, false); // ProcessId descriptor

    ac->close_event = rp.PopObject<Kernel::Event>();

    if (ac->ac_connected && ac->disconnect_event) {
        ac->disconnect_event->Signal();
    }

    if (ac->close_event) {
        ac->close_event->SetName("AC:close_event");
        ac->close_event->Signal();
    }

    ac->ac_connected = false;

    IPC::RequestBuilder rb = rp.MakeBuilder(1, 0);
    rb.Push(ResultSuccess);
}

void Module::Interface::GetCloseResult(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);
    rp.Skip(2, false); // ProcessId descriptor

    IPC::RequestBuilder rb = rp.MakeBuilder(1, 0);
    rb.Push(ResultSuccess);

    LOG_WARNING(Service_AC, "(STUBBED) called");
}

void Module::Interface::GetStatus(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);

    IPC::RequestBuilder rb = rp.MakeBuilder(2, 0);
    rb.Push(ResultSuccess);
    rb.Push<u32>(static_cast<u32>(Status::STATUS_INTERNET));
}

void Module::Interface::GetWifiStatus(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);

    IPC::RequestBuilder rb = rp.MakeBuilder(2, 0);
    rb.Push(ResultSuccess);
    rb.Push<u32>(static_cast<u32>(WifiStatus::STATUS_CONNECTED_SLOT1));
}

void Module::Interface::GetInfraPriority(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);
    [[maybe_unused]] const std::vector<u8>& ac_config = rp.PopStaticBuffer();

    IPC::RequestBuilder rb = rp.MakeBuilder(2, 0);
    rb.Push(ResultSuccess);
    rb.Push<u32>(0); // Infra Priority, default 0

    LOG_WARNING(Service_AC, "(STUBBED) called");
}

void Module::Interface::SetRequestEulaVersion(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);

    u32 major = rp.Pop<u8>();
    u32 minor = rp.Pop<u8>();

    const std::vector<u8>& ac_config = rp.PopStaticBuffer();

    // TODO(Subv): Copy over the input ACConfig to the stored ACConfig.

    IPC::RequestBuilder rb = rp.MakeBuilder(1, 2);
    rb.Push(ResultSuccess);
    rb.PushStaticBuffer(std::move(ac_config), 0);

    LOG_WARNING(Service_AC, "(STUBBED) called, major={}, minor={}", major, minor);
}

void Module::Interface::RegisterDisconnectEvent(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);
    rp.Skip(2, false); // ProcessId descriptor

    ac->disconnect_event = rp.PopObject<Kernel::Event>();
    if (ac->disconnect_event) {
        ac->disconnect_event->SetName("AC:disconnect_event");
    }

    IPC::RequestBuilder rb = rp.MakeBuilder(1, 0);
    rb.Push(ResultSuccess);

    LOG_WARNING(Service_AC, "(STUBBED) called");
}

void Module::Interface::GetConnectingProxyEnable(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);
    constexpr bool proxy_enabled = false;

    IPC::RequestBuilder rb = rp.MakeBuilder(2, 0);
    rb.Push(ResultSuccess);
    rb.Push(proxy_enabled);

    LOG_WARNING(Service_AC, "(STUBBED) called");
}

void Module::Interface::IsConnected(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);
    u32 unk = rp.Pop<u32>();
    u32 unk_descriptor = rp.Pop<u32>();
    u32 unk_param = rp.Pop<u32>();

    IPC::RequestBuilder rb = rp.MakeBuilder(2, 0);
    rb.Push(ResultSuccess);
    rb.Push(ac->ac_connected);

    LOG_DEBUG(Service_AC, "(STUBBED) called unk=0x{:08X} descriptor=0x{:08X} param=0x{:08X}", unk,
              unk_descriptor, unk_param);
}

void Module::Interface::SetClientVersion(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);

    u32 version = rp.Pop<u32>();
    rp.Skip(2, false); // ProcessId descriptor

    LOG_WARNING(Service_AC, "(STUBBED) called, version: 0x{:08X}", version);

    IPC::RequestBuilder rb = rp.MakeBuilder(1, 0);
    rb.Push(ResultSuccess);
}

void Module::Interface::ScanAPs(Kernel::HLERequestContext& ctx) {
    IPC::RequestParser rp(ctx);

    const u32 out_size = rp.Pop<u32>() & 0xFFFF;
    rp.Skip(2, false);
    const u16 command_id = static_cast<u16>(ctx.CommandHeader().command_id.Value());

    struct ScanState {
        std::vector<ApInfo> list;
        bool from_host = false;
    };
    const auto scan = std::make_shared<ScanState>();

    ctx.RunAsync(
        [scan, out_size](Kernel::HLERequestContext&) {
            std::optional<std::vector<HostApInfo>> found;
            if (Settings::values.scan_real_wifi_networks.GetValue()) {
                found = ScanHostAccessPoints();
            }
            scan->from_host = found.has_value();
            scan->list = BuildApList(found ? std::move(*found) : MakeDefaultAccessPoints(),
                                     out_size / sizeof(ApInfo));
            return static_cast<s64>(ScanDuration.count());
        },
        [scan, out_size, command_id](Kernel::HLERequestContext& ctx) {
            std::vector<u8> buffer(out_size);
            std::memcpy(buffer.data(), scan->list.data(), scan->list.size() * sizeof(ApInfo));

            IPC::RequestBuilder rb(ctx, command_id, 2, 2);
            rb.Push(ResultSuccess);
            rb.Push<u32>(static_cast<u32>(scan->list.size()));
            rb.PushStaticBuffer(std::move(buffer), 0);

            LOG_INFO(Service_AC, "size=0x{:X}, host_scan={}, reported {} access point(s)", out_size,
                     scan->from_host, scan->list.size());
            for (std::size_t i = 0; i < scan->list.size(); ++i) {
                const ApInfo& entry = scan->list[i];
                LOG_DEBUG(Service_AC, "entry {}: ssid_length={} strength={} level={} channel={}", i,
                          static_cast<u32>(entry.ssid_length),
                          static_cast<u16>(entry.signal_strength), entry.link_level,
                          entry.channel);
            }
        });
}

Module::Interface::Interface(std::shared_ptr<Module> ac, const char* name, u32 max_session)
    : ServiceFramework(name, max_session), ac(std::move(ac)) {}

void InstallInterfaces(Core::System& system) {
    auto& service_manager = system.ServiceManager();
    auto ac = std::make_shared<Module>(system);
    std::make_shared<AC_I>(ac)->InstallAsService(service_manager);
    std::make_shared<AC_U>(ac)->InstallAsService(service_manager);
}

Module::Module(Core::System& system_) : system(system_) {}

template <class Archive>
void Module::serialize(Archive& ar, const unsigned int) {
    DEBUG_SERIALIZATION_POINT;
    ar & ac_connected;
    ar & close_event;
    ar & connect_event;
    ar & disconnect_event;
    // default_config is never written to
}
SERIALIZE_IMPL(Module)

} // namespace Service::AC
