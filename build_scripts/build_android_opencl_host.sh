#!/bin/bash
# Note:   This script is used to build the llama.cpp library on Android (for GPU support).
#         This script runs on the host machine.
# Author: Stefanos Laskaridis (stefanos@brave.com)

scp -rv -P 8022 ./build_android_opencl_guest.sh u0_a325@localhost:~/
ssh -p 8022 u0_a325@localhost ./build_android_opencl_guest.sh