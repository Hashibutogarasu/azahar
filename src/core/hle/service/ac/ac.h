// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#pragma once

#include <array>
#include <functional>
#include <memory>
#include <string>
#include <vector>
#include "common/common_types.h"
#include "core/hle/service/service.h"

namespace Core {
class System;
}

namespace Kernel {
class Event;
}

namespace Service::AC {

/**
 * Description of a wireless access point found by the host.
 * The SSID holds raw bytes and only the first 32 of them are reported to the guest.
 * The BSSID is the hardware address of the access point, the RSSI is the received signal strength
 * in dBm and the link level ranges from 0 (none) to 3 (best).
 */
struct HostApInfo {
    std::string ssid;
    std::array<u8, 6> bssid{};
    s16 rssi = -100;
    u8 link_level = 0;
};

/**
 * Callback that scans the wireless networks around the host.
 * It is invoked on the emulation thread and may return an empty list when scanning is unavailable.
 */
using HostWifiScanner = std::function<std::vector<HostApInfo>()>;

/**
 * Registers the scanner used to answer AC::ScanAPs with the access points seen by the host.
 * Passing an empty callback unregisters it.
 */
void RegisterHostWifiScanner(HostWifiScanner scanner);

class Module final {
public:
    explicit Module(Core::System& system_);
    ~Module() = default;

    class Interface : public ServiceFramework<Interface> {
    public:
        Interface(std::shared_ptr<Module> ac, const char* name, u32 max_session);

        /**
         * AC::CreateDefaultConfig service function
         *  Inputs:
         *      64 : ACConfig size << 14 | 2
         *      65 : pointer to ACConfig struct
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         */
        void CreateDefaultConfig(Kernel::HLERequestContext& ctx);

        /**
         * AC::ConnectAsync service function
         *  Inputs:
         *      1 : ProcessId Header
         *      3 : Copy Handle Header
         *      4 : Connection Event handle
         *      5 : ACConfig size << 14 | 2
         *      6 : pointer to ACConfig struct
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         */
        void ConnectAsync(Kernel::HLERequestContext& ctx);

        /**
         * AC::GetConnectResult service function
         *  Inputs:
         *      1 : ProcessId Header
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         */
        void GetConnectResult(Kernel::HLERequestContext& ctx);

        /**
         * AC::CloseAsync service function
         *  Inputs:
         *      1 : ProcessId Header
         *      3 : Copy Handle Header
         *      4 : Event handle, should be signaled when AC connection is closed
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         */
        void CloseAsync(Kernel::HLERequestContext& ctx);

        /**
         * AC::GetCloseResult service function
         *  Inputs:
         *      1 : ProcessId Header
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         */
        void GetCloseResult(Kernel::HLERequestContext& ctx);

        /**
         * AC::GetWifiStatus service function
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         *      2 : Status
         */
        void GetStatus(Kernel::HLERequestContext& ctx);

        /**
         * AC::GetWifiStatus service function
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         *      2 : WifiStatus
         */
        void GetWifiStatus(Kernel::HLERequestContext& ctx);

        /**
         * AC::GetInfraPriority service function
         *  Inputs:
         *      1 : ACConfig size << 14 | 2
         *      2 : pointer to ACConfig struct
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         *      2 : Infra Priority
         */
        void GetInfraPriority(Kernel::HLERequestContext& ctx);

        /**
         * AC::SetRequestEulaVersion service function
         *  Inputs:
         *      1 : Eula Version major
         *      2 : Eula Version minor
         *      3 : ACConfig size << 14 | 2
         *      4 : Input pointer to ACConfig struct
         *      64 : ACConfig size << 14 | 2
         *      65 : Output pointer to ACConfig struct
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         *      2 : Infra Priority
         */
        void SetRequestEulaVersion(Kernel::HLERequestContext& ctx);

        /**
         * AC::RegisterDisconnectEvent service function
         *  Inputs:
         *      1 : ProcessId Header
         *      3 : Copy Handle Header
         *      4 : Event handle, should be signaled when AC connection is closed
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         */
        void RegisterDisconnectEvent(Kernel::HLERequestContext& ctx);

        /**
         * AC::GetConnectingProxyEnable service function
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         *      2 : bool, is proxy enabled
         */
        void GetConnectingProxyEnable(Kernel::HLERequestContext& ctx);

        /**
         * AC::IsConnected service function
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         *      2 : bool, is connected
         */
        void IsConnected(Kernel::HLERequestContext& ctx);

        /**
         * AC::SetClientVersion service function
         *  Inputs:
         *      1 : Used SDK Version
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         */
        void SetClientVersion(Kernel::HLERequestContext& ctx);

        /**
         * AC::ScanAPs service function
         *  Inputs:
         *      1 : Output buffer size in bytes, each access point takes 0x34 bytes
         *      2 : ProcessId Header
         *      3 : ProcessId
         *  Outputs:
         *      1 : Result of function, 0 on success, otherwise error code
         *      2 : Output buffer size << 14 | 2
         *      3 : Pointer to the access point list
         */
        void ScanAPs(Kernel::HLERequestContext& ctx);

    protected:
        std::shared_ptr<Module> ac;
    };

protected:
    enum class Status {
        STATUS_DISCONNECTED = 0,
        STATUS_ENABLED = 1,
        STATUS_CONNECTED = 2,
        STATUS_INTERNET = 3,
    };
    enum class WifiStatus {
        STATUS_DISCONNECTED = 0,
        STATUS_CONNECTED_SLOT1 = (1 << 0),
        STATUS_CONNECTED_SLOT2 = (1 << 1),
        STATUS_CONNECTED_SLOT3 = (1 << 2),
    };

    struct ACConfig {
        std::array<u8, 0x200> data;
    };

    ACConfig default_config{};

    bool ac_connected = false;

    std::shared_ptr<Kernel::Event> close_event;
    std::shared_ptr<Kernel::Event> connect_event;
    std::shared_ptr<Kernel::Event> disconnect_event;

private:
    [[maybe_unused]]
    Core::System& system;

    template <class Archive>
    void serialize(Archive& ar, const unsigned int);
    friend class boost::serialization::access;
};

void InstallInterfaces(Core::System& system);

} // namespace Service::AC

BOOST_CLASS_EXPORT_KEY(Service::AC::Module)
SERVICE_CONSTRUCT(Service::AC::Module)
