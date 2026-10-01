#!/bin/bash -ex

# The Linux plugin links the core libraries it finds in build/ when CMake
# configures the Flutter build, so they are built before the app.
mkdir -p build && cd build
cmake ../packages/core -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DENABLE_QT=OFF \
    -DENABLE_TESTS=OFF \
    -DENABLE_ROOM=OFF \
    -DCITRA_USE_PRECOMPILED_HEADERS=OFF
ninja citra_core citra_common network input_common web_service
cd ..

cd apps/flutter
flutter pub get
flutter build linux --release

ccache -s -v
