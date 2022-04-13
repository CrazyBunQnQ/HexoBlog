---
title: TensorFlow 机器学习环境搭建
date: 2022-04-06 22:22:22
img: "/images/tensorflow.png"
cover: false
coverImg: "/images/tensorflow.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: 机器学习
tags:
- TensorFlow
- Python
- Windows
keywords: TensorFlow
summary: 想要搞机器学习啦，先把环境搭起来! 因为显卡还想用来玩游戏，所以这里是基于 Windows 搭建哒！
---

## 基础环境

- 系统: Windows 10 64位

  [其他平台的构建表](https://github.com/tensorflow/build#community-supported-tensorflow-builds)
- 显卡: 支持 CUDA 的 Nvidia 显卡

### 安装 CUDA

按照[官方系统软件要求](https://www.tensorflow.org/install/gpu#software_requirements)安装

- 安装 [NVIDIA 驱动包](https://www.nvidia.com/drivers)
- 安装 [CUDA 工具包](https://developer.nvidia.com/cuda-toolkit-archive), 添加环境变量
- 安装 [cuDNN](https://developer.nvidia.com/rdp/cudnn-archive)
  > 解压 cnDNN 压缩包，将其中的文件夹复制到 CUDA 的安装目录中，与原文件夹合并(不会冲突)：
  >
  > `...\NVIDIA GPU Computing Toolkit\CUDA\v11.6\`
- 安装 [zlib](https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html#install-zlib-windows), 否则不支持卷积神经网络的训练
  > 解压后将 `zlibwapi.dll` 拷贝到 `...\NVIDIA GPU Computing Toolkit\CUDA\v11.6\bin\` 目录下
  > 
  > 安装 CUDA 时已设置环境变量，这里不用再配了

## 安装 Python

我用的 [Anaconda3](https://repo.anaconda.com), 安装完事 Python3.9 的版本

### Anaconda 常用命令

|     操作     |                   命令                    |
|:----------:|:---------------------------------------:|
|    新建环境    | `conda create -n ENV_NAME python=3.8.8` |
|    激活环境    |        `conda activate ENV_NAME`        |
|    安装包     |      `conda install PACKAGE_NAME`       |
|    卸载包     |       `conda remove PACKAGE_NAME`       |
| 显示所有已安装的包  |              `conda list`               |
|    退出环境    |           `conda deactivate`            |
|    删除环境    |     `conda env remove -n ENV_NAME`      |
| 显示所有已安装的环境 |            `conda env list`             |

```shell
# 添加清华源
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
# 显示源
conda config --set show_channel_urls yes
# 删除源路径
conda config --remove-key channels # （移除所有其他镜像源, 只留默认源）
conda config --remove channels 指定的URL # 删除指定源
```

> 我并没有用 Anaconda 安装依赖，仅创建虚拟环境后用 pip 进行安装

## 安装 TensorFlow

[官方参考文档](https://github.com/tensorflow/tensorflow#install)
[Anaconda 参考文档](https://docs.anaconda.com/anaconda/user-guide/tasks/tensorflow/)

```shell
# 安装 GPU 版本, 使用清华源 (仅支持 CPU 的版本 pip install tensorflow-cpu)
pip install tensorflow -i https://pypi.tuna.tsinghua.edu.cn/simple
# 基于当前环境创建虚拟环境
conda create -n tf-gpu-py39
# 激活虚拟环境
conda activate tf-gpu-py39
```

> 在上 `pip install` 命令上添加 `--upgrade` 参数可升级 Tensorflow

### 验证安装成功:

```shell
python
```

```python
import tensorflow as tf
tf.add(1, 2).numpy()
# 3
hello = tf.constant('Hello, TensorFlow!')
hello.numpy()
# b'Hello, TensorFlow!'
exit()
```

## 安装 JupyterLab

[官方安装文档](https://jupyter.org/install)

```shell
# 安装 Jupyter Lab
pip install jupyterlab
# 安装中文包
pip install jupyterlab-language-pack-zh-CN
# 生成配置文件 (\Users\xx\.jupyter\jupyter_server_config.py)
jupyter server --generate-config
# jupyter notebook --generate-config
# 设置密码 (\Users\xx\.jupyter\jupyter_server_config.json)
jupyter server password
# 编辑设置证书 
# D:\Mega\https证书\crazynft.top\\fullchain1.pem
# D:\Mega\https证书\crazynft.top\\privkey1.pem
vim C:\Users\xx\.jupyter\jupyter_server_config.py
# c.ServerApp.allow_remote_access = True # 允许远程登录
# c.ServerApp.ip = '*' # 允许所有 ip 登录
# c.ServerApp.certfile = 'D:\Mega\https_cert\xxx.com\\fullchain1.pem' # 设置证书
# c.ServerApp.client_ca = 'D:\Mega\https_cert\xxx.com\\privkey1.pem' # 设置证书私钥
# 运行 Jupyter Lab, 会将启动位置作为基础目录
jupyter-lab
```

### 设置 JupyterLab 为服务

> 待续...