#! /bin/bash
# Note:   This script pushes build models to the android device.
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

for model in "${MODELS[@]}";do
    echo Pushing model $model to /data/local/tmp
    adb push $MODEL_DIR/$model /data/local/tmp
done