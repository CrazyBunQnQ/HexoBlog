---
title: Docker 中使用 Nvidia 显卡
date: 2022-09-22 22:22:22
img: "/images/NvidiaInDocker.png"
top: 10
cover: false
coverImg: "/images/NvidiaInDocker.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: Docker
tags:
- 显卡
- 容器
keywords:
- Nvidia
- Docker
- Container
summary: 手里有块 N 卡，平时也没时间玩游戏，不用就浪费了，正好最近研究机器学习可以使用 GPU 训练模型，要好好利用起来！来看看 Docker 中如何使用宿主机的 GPU 吧！
---

## 安装 nvidia-docker

### 开始安装 NVIDIA Container Toolkit

```shell
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
```

### 启用实验性功能(CUDA on WSL or MIG capability)

```shell
curl -s -L https://nvidia.github.io/nvidia-container-runtime/experimental/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
```

### 安装 nvidia-docker2

```shell
sudo apt-get update
sudo apt-get install -y nvidia-docker2
# 重启 docker
# sudo systemctl restart docker
# WSL2
sudo service docker stop
sudo service docker start
```

### 测试 nvidia-docker2 是否安装成功, 中间可能需要重启

创建 Docker 容器时添加 `--gpus all` 参数启用 GPU

```shell
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```