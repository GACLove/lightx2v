#!/bin/bash

# set path and first
lightx2v_path=""
model_path=""

# check section
if [ -z "${CUDA_VISIBLE_DEVICES}" ]; then
    cuda_devices=0
    echo "Warn: CUDA_VISIBLE_DEVICES is not set, using defalt value: ${cuda_devices}, change at shell script or set env variable."
    export CUDA_VISIBLE_DEVICES=${cuda_devices}
fi

if [ -z "${lightx2v_path}" ]; then
    echo "Error: lightx2v_path is not set. Please set this variable first."
    exit 1
fi

if [ -z "${model_path}" ]; then
    echo "Error: model_path is not set. Please set this variable first."
    exit 1
fi

export PYTHONPATH=${lightx2v_path}:$PYTHONPATH

export ENABLE_PROFILING_DEBUG=true
export ENABLE_GRAPH_MODE=false

python ${lightx2v_path}/lightx2v/__main__.py \
--model_cls hunyuan \
--model_path $model_path \
--prompt "A cat walks on the grass, realistic style." \
--infer_steps 20 \
--target_video_length 33 \
--target_height 720 \
--target_width 1280 \
--attention_type flash_attn3 \
--save_video_path ./output_lightx2v_hy_t2v.mp4 \
--mm_config '{"mm_type": "W-int8-channel-sym-A-int8-channel-sym-dynamic-Vllm", "weight_auto_quant": true}'
