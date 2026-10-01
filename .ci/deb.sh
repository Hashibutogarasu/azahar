#!/bin/bash -ex

PACKAGE_VERSION="${GITHUB_REF_TYPE:+$GITHUB_REF_NAME}"
PACKAGE_VERSION="${PACKAGE_VERSION:-0.0.0-$(git rev-parse --short HEAD)}"

mkdir build && cd build
cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DENABLE_QT_TRANSLATION=ON \
    -DENABLE_CPACK_DEB=ON \
    -DCPACK_PACKAGE_VERSION="${PACKAGE_VERSION}"
ninja
strip -s bin/Release/*
ccache -s -v

ctest -VV -C Release

cpack
