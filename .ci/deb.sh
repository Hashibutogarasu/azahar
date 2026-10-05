#!/bin/bash -ex

# Packages the Flutter Linux bundle in apps/flutter/build/linux/x64/release/bundle. The package
# version is the tag being built, or 0.0.0 with the commit for a branch or a pull request, whose
# ref names such as "76/merge" are not valid Debian versions.
PACKAGE_VERSION=""
if [ "${GITHUB_REF_TYPE:-}" = "tag" ]; then
    PACKAGE_VERSION="${GITHUB_REF_NAME#v}"
fi
PACKAGE_VERSION="${PACKAGE_VERSION:-0.0.0-$(git rev-parse --short HEAD)}"

root=build/deb
rm -rf "$root"
sh apps/flutter/linux/packaging/install.sh \
    apps/flutter/build/linux/x64/release/bundle "$root" /usr

mkdir -p "$root/DEBIAN"
cat > "$root/DEBIAN/control" <<EOF
Package: azahar
Version: ${PACKAGE_VERSION}
Architecture: amd64
Maintainer: Azahar contributors
Depends: libgtk-3-0t64 | libgtk-3-0, libevdev2, libasound2t64 | libasound2, libstdc++6
Section: games
Priority: optional
Homepage: https://github.com/Hashibutogarasu/azahar
Description: Nintendo 3DS video game console emulator
EOF

dpkg-deb --build --root-owner-group "$root" "build/azahar_${PACKAGE_VERSION}_amd64.deb"
