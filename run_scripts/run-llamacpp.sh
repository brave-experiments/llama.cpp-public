#!/bin/bash
# Note:   This script is a wrapper for expect scripts that run llama.cpp on Android and Jetson devices.
# Author: Stefanos Laskaridis (stefanos@brave.com), Kleomenis Katevas (kkatevas@brave.com)

# show script usage
if [ $# -ne 11 ]
then
	echo "===================================================="
	echo "USAGE: $0 device_type input_path model_name input_prompts_filename conversation_from conversation_to output_path events_filename iteration cpu n_threads"
    echo "Passed parameters: $@"
	echo "===================================================="
	exit -1
fi
DEVICE_TYPE=$1
INPUT_PATH=$2
MODEL_NAME=$3
INPUT_PROMPTS_FILENAME=$4
CONVERSATION_FROM=$5
CONVERSATION_TO=$6
OUTPUT_PATH=$7
EVENTS_FILENAME=$8
ITERATION=$9
CPU=${10}
N_THREADS=${11}

FILE_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
REAL_OUTPUT_PATH=$(realpath $OUTPUT_PATH)

# Check device type and set expect_script accordingly
expect_script=""
if [ "$DEVICE_TYPE" == "android" ]; then
    expect_script="run-llamacpp-android.exp"
elif [ "$DEVICE_TYPE" == "jetson" ] || [ "$DEVICE_TYPE" == "macOS" ]; then
    expect_script="run-llamacpp-jetson.exp"
else
    echo "Unsupported device_type: $DEVICE_TYPE"
    exit -1
fi

# iterate per conversation
for (( i=CONVERSATION_FROM; i<CONVERSATION_TO; i++ ))
do
    mkdir -p $REAL_OUTPUT_PATH/melt_measurements
    pushd $FILE_DIRECTORY
    # Execute the appropriate $expect_script for particular conversation
    ./$expect_script "$INPUT_PATH" "$MODEL_NAME" "$INPUT_PROMPTS_FILENAME" $i $i "$REAL_OUTPUT_PATH" "${EVENTS_FILENAME}_iter${ITERATION}_conv$i.tsv" ${ITERATION} ${CPU} ${N_THREADS}
    sleep 1
    popd
done
