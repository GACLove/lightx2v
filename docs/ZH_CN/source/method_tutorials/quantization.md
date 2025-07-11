# 模型量化

lightx2v支持对`Dit`中的线性层进行量化推理，支持`w8a8-int8`和`w8a8-fp8`的矩阵乘法。


## 生产量化模型

### 自动量化

lightx2v支持推理时自动对模型权重进行量化，具体可参考[配置文件](https://github.com/ModelTC/lightx2v/tree/main/configs/quantization/wan_i2v_quant_auto.json)。
值得注意的是，需要将配置文件的**mm_config**进行设置：**"mm_config": {"mm_type": "W-int8-channel-sym-A-int8-channel-sym-dynamic-Vllm","weight_auto_quant": true }**， **mm_type**代表希望使用的量化算子，**weight_auto_quant：true**代表自动转量化模型。


### 离线量化

lightx2v同时支持直接加载量化好的权重进行推理，对模型进行离线量化可参考[文档](https://github.com/ModelTC/lightx2v/tree/main/tools/convert/readme_zh.md)。
将转换的权重路径，写到[配置文件](https://github.com/ModelTC/lightx2v/tree/main/configs/quantization/wan_i2v_quant_offline.json)中的`dit_quantized_ckpt`中，同时`mm_type**中的**weight_auto_quant`置为`false`即可。

## 量化推理

### 自动量化
```shell
bash scripts/run_wan_i2v_quant_auto.sh
```
### 离线量化
```shell
bash scripts/run_wan_i2v_quant_offline.sh
```

## 启动量化服务

建议离线转好量化权重之后，`--config_json`指向到离线量化的`json`文件

比如，将`scripts/start_server.sh`脚本进行如下改动：

```shell
export RUNNING_FLAG=infer

python -m lightx2v.api_server \
--model_cls wan2.1 \
--task t2v \
--model_path $model_path \
--config_json ${lightx2v_path}/configs/quantization/wan_i2v_quant_offline.json \
--port 8000
```

## 高阶量化功能

具体可参考量化工具[LLMC的文档](https://github.com/ModelTC/llmc/blob/main/docs/zh_cn/source/backend/lightx2v.md)
