#!/bin/bash -ex

flatpak-builder --repo=repo --disable-rofiles-fuse --force-clean \
    --state-dir=.flatpak-builder build-dir \
    apps/qt-desktop/dist/flatpak/org.azahar_emu.Azahar.yml
flatpak build-bundle repo azahar.flatpak org.azahar_emu.Azahar
