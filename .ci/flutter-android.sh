#!/bin/bash -ex

export NDK_CCACHE=$(which ccache)

cd src/flutter
flutter pub get
flutter build apk --release

ccache -s -v
