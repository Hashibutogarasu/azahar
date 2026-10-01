#!/bin/bash -ex

export NDK_CCACHE=$(which ccache)

cd apps/flutter
flutter pub get
dart run build_runner build -d
flutter build apk --release

ccache -s -v
