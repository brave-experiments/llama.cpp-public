# llama.cpp run scripts

This directory includes scripts for running llama.cpp on different targets.
We support runtime through `expect` scripts, to interact with the `build*/bin/main` binary.

## Structure

```bash
├── run-llamacpp-android.exp      # Android expect script
├── run-llamacpp-jetson.exp       # Jetson expect script (can also be adapted to local runtime)
└── run-llamacpp.sh               # Wrapper shell script
```

## How to run?

The `run-llama.sh` script is the entry point for running experiments. Outside of this repo, this is used by `phonelab` and `jetsonlab` for automated runtime of benchmarks. However, one can invoke the script manually if they desire.

```
./run-llamacpp.sh <device_type> <input_path> <model_name> <input_prompts_filename> <conversation_from> <conversation_to> <output_path> <events_filename> <iteration> <cpu>

<device_type>: Type of device to run on {"android", "jetson", "macOS"}
<input_path>: The root path in which model and binaries reside on target device.
<model_name>: The path to the model
<input_prompts_filename>: The path of the input prompts json file
<conversation_from>: The ordinal of the conversation to start from
<conversation_to>: The ordinal of the conversation to end at
<output_path>: The output path for logs and metrics.
<events_filename>: The filename to use for energy events timestamps
<iteration>: The iteration (i.e. repetition) that this experiment is running.
<cpu>: 0 if running on gpu, 1 otherwise (affects -ngl later)
```

Please remember that you need the binaries and models to reside in the target device. See `../build_scripts` directory for more.