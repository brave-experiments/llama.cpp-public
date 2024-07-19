#! /bin/bash
# Note:   This script pushes build models to the iOS device.
#         You need to have installed [idevice](https://github.com/libimobiledevice/libimobiledevice).
# Author: Stefanos Laskaridis (stefanos@brave.com)

MODEL_DIR=${MODEL_DIR:-"../../../../melt_models_converted/"}
if [ $# -gt 0 ]; then
    MODELS=("$@")
else
    MODELS=(
        "TinyLlama_TinyLlama-1.1B-Chat-v0.5"
        "stabilityai_stablelm-zephyr-3b"
        "mistralai_Mistral-7B-Instruct-v0.1"
        "Llama-2-7b-chat-hf"
        "Llama-2-13b-chat-hf"
    )
fi
LLAMACPP_MOUNTPOINT=${LLAMACPP_MOUNTPOINT:-"/tmp/iphone_llamacpp_mount"}

# Make sure that mountpoints exist
mkdir -p ${LLAMACPP_MOUNTPOINT}

echo Mounting llama.cpp folder
ifuse --documents 'com.brave.LLMFarmEval' ${LLAMACPP_MOUNTPOINT}

for model in "${MODELS[@]}";do
    echo Pushing model $model to llama.cpp folder
    cp -rv ${MODEL_DIR}/${model} ${LLAMACPP_MOUNTPOINT}/
done

echo Unmounting llama.cpp folder
fusermount -u ${LLAMACPP_MOUNTPOINT}
