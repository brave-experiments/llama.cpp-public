#!/bin/bash
# Note:   This script installs termux and sets up an ssh server on an Android device.
# Author: Stefanos Laskaridis (stefanos@brave.com)

ADB=${ADB:-"$HOME/Library/Android/sdk/platform-tools/adb"}
SLEEP_TIME=${SLEEP_TIME:-10}

install_termux() {
    if [ ! -f termux-app_v0.118.0+github-debug_arm64-v8a.apk ]; then
        echo "Downloading termux"
        wget https://github.com/termux/termux-app/releases/download/v0.118.0/termux-app_v0.118.0+github-debug_arm64-v8a.apk
    fi
    $ADB install termux-app_v0.118.0+github-debug_arm64-v8a.apk
    rm -rf termux-app_v0.118.0+github-debug_arm64-v8a.apk
}

run_termux_cmd() {
    echo "$ $1"
    # $ADB shell am start -n com.termux/.HomeActivity
    cmd=$(echo $1 | sed 's/ /%s/g')
    $ADB shell input text "$cmd"
    $ADB shell input keyevent ENTER
}

install_deps() {
    echo "Installing openssh openssl-tool termux-auth"
    $ADB shell am start -n com.termux/.HomeActivity
    run_termux_cmd "apt install -y openssh"
    run_termux_cmd "apt install -y openssl-tool"
    run_termux_cmd "pkg install -y termux-auth"
}

set_user_passwd() {
    run_termux_cmd "passwd"
    run_termux_cmd "$1"
    run_termux_cmd "$1"
}

launch_ssh_termux() {
    echo "Launching sshd"
    run_termux_cmd "ssh-keygen -A"
    run_termux_cmd "sshd"
}

stop_ssh_termux() {
    run_termux_cmd "pkill sshd"
}

adb_port_forward() {
    echo "Port forwarding to 8022"
    $ADB forward tcp:8022 tcp:8022
}

adb_ssh() {
    ssh -p 8022 $1@localhost "echo Hello from termux!"
}

echo "To run, please unlock your device and make sure it remains on."

install_termux
sleep $SLEEP_TIME
install_deps
sleep $SLEEP_TIME
set_user_passwd "ggml"
sleep $SLEEP_TIME
launch_ssh_termux
sleep $SLEEP_TIME
adb_port_forward
adb_ssh "u0_a325"
