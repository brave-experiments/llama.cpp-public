#!/bin/bash
# Note:   This script is used to build the llama.cpp library on Jetson devices.
#         Tested on Jetson Orin AGX and Nano.
# Author: Stefanos Laskaridis (stefanos@brave.com)

export LLAMA_CPP_HOME=${LLAMA_CPP_HOME:-"$PWD/../"}
export BENCHMARK_PER_LAYER=${BENCHMARK_PER_LAYER:-"0"}


build() {
    echo "Building llama.cpp"
    rm -rf build-jetson/
    mkdir -p build-jetson/
    pushd build-jetson/
    if [ "$BENCHMARK_PER_LAYER" = "0" ]; then
        cmake -DLLAMA_CUBLAS=ON -DLLAMA_CUDA_DMMV_F16=ON -DLLAMA_CUDA_DMMV_Y=16 ..
    else
        cmake -DLLAMA_CUBLAS=ON -DLLAMA_CUDA_DMMV_F16=ON -DLLAMA_CUDA_DMMV_Y=16 -DBENCHMARK_PER_LAYER=1 ..
    fi
    cmake --build . --config Release
    popd
}

make_link() {
    ln -s build-jetson jetson
}


cd $LLAMA_CPP_HOME
build
make_link
