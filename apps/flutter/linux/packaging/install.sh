#!/bin/sh -e

# Installs the Flutter Linux bundle with a launcher, a desktop entry and an icon.
# Usage: install.sh <bundle> <root> <prefix>
# The files are written under <root><prefix>, and the launcher points at <prefix>, which is where
# the package installs them.

umask 022

bundle=$1
root=$2
prefix=$3
app_id=io.github.lime3ds.azahar

lib_dir="$root$prefix/lib/azahar"
mkdir -p "$lib_dir" "$root$prefix/bin" "$root$prefix/share/applications"
cp -r "$bundle/." "$lib_dir/"
rm -f "$lib_dir/azahar.desktop.in"
chmod 755 "$lib_dir/azahar"
ln -sf "$prefix/lib/azahar/azahar" "$root$prefix/bin/azahar"

sed -e "s|@AZAHAR_EXEC@|azahar|g" -e "s|@AZAHAR_ICON@|$app_id|g" \
    "$bundle/azahar.desktop.in" > "$root$prefix/share/applications/$app_id.desktop"
install -Dm644 "$bundle/data/flutter_assets/assets/icons/linux.png" \
    "$root$prefix/share/icons/hicolor/512x512/apps/$app_id.png"
