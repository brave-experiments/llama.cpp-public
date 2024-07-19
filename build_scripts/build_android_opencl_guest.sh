#!/bin/bash
# Note:   This script is used to build the llama.cpp library on Android (for GPU support).
#         This is destined to be run from inside Termux on Android.
# Author: Stefanos Laskaridis (stefanos@brave.com)


install_deps() {
    pkg update -y
    apt update -y
    pkg upgrade -y
    pkg install -y git
    apt install -y libopenblas
    apt install -y clang cmake cmake-curses-gui
    apt install -y opencl-headers ocl-icd opencl-headers opencl-clhpp clinfo
    termux-setup-storage
}

install_clblast() {
    git clone https://github.com/CNugteren/CLBlast.git
    pushd CLBlast
        cmake -B build \
            -DBUILD_SHARED_LIBS=OFF \
            -DTUNERS=OFF \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_INSTALL_PREFIX=/data/data/com.termux/files/usr
        pushd build
            make -j8
            make install
        popd
    popd
}

build_llama() {
    git clone https://github.com/ggerganov/llama.cpp.git
    pushd llama.cpp/
        cmake -B build-gpu -DLLAMA_CLBLAST=ON
        cd build-gpu
        make -j8
    popd
}

run_llama() {
    pushd llama.cpp/
        export LD_LIBRARY_PATH=/system/vendor/lib64/egl:/system/vendor/lib64/:/vendor/lib64/$LD_LIBRARY_PATH
        if [ -f ~/ggml-model-f4_0.gguf ]; then
            GGML_OPENCL_PLATFORM=0 GGML_OPENCL_DEVICE=0 ./bin/main -m ~/ggml-model-f4_0.gguf -ngl 33 -p "Hello!"
        else
            echo "Model file not found. Copy it to ~/ggml-model-f4_0.gguf and run the following command:"
            echo "$ GGML_OPENCL_PLATFORM=0 GGML_OPENCL_DEVICE=0 ./bin/main -m ~/ggml-model-f4_0.gguf -ngl 33 -p \"Hello!\""
        fi
    popd
}

install_deps && \
install_clblast && \
build_llama && \
run_llama
