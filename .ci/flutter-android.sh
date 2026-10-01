#!/bin/bash -ex

export NDK_CCACHE=$(which ccache)

cd apps/flutter
flutter pub get
flutter build apk --release

ccache -s -v
