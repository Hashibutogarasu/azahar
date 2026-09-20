// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <algorithm>
#include <array>
#include <cstring>
#include <mutex>
#include <type_traits>
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

constexpr std::size_t MaxScanEntries = 32;
constexpr std::size_t MaxSsidLength = 0x20;
constexpr std::size_t DefaultAccessPointCount = 6;

/**
 * Access point entry of the AC::ScanAPs output buffer.
 * The layout was recovered from a previous local implementation and is not verified against
 * hardware, so the fields after the BSSID are provisional.
 */
struct ApInfo {
    u32_le ssid_length;
    std::array<char, MaxSsidLength> ssid;
    std::array<u8, 6> bssid;
    std::array<u8, 2> padding0;
    s16_le rssi;
    u8 link_level;
    u8 padding1;
    u32_le reserved;
};
static_assert(sizeof(ApInfo) == 0x34, "ApInfo has an incorrect size");
static_assert(std::is_trivially_copyable_v<ApInfo>);

std::mutex host_wifi_scanner_mutex;
HostWifiScanner host_wifi_scanner;

/**
 * Runs the registered host scanner.
 * @return The access points seen by the host, empty when no scanner is registered.
 */
std::vector<HostApInfo> ScanHostAccessPoints() {
    HostWifiScanner scanner;
    {
        std::scoped_lock lock{host_wifi_scanner_mutex};
        scanner = host_wifi_scanner;
    }
    if (!scanner) {
        return {};
    }
    return scanner();
}

/**
 * Builds the access points reported when the host cannot provide any.
 * The guest still receives a well formed list, so that games relying on nearby networks keep
 * working without wireless access.
 */
std::vector<HostApInfo> MakeDefaultAccessPoints() {
    std::vector<HostApInfo> access_points;
    access_points.reserve(DefaultAccessPointCount);
    for (std::size_t i = 0; i < DefaultAccessPointCount; ++i) {
        HostApInfo info;
        info.ssid = "AzaharAP" + std::to_string(i + 1);
        info.bssid = {0x02, 0x00, 0x00, 0x00, 0x00, static_cast<u8>(i + 1)};
        info.rssi = static_cast<s16>(-45 - 8 * static_cast<int>(i));
        info.link_level = static_cast<u8>(3 - i / 2);
        access_points.push_back(std::move(info));
    }
    return access_points;
}

/**
 * Converts a host access point to the guest representation.
 */
ApInfo ToApInfo(const HostApInfo& host) {
    ApInfo entry{};
    const std::size_t length = std::min(host.ssid.size(), MaxSsidLength);
    entry.ssid_length = static_cast<u32>(length);
    std::memcpy(entry.ssid.data(), host.ssid.data(), length);
    entry.bssid = host.bssid;
    entry.rssi = host.rssi;
    entry.link_level = host.link_level;
    return entry;
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

    const u32 out_size = rp.Pop<u32>();
    rp.Skip(2, false);

    std::vector<HostApInfo> access_points;
    if (Settings::values.scan_real_wifi_networks.GetValue()) {
        access_points = ScanHostAccessPoints();
    }
    const bool from_host = !access_points.empty();
    if (!from_host) {
        access_points = MakeDefaultAccessPoints();
    }

    const std::size_t count =
        std::min({out_size / sizeof(ApInfo), MaxScanEntries, access_points.size()});

    std::vector<u8> buffer(out_size);
    for (std::size_t i = 0; i < count; ++i) {
        const ApInfo entry = ToApInfo(access_points[i]);
        std::memcpy(buffer.data() + i * sizeof(ApInfo), &entry, sizeof(ApInfo));
        LOG_DEBUG(Service_AC, "entry {}: ssid=\"{}\" rssi={} link_level={}", i,
                  access_points[i].ssid, access_points[i].rssi, access_points[i].link_level);
    }

    IPC::RequestBuilder rb = rp.MakeBuilder(1, 2);
    rb.Push(ResultSuccess);
    rb.PushStaticBuffer(std::move(buffer), 0);

    LOG_INFO(Service_AC, "called, size=0x{:X}, host_scan={}, reported {} access point(s)", out_size,
             from_host, count);
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
