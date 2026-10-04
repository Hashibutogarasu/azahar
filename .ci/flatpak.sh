#!/bin/bash -ex

# Packages the Flutter Linux bundle in apps/flutter/build/linux/x64/release/bundle.
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak-builder --repo=repo --disable-rofiles-fuse --force-clean \
    --install-deps-from=flathub --state-dir=.flatpak-builder build-dir \
    apps/flutter/linux/packaging/io.github.lime3ds.azahar.yml
flatpak build-bundle repo azahar.flatpak io.github.lime3ds.azahar
