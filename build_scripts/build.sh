#!/bin/bash

# Note:   This script is used to build the llama.cpp library locally (tested on Mac).
# Author: Stefanos Laskaridis (stefanos@brave.com)

export LLAMA_CPP_HOME=${LLAMA_CPP_HOME:-"$PWD/../"}
export BENCHMARK_PER_LAYER=${BENCHMARK_PER_LAYER:-"0"}


build() {
    echo "Building llama.cpp"
    rm -rf build/
    mkdir -p build/
    pushd build/
    if [ "$BENCHMARK_PER_LAYER" = "0" ]; then
        cmake ..
    else
        cmake -DBENCHMARK_PER_LAYER=1 ..
    fi
    cmake --build . --config Release
    popd
}


cd $LLAMA_CPP_HOME
build
