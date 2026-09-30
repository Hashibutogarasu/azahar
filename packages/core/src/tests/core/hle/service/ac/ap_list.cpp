// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

#include <algorithm>
#include <string>
#include <vector>
#include <catch2/catch_test_macros.hpp>
#include "core/hle/service/ac/ap_list.h"

namespace Service::AC {

namespace {

struct ExpectedEntry {
    u16 strength;
    u8 level;
    u8 channel;
    std::array<u8, 4> security;
    bool hidden;
};

constexpr ApSecurity SecurityOf(const std::array<u8, 4>& bytes) {
    if (bytes[0] == 0) {
        return ApSecurity::Open;
    }
    return bytes[1] == 4 ? ApSecurity::SecuredMixed : ApSecurity::Secured;
}

HostApInfo MakeAp(u8 index, s16 rssi, u8 channel, ApSecurity security, bool hidden) {
    HostApInfo ap;
    if (!hidden) {
        ap.ssid = "test-ap-" + std::to_string(index);
    }
    ap.bssid = {0x00, 0x00, 0x5E, 0x00, 0x53, index};
    ap.rssi = rssi;
    ap.channel = channel;
    ap.security = security;
    return ap;
}

const std::vector<ExpectedEntry> ObservedScan = {
    {52, 3, 4, {5, 5, 0, 0}, false}, {31, 3, 4, {5, 5, 0, 0}, true},
    {31, 3, 4, {5, 5, 0, 0}, false}, {27, 3, 4, {0, 0, 0, 0}, true},
    {22, 3, 11, {5, 4, 0, 0}, false}, {15, 1, 11, {5, 5, 0, 0}, false},
    {9, 0, 11, {5, 5, 0, 0}, true},   {8, 0, 11, {5, 5, 0, 0}, true},
    {5, 0, 11, {5, 5, 0, 0}, false},  {4, 0, 11, {5, 5, 0, 0}, false},
    {1, 0, 1, {5, 5, 0, 0}, false},   {1, 0, 1, {5, 5, 0, 0}, false},
};

std::vector<HostApInfo> HostListOf(const std::vector<ExpectedEntry>& expected) {
    std::vector<HostApInfo> host;
    for (std::size_t i = 0; i < expected.size(); ++i) {
        host.push_back(MakeAp(static_cast<u8>(i + 1), static_cast<s16>(expected[i].strength - 100),
                              expected[i].channel, SecurityOf(expected[i].security),
                              expected[i].hidden));
    }
    return host;
}

} // namespace

TEST_CASE("AC ScanAPs entries have the layout of the hardware", "[core][service]") {
    ApInfo entry{};
    const auto* base = reinterpret_cast<const u8*>(&entry);
    REQUIRE(sizeof(ApInfo) == 0x34);
    REQUIRE(reinterpret_cast<const u8*>(&entry.ssid) - base == 0x04);
    REQUIRE(reinterpret_cast<const u8*>(&entry.bssid) - base == 0x24);
    REQUIRE(reinterpret_cast<const u8*>(&entry.signal_strength) - base == 0x2C);
    REQUIRE(reinterpret_cast<const u8*>(&entry.link_level) - base == 0x2E);
    REQUIRE(reinterpret_cast<const u8*>(&entry.channel) - base == 0x2F);
    REQUIRE(reinterpret_cast<const u8*>(&entry.security) - base == 0x30);
}

TEST_CASE("AC ScanAPs list matches a scan reported by the hardware", "[core][service]") {
    const std::vector<HostApInfo> host = HostListOf(ObservedScan);
    const std::vector<ApInfo> list = BuildApList(host, MaxApEntries);

    REQUIRE(list.size() == ObservedScan.size());
    for (std::size_t i = 0; i < list.size(); ++i) {
        INFO("entry " << i);
        CHECK(list[i].signal_strength == ObservedScan[i].strength);
        CHECK(list[i].link_level == ObservedScan[i].level);
        CHECK(list[i].channel == ObservedScan[i].channel);
        CHECK(list[i].security == ObservedScan[i].security);
        CHECK(list[i].ssid_length == host[i].ssid.size());
        CHECK(list[i].bssid == host[i].bssid);
    }
}

TEST_CASE("AC ScanAPs list is ordered by strength whatever the order of the scan", "[core][service]") {
    std::vector<HostApInfo> host = HostListOf(ObservedScan);
    std::reverse(host.begin(), host.end());
    const std::vector<ApInfo> list = BuildApList(host, MaxApEntries);

    REQUIRE(list.size() == ObservedScan.size());
    for (std::size_t i = 0; i < list.size(); ++i) {
        CHECK(list[i].signal_strength == ObservedScan[i].strength);
    }
}

TEST_CASE("AC ScanAPs list keeps hidden networks", "[core][service]") {
    const std::vector<ApInfo> list = BuildApList(HostListOf(ObservedScan), MaxApEntries);

    REQUIRE(list.size() == ObservedScan.size());
    CHECK(list[1].ssid_length == 0);
    CHECK(std::all_of(list[1].ssid.begin(), list[1].ssid.end(), [](char c) { return c == 0; }));
}

TEST_CASE("AC ScanAPs list drops the networks outside the 2.4 GHz band", "[core][service]") {
    std::vector<HostApInfo> host;
    host.push_back(MakeAp(1, -50, 0, ApSecurity::Secured, false));
    host.push_back(MakeAp(2, -50, 14, ApSecurity::Secured, false));
    host.push_back(MakeAp(3, -50, 1, ApSecurity::Secured, false));
    host.push_back(MakeAp(4, -50, 13, ApSecurity::Secured, false));

    const std::vector<ApInfo> list = BuildApList(host, MaxApEntries);

    REQUIRE(list.size() == 2);
    CHECK(list[0].channel == 1);
    CHECK(list[1].channel == 13);
}

TEST_CASE("AC ScanAPs list drops duplicated BSSIDs and keeps the strongest", "[core][service]") {
    std::vector<HostApInfo> host;
    host.push_back(MakeAp(1, -80, 6, ApSecurity::Secured, false));
    host.push_back(MakeAp(1, -60, 6, ApSecurity::Secured, false));

    const std::vector<ApInfo> list = BuildApList(host, MaxApEntries);

    REQUIRE(list.size() == 1);
    CHECK(list[0].signal_strength == 40);
}

TEST_CASE("AC ScanAPs list is limited by the buffer and by the maximum", "[core][service]") {
    std::vector<HostApInfo> host;
    for (u8 i = 0; i < 40; ++i) {
        host.push_back(MakeAp(i, static_cast<s16>(-90 + i), 6, ApSecurity::Secured, false));
    }

    CHECK(BuildApList(host, 100).size() == MaxApEntries);
    CHECK(BuildApList(host, 5).size() == 5);
    CHECK(BuildApList(host, 0).empty());
    CHECK(BuildApList(host, 5).front().signal_strength == 49);
}

TEST_CASE("AC ScanAPs signal strength and level", "[core][service]") {
    CHECK(StrengthFromRssi(-39) == 61);
    CHECK(StrengthFromRssi(-100) == 0);
    CHECK(StrengthFromRssi(-127) == 0);
    CHECK(StrengthFromRssi(0) == 100);
    CHECK(StrengthFromRssi(20) == 100);

    CHECK(LevelFromStrength(100) == 3);
    CHECK(LevelFromStrength(20) == 3);
    CHECK(LevelFromStrength(19) == 2);
    CHECK(LevelFromStrength(16) == 2);
    CHECK(LevelFromStrength(15) == 1);
    CHECK(LevelFromStrength(10) == 1);
    CHECK(LevelFromStrength(9) == 0);
    CHECK(LevelFromStrength(0) == 0);
}

TEST_CASE("AC ScanAPs truncates long SSIDs", "[core][service]") {
    HostApInfo ap = MakeAp(1, -50, 6, ApSecurity::Secured, false);
    ap.ssid = std::string(40, 'x');

    const ApInfo entry = ToApInfo(ap);

    CHECK(entry.ssid_length == MaxSsidLength);
    CHECK(std::all_of(entry.ssid.begin(), entry.ssid.end(), [](char c) { return c == 'x'; }));
}

} // namespace Service::AC
