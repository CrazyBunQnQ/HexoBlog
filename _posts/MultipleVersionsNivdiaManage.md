---
title: 树莓派安装 Docker 与持续集成~
date: 2022-09-22 22:22:22
img: "/images/NvidiaCUDA.png"
top: 10
cover: false
coverImg: "/images/NvidiaCUDA.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: 触类旁通
tags:
- 树莓派
- 容器
  keywords: 树莓派
  summary: 最近在了解 Python 机器学习项目，各个项目的环境都不相同，使用的 CUDA 版本也各不相同，还互相不兼容...怎么能多个版本共存并快速切换呢？
---

## 多版本 CUDA 及 cuDNN 管理

### Install CUDA

安装 CUDA 比较快，直接从 [NVIDIA 官网](https://developer.nvidia.com/cuda-toolkit-archive)下载 `runfile` 的版本，并按照它上面的指令输入进行安装

这里有两点很重要需要注意：

> 添加 `--override` 参数可以忽略 `Failed to verify gcc version.`. 但是可能有兼容问题
> 
> 不用从 CUDA-toolkit 里安装驱动，请手动去安装最新的驱动
> 
> 安装时，请不要选择建立 `symbolic link`

以 11.2.2 为例

```shell
wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda_11.2.2_460.32.03_linux.run
sudo sh cuda_11.2.2_460.32.03_linux.run
```

取消勾选驱动

```
CUDA Installer
  [ ] Driver
+ [X] CUDA Toolkit 11.2
  [X] CUDA Samples 11.2
  [X] CUDA Demo Suite 11.2  
  [X] CUDA Documentation 11.2
  Options
  Install
```

按 `A` 显示高级选项, 取消建立 `symbolic link`

```
CUDA Toolkit
  Change Toolkit Install Path
  [ ] Create symbolic link from /usr/local/cuda
- [ ] Create desktop menu shortcuts
     [ ] All users
     [ ] Yes
     [ ] No
  [X] Install manpage documents to /usr/share/man
  Done
```

选择 `Install` 完成安装, 就会输出 Summary

```
===========
= Summary =
===========

Driver:   Not Selected
Toolkit:  Installed in /usr/local/cuda-11.2/
Samples:  Installed in /home/crazybun/, but missing recommended libraries

Please make sure that
 -   PATH includes /usr/local/cuda-11.2/bin
 -   LD_LIBRARY_PATH includes /usr/local/cuda-11.2/lib64, or, add /usr/local/cuda-11.2/lib64 to /etc/ld.so.conf and run ldconfig as root

To uninstall the CUDA Toolkit, run cuda-uninstaller in /usr/local/cuda-11.2/bin
***WARNING: Incomplete installation! This installation did not install the CUDA Driver. A driver of version at least 460.00 is required for CUDA 11.2 functionality to work.
To install the driver using this installer, run the following command, replacing <CudaInstaller> with the name of this run file:
    sudo <CudaInstaller>.run --silent --driver

Logfile is /var/log/cuda-installer.log
```

### Install cuDNN

从 NVIDIA 官网下载[对应 CUDA 版本的 cuDNN](https://developer.nvidia.com/rdp/cudnn-archive)

> 下载时可能需要登录

然后用 `tar -xvf <CUDNN_ZIP_NAME>` 解压缩

执行查看目录结构

```shell
$ tree -L 2 ./
```

内容大概长这样:

```
./
└── cuda
    ├── NVIDIA_SLA_cuDNN_Support.txt
    ├── include
    └── lib64

3 directories, 1 file
```

在 cuda 同级目录下创建 `cudnn_install.sh` 新增脚本, 并写入下面内容

```shell
read -p "CUDA-version: " ver

if [ ! -d "/usr/local/cuda-${ver}" ]; then
  echo "create dir: /usr/local/cuda-${ver}"
  mkdir "/usr/local/cuda-${ver}"
  echo "create dir: /usr/local/cuda-${ver}/include"
  mkdir "/usr/local/cuda-${ver}/include"
  echo "create dir: /usr/local/cuda-${ver}/lib64"
  mkdir "/usr/local/cuda-${ver}/lib64"
fi
cp cuda/include/cudnn.h /usr/local/cuda-"${ver}"/include

cp cuda/lib64/libcudnn* /usr/local/cuda-"${ver}"/lib64

chmod a+r /usr/local/cuda*/include/cudnn.h /usr/local/cuda*/lib64/libcudnn*

echo include

tree -L 1 /usr/local/cuda-"${ver}"/include | grep cudnn

echo lib64

tree -L 1 /usr/local/cuda-"${ver}"/lib64 | grep cudnn
```

目录结构如下:

```
./
├── cuda
│ ├── NVIDIA_SLA_cuDNN_Support.txt
│ ├── include
│ └── lib64
└── cudnn_install.sh

3 directories, 2 files
```

这个脚本时自动把 cuDNN 复制到 CUDA 目录下(为什么 cuDNN 跟 CUDA 要分开下载呢...)

更改脚本权限并执行

```shell
chmod +x cudnn_install.sh & sudo ./cudnn_install.sh
```

安装完成后，在 `~/.bashrc` 或 `~/.zshrc` 中添加切换 CUDA 版本的函数，方便以后直接调用函数切换 CUDA 版本

```shell
# add below to your env bash file.

function _switch_cuda {
   v=$1
   export PATH=$PATH:/usr/local/cuda-$v/bin
   export CUDADIR=/usr/local/cuda-$v
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-$v/lib64
   nvcc --version
}
```

> 记得 `source` 一下

之后只要在命令行中输入 `_switch_cuda 11.2` 就会自动切换 CUDA 版本到 11.2 了

#### 查看 CUDA 版本与 cuDNN 版本

执行 `nvcc --version` 查看 CUDA 版本:

```shell
$ 
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2021 NVIDIA Corporation
Built on Sun_Feb_14_21:12:58_PST_2021
Cuda compilation tools, release 11.2, V11.2.152
Build cuda_11.2.r11.2/compiler.29618528_0
```

查看 cuDNN 版本

先查找 cudnn 版本信息文件位置:

```shell
whereis cudnn_version
# cudnn_version: /usr/include/cudnn_version.h
```

查看大版本号和小版本号

```shell
cat /usr/include/cudnn_version.h | grep CUDNN_MAJOR
#define CUDNN_MAJOR 8
cat /usr/include/cudnn_version.h | grep CUDNN_MINOR
#define CUDNN_MINOR 1
```

所以这里的 cuDNN 版本为 8.1

#### `nvcc` 和 `nvidia-smi` 显示的版本不一致？

- nvcc 属于 CUDA 的编译器，将程序编译成可执行的二进制文件; nvidia-smi(NVIDIA System Management Interface) 是一种命令行实用工具，旨在帮助管理和监控 NVIDIA GPU 设备
- CUDA 有 runtime api 和 driver api，两者都有对应的 CUDA 版本. `nvcc --version` 显示的就是前者对应的 CUDA 版本, 而 `nvidia-smi` 显示的是后者对应的 CUDA 版本
- 用于支持 driver api 的必要文件由 GPU driver installer 安装, `nvidia-smi` 就属于这一类 API; 而用于支持 runtime api 的必要文件是由 CUDA Toolkit installer 安装的。nvcc 是与 CUDA Toolkit 一起安装的 CUDA compiler-driver tool，它只知道它自身构建时的 CUDA runtime 版本，并不知道安装了什么版本的 GPU driver，甚至不知道是否安装了 GPU driver

CUDA Toolkit Installer 通常会集成了 GPU Driver Installer，如果你的 CUDA 均通过 CUDA Toolkit Installer 来安装

那么 runtime api 和 driver api 的版本应该是一致的，也就是说, `nvcc --version` 和 `nvidia-smi` 显示的版本应该一样

因为我们自行安装了最新的的 GPU 驱动, 这样就会导致 `nvidia-smi` 和 `nvcc --version` 显示的版本不一致了

**通常, driver api 的版本能向下兼容 runtime api 的版本，即 `nvidia-smi` 显示的版本大于 `nvcc --version` 的版本通常不会出现问题**
