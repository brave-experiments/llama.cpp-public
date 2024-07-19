#!/bin/bash
# Note:   This script is used to build the llama.cpp library for Android CPU targets.
# Author: Stefanos Laskaridis (stefanos@brave.com)


export LLAMA_CPP_HOME=${LLAMA_CPP_HOME:-"$PWD/../"}
export ANDROID_NDK=${ANDROID_NDK:-"$HOME/Library/Android/sdk/ndk/25.2.9519653/"}
export BENCHMARK_PER_LAYER=${BENCHMARK_PER_LAYER:-"0"}

build() {
    rm -rf build-android/
    mkdir build-android/
    pushd build-android/
    export NDK=$ANDROID_NDK
    if [ "$BENCHMARK_PER_LAYER" = "0" ]; then
        cmake -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-23 -DCMAKE_C_FLAGS=-march=armv8.4a+dotprod ..
    else
        cmake -DBENCHMARK_PER_LAYER=1 -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-23 -DCMAKE_C_FLAGS=-march=armv8.4a+dotprod ..
    fi
    make
    popd
}

cd $LLAMA_CPP_HOME
build