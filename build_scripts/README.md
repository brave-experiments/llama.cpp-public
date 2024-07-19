# llama.cpp build scripts

This directory includes scripts for building llama.cpp against different targets.

## Structure

```bash
├── build.sh                        # Generic build script for building on your laptop (tested on Mac)
├── build_android.sh                # Build script for android, CPU.
├── build_android_opencl_guest.sh   # Build script for android, GPU (running on android termux)
├── build_android_opencl_host.sh    # Build script for android, GPU (running on host)
├── build_jetson.sh                 # Build script for jetson devices
├── push_android_models.sh          # Push android models to device
├── push_ios_models.sh              # PUsh ios models to device
└── setup_termux
    └── install_termux_ssh.sh       # Script for setting up ssh channel on device (can be fidget-y)
```

## How to run?

### Build on your laptop

```bash
./build.sh  # will compile everything under the build/ directory
```

### Build on jetson

After you have cloned the current repository on your jetson device, build with the following command locally:

```bash
# On the jetson device
./build_jetson.sh  # will compile everything under the build-jetson directory
```

### Build for android

#### With CPU support only

```bash
# On the host device
ANDROID_NDK="<path_to_android_ndk>" ./build_android.sh  # will compile everything under the build-android directory.
# To run, you will have to adb push the directory to your device. e.g.,
adb shell mkdir -p /data/local/tmp/llama.cpp/
adb push ../build-android /data/local/tmp/llama.cpp/
```

#### With GPU support

The setup here is a bit more intricate, as the build process will need to happen on the android device.
For this reason, we use termux, that we download and install in an unattended manner.

```bash
pushd setup_termux/
# Automation here may fail depending on your setup.
# Please run commands manually if it fails.
./install_termux_ssh.sh
popd

sleep 5
./build_android_opencl_host.sh
```

Performance is quite suboptimal on GPU, as reported [here](https://github.com/ggerganov/llama.cpp/issues/5965).

### Build for iOS

For iOS, please refer to `../../LLMFarmEval`, which ships with its own custom llama.cpp version.

### Enabling per op benchmarking

For enabling per op benchmarking, please set `BENCHMARK_PER_LAYER=1` before running the respective build script. This can deteriorate end-to-end performance, so use only for inspecting specific op behaviour.