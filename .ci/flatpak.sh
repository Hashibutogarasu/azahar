#!/bin/bash -ex

if [ -d .flatpak-builder ]; then
    chown -R "$(id -u):$(id -g)" .flatpak-builder
fi

flatpak-builder --repo=repo --disable-rofiles-fuse --force-clean --ccache \
    --state-dir=.flatpak-builder build-dir \
    apps/qt-desktop/dist/flatpak/org.azahar_emu.Azahar.yml
flatpak build-bundle repo azahar.flatpak org.azahar_emu.Azahar
