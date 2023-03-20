---
title: Windows Docker 中运行 PaddleSpeech
date: 2023-01-22 22:22:22
img: "/images/PaddleSpeech.png"
top: 10
cover: false
coverImg: "/images/PaddleSpeech.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: 触类旁通
tags:
- 树莓派
- 容器
keywords: 树莓派
summary: 最近 AI 杀疯了啊，赶紧上车看看！先从 AI 语音开始~直接上 Docker，少折腾！
---

## PaddleSpeech

[语音识别、语音合成等示例](https://github.com/PaddlePaddle/PaddleSpeech/blob/develop/README_cn.md#%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B)

### 创建容器

```shell
# docker build -f Dockerfile -t crazybun/ruoyi:20221223 . && docker run --name ruoyi -d -t -i -v /root/logs/docker-logs/ruoyi:/RuoYi/logs -p 80:80 --restart always crazybun/ruoyi:20221223 
docker run --name paddlespeech-cpu -itd -p 8888:8888 \
  -v /g/Docker/volumes/paddlespeech/mnt:/mnt \
  -v /d/TensorFlowNotebook:/root/notebook \
  -v /g/Docker/volumes/paddlespeech_gpu/.jupyter:/root/.jupyter \
  paddlecloud/paddlespeech:develop-cpu-478fd2  /bin/bash
# 先执行下面命令将 /root 目录备份出来
# docker run --name paddlespeech-gpu -itd -p 8888:8888 -p 8090:8090 --restart always --gpus all -v /h/MyPrograms/Python/PaddleSpeech:/home/PaddleSpeech -v /g/Docker/volumes/paddlespeech_gpu/mnt:/mnt -v /d/TensorFlowNotebook:/notebook -v /g/Docker/volumes/paddlespeech_gpu/.jupyter:/root/.jupyter paddlecloud/paddlespeech:develop-gpu-cuda11.2-cudnn8-478fd2 /bin/bash
docker run --name paddlespeech-gpu -itd -p 8888:8888 -p 8090:8090 --restart always --gpus all --ipc=host -v /h/MyPrograms/Python/PaddleSpeech:/home/PaddleSpeech -v /g/Docker/volumes/paddlespeech_gpu/mnt:/mnt -v /g/Docker/volumes/paddlespeech_gpu/root:/root -v /d/TensorFlowNotebook:/notebook -v /g/Docker/volumes/paddlespeech_gpu/.jupyter:/root/.jupyter paddlecloud/paddlespeech:develop-gpu-cuda11.2-cudnn8-478fd2 /bin/bash
docker run --name paddlespeech -itd -p 8888:8888 -p 8090:8090 --restart always --gpus all --ipc=host -v /h/MyPrograms/Python/PaddleSpeech:/home/PaddleSpeech -v /g/Docker/volumes/paddlespeech_gpu/mnt:/mnt -v /g/Docker/volumes/paddlespeech_gpu/root:/root -v /d/TensorFlowNotebook:/notebook -v /g/Docker/volumes/paddlespeech_gpu/.jupyter:/root/.jupyter paddlecloud/paddlespeech:develop-gpu-cuda11.2-cudnn8-478fd2 /bin/bash
```

> Windows 安装 Docker 后弹出的防火墙提示，一定要选中公共，否则只有本机能访问!!

### 其他安装项

根据[我遇到的问题](#问题)进行的教程以外的安装项

```shell
apt install libsndfile1 sox libopenblas-dev -y

# pip install paddlepaddle==2.4.1 -i https://mirror.baidu.com/pypi/simple
# https://www.paddlepaddle.org.cn/install/quick?docurl=/documentation/docs/zh/install/pip/linux-pip.html
pip install paddlepaddle-gpu==2.4.1.post112 -f https://www.paddlepaddle.org.cn/whl/linux/mkl/avx/stable.html

pip install pytest-runner -i https://pypi.tuna.tsinghua.edu.cn/simple

cd ${HOME}
wget https://paddlespeech.bj.bcebos.com/Parakeet/tools/nltk_data.tar.gz
tar -zxvf nltk_data.tar.gz

cd /home/PaddleSpeech
# 更新 PaddleSpeech
git fetch && git pull && pip install .

# 安装 Kaldi(http://kaldi-asr.org/),可选
pushd tools
# 我这里安装报错，在 make 命令添加 TARGET 参数后安装成功 
# make PREFIX=$(pwd)/OpenBLAS/install USE_LOCKING=1 USE_THREAD=0 TARGET=HASWELL -C OpenBLAS all install
bash extras/install_openblas.sh
# 安装过程很长，另外可能需要先执行这个 apt-get install sox -y
bash extras/install_kaldi.sh
popd

# 手动安装 MFA，需要 python 3.8，而且时间也很长...这里直接用自带的了
```

### 启动 JupyterLab

镜像中内置 Jupyter Lab, 顺便启动了

```shell
# 内置 JupyterLab
# 安装中文包
pip install jupyterlab-language-pack-zh-CN
# 设置密码
jupyter server password
# 启动 JupyterLab
jupyter-lab --ip=0.0.0.0 --port=8888 --allow-root --notebook-dir=/notebook
# 后台 
nohup jupyter-lab --ip=0.0.0.0 --port=8888 --allow-root --notebook-dir=/notebook > /mnt/jupyterlab.log 2>&1 &
# 关闭后台
ps -aux | grep jupyter
kill -9 9608
```

##### 注意！

> 容器启动后执行一下 `nvidia-smi` 命令测试能否调用 GPU
> 
> 磁盘挂载一定要在 Windows 命令行中执行，否则回挂载到 WSL 虚拟机中的路径，Windows 看不到！

### [后端服务](https://github.com/PaddlePaddle/PaddleSpeech/blob/develop/demos/speech_server/README_cn.md)

安装完成后，开发者可以通过命令行一键启动语音识别，语音合成，音频分类等多种服务

它是一个离线语音服务和访问服务的实现。可以通过使用 `paddlespeech_server` 和 `paddlespeech_client` 的单个命令或 python 的几行代码来实现

服务接口定义请参考:

- [PaddleSpeech Server RESTful API](https://github.com/PaddlePaddle/PaddleSpeech/wiki/PaddleSpeech-Server-RESTful-API)

你可以在 AI Studio 中快速体验：[SpeechServer 一键部署](https://aistudio.baidu.com/aistudio/projectdetail/4354592?sUid=2470186&shared=1&ts=1660878208266)

#### 启动服务

```shell
# paddlespeech_server start --config_file ./conf/application.yaml
paddlespeech_server start --config_file /root/speech_server/application.yaml
# 后台启动
nohup paddlespeech_server start --config_file /root/speech_server/application.yaml > /mnt/paddlespeech_server.log 2>&1 &
```

#### 访问语音识别服务

```shell
paddlespeech_client asr --server_ip 127.0.0.1 --port 8090 --input input_16k.wav
```

### 问题

#### OSError: sndfile library not found

```shell
apt install libsndfile1 -y
```

#### grep: warning: GREP_OPTIONS is deprecated; please use an alias or script

这一行的打印提示是为了说明grep命令输出高亮字，并不影响程序的运行

可参考[这里](https://stackoverflow.com/questions/31156517/how-to-get-rid-of-grep-warning-grep-options-is-deprecated-please-use-an-alia)关闭高亮

```shell
unset GREP_OPTIONS
```

> 可以添加到 `.bashrc` 中一劳永逸

#### declarative() got an unexpected keyword argument 'property'

参考[https://github.com/PaddlePaddle/PaddleSpeech/issues/2512](https://github.com/PaddlePaddle/PaddleSpeech/issues/2512)

property 是 paddle 2.4rc 中新增的功能，如果用到 paddlespeech develop 的代码的话，需要使用 paddle 的 dev 版本或 >=2.4rc

> 写此文时，官网要求相关依赖<br/>
> - gcc >= 4.8.5<br/>
> - **paddlepaddle >= 2.4.1**<br/>
> - python >= 3.7<br/>
> - linux(推荐), mac, windows<br/>


[Paddle 详细安装说明](https://www.paddlepaddle.org.cn/install/quick?docurl=/documentation/docs/zh/install/pip/linux-pip.html)

```shell
# 原先为 2.3.0.post112
pip install paddlepaddle-gpu==2.4.1.post112 -f https://www.paddlepaddle.org.cn/whl/linux/mkl/avx/stable.html
```

### [nltk_data] Error loading averaged_perceptron_tagger: <urlopen error

下载 **nltk_data** 时网络不佳，可以提前下载 [nltk_data](https://paddlespeech.bj.bcebos.com/Parakeet/tools/nltk_data.tar.gz) 并解压缩到 `${HOME}` 目录下。

```shell
cd ${HOME}
wget https://paddlespeech.bj.bcebos.com/Parakeet/tools/nltk_data.tar.gz
tar -zxvf nltk_data.tar.gz
```

#### cudaErrorNoKernelImageForDevice

```log
terminate called after throwing an instance of 'thrust::system::system_error'
  what():  parallel_for failed: cudaErrorNoKernelImageForDevice: no kernel image is available for execution on the device
Aborted
```

`cudaErrorNoKernelImageForDevice` 应该是 paddle 的 cuda 版本和你机器的 cuda 版本不一致导致的（你自己机器的 cuda 有达到 11.6 么），在 paddle 的 issue 区可以搜到

参考:
- https://github.com/PaddlePaddle/PaddleSpeech/issues/991
- https://github.com/PaddlePaddle/PaddleSpeech/issues/2506

#### DeprecationWarning

[//]: # (TOTO)

#### The installed Paddle is compiled with CUDNN 8.2, but CUDNN version in your machine is 8.1

安装 CUDNN 8.2 并替换

```shell
/usr/local/cuda-11.2 ls -l
total 40K
lrwxrwxrwx 1 root root   28 Dec  1  2020 include -> targets/x86_64-linux/include
lrwxrwxrwx 1 root root   24 Feb  5  2021 lib64 -> targets/x86_64-linux/lib
drwxr-xr-x 1 root root 4.0K Mar  8  2021 targets/

cd /usr/local/cuda-11.2
cd /usr/local/cuda-11.2/targets/x86_64-linux
cp /mnt/cuDNN/cuDNN_v8.2.1_for_cuda_11.x/cuda/include/cudnn.h ./include/
cp /mnt/cuDNN/cuDNN_v8.2.1_for_cuda_11.x/cuda/lib64/libcudnn* ./lib/
chmod a+r /usr/local/cuda*/include/cudnn.h /usr/local/cuda*/lib64/libcudnn*
```

#### No such file or directory: 'exp/.mfa_train_and_align/baker_corpus/train/mfcc/raw_mfcc.0.scp'

```shell
apt install libopenblas-dev
```
在安装 libopenblas-dev 后
删除 MFA 附带的库将强制 MFA 使用您安装的库, MFA 就应该可以正常工作了

```shell
rm {mfa_dir}/lib/thirdparty/bin/libopenblas.so.0
```

#### AssertionError: This dataset has no examples

问题同上, 安装完成后删除 PaddleSpeech 目录下所有的 `libopenblas.so.0` 即可

#### SystemError: (Fatal) DataLoader process

```
SystemError: (Fatal) DataLoader process (pid
  1. If run DataLoader by DataLoader.from_generator(...), queue capacity is set by from_generator(..., capacity=xx, ...).
  2. If run DataLoader by DataLoader(dataset, ...), queue capacity is set as 2 times of the max value of num_workers and len(places).
  3. If run by DataLoader(dataset, ..., use_shared_memory=True), set use_shared_memory=False for not using shared memory.) exited is killed by signal: 21707.
  It may be caused by insufficient shared storage space. This problem usually occurs when using docker as a development environment.
  Please use command `df -h` to check the storage space of `/dev/shm`. Shared storage space needs to be greater than (DataLoader Num * DataLoader queue capacity * 1 batch data size
).
  You can solve this problem by increasing the shared storage space or reducing the queue capacity appropriately.
Bus error (at /paddle/paddle/fluid/imperative/data_loader.cc:183)
```

这可能是由于共享存储空间不足引起的。使用 docker 作为开发环境时，通常会发生此问题。
请使用命令 'df -h' 检查 'devshm' 的存储空间. Shared storage space needs to be greater than (DataLoader Num * DataLoader queue capacity * 1 batch data size

```shell
λ 60cc7c67bf7f /home/PaddleSpeech/examples/aishell3/tts3 df -h
Filesystem      Size  Used Avail Use% Mounted on
overlay         251G   32G  207G  14% /
tmpfs            64M     0   64M   0% /dev
tmpfs            16G     0   16G   0% /sys/fs/cgroup
shm              64M   64K   64M   1% /dev/shm
drvfs           4.6T  227G  4.4T   5% /mnt
drvfs           700G  394G  307G  57% /notebook
drvfs           3.7T  3.6T  116G  97% /home/PaddleSpeech
/dev/sdb        251G   32G  207G  14% /etc/hosts
drivers         231G  187G   45G  81% /usr/bin/nvidia-smi
lib             231G  187G   45G  81% /usr/lib/x86_64-linux-gnu/libcuda.so.1
none             16G     0   16G   0% /dev/dxg
tmpfs            16G     0   16G   0% /proc/acpi
tmpfs            16G     0   16G   0% /sys/firmware
```

`docker run` 命令加上 [`--ipc=host`](https://github.com/PaddlePaddle/PaddleSpeech/issues/790#issuecomment-906128565) 后就可以共享宿主机内存了

##### 关于 Docker 容器间的 IPC 通信

`docker run --ipc=""` 可以设置共享内存，ipc 参数有两种使用方式

1. 容器间都共享宿主机的内存
   ```shell
   # 所有容器启动时加入该参数
   docker run --ipc=host
   ```
2. 共享其中某个容器的内存, 例如使用容器1的内存

   ```shell
   # 启动容器1，将其设置为共享模式. 2fdf93c10b4e 替换为自己的镜像 id
   docker run -it --ipc=shareable --name ipc_container1 2fdf93c10b4e /bin/bash
   # 启动容器2，连接到容器1的内存
   docker run -it --ipc=container:ipc_container1 --name ipc_container2 2fdf93c10b4e /bin/bash
   ```

#### ImportError: libcudart.so.10.2: cannot open shared object file: No such file or directory

参考 [https://github.com/PaddlePaddle/Paddle/issues/49581](https://github.com/PaddlePaddle/Paddle/issues/49581)

[paddlepaddle-gpu 依赖库官方说明](https://pypi.org/project/paddlepaddle-gpu/)中先决条件:

> 得！GPU 版本最高支持 CUDA 10，白搞，再来一遍吧...

#### OpenBLAS: Detecting CPU failed. Please set TARGET explicitly, e.g. make TARGET=your_cpu_target

安装 Kaldi 时报错

在自动安装脚本中的 `make` 命令添加 ` TARGET=your_cpu_target` 参数

我在这里将

```shell
make PREFIX=$(pwd)/OpenBLAS/install USE_LOCKING=1 USE_THREAD=0 -C OpenBLAS all install
```

改为

```shell
make PREFIX=$(pwd)/OpenBLAS/install USE_LOCKING=1 USE_THREAD=0 TARGET=HASWELL -C OpenBLAS all install
```

[参考1](https://github.com/xianyi/OpenBLAS/issues/2227)
[参考2](https://github.com/xianyi/OpenBLAS/issues/1204#issuecomment-308457857)

##### ON WINDOWS:

- Windows 7/8/10 Pro/Enterprise (64bit)
  - GPU version support CUDA 9.0/9.1/9.2/10.0/10.1，only supports single card
- Python version 2.7.15+/3.5.1+/3.6/3.7/3.8 (64 bit)
- pip version 9.0.1+ (64 bit)

##### ON LINUX:
- Linux Version (64 bit)
  - CentOS 6 (GPU Version Supports CUDA 9.0/9.1/9.2/10.0/10.1, only supports single card)**
  - CentOS 7 (GPUVersion Supports CUDA 9.0/9.1/9.2/10.0/10.1, CUDA 9.1 only supports single card)**
  - Ubuntu 14.04 (GPUVersion Supports CUDA 10.0/10.1)
  - Ubuntu 16.04 (GPUVersion Supports CUDA 9.0/9.1/9.2/10.0/10.1)
  - Ubuntu 18.04 (GPUVersion Supports CUDA 10.0/10.1)
- Python Version: 2.7.15+/3.5.1+/3.6/3.7/3.8 (64 bit)
- pip or pip3 Version 20.2.2+ (64 bit)

##### ON MACOS:

- MacOS version 10.11/10.12/10.13/10.14 (64 bit) (not support GPU version yet)
- Python version 2.7.15+/3.5.1+/3.6/3.7/3.8 (64 bit)
- pip or pip3 version 9.0.1+ (64 bit)

## [训练一个自己的 TTS 模型](https://github.com/PaddlePaddle/PaddleSpeech/discussions/1842)

首先看一下效果 [对 paddlespeech 的拙劣尝试](https://www.bilibili.com/video/BV1Vr4y18738) 和 [对 paddlespeech 的拙劣尝试 2](https://www.bilibili.com/video/BV1kU4y1m7aH)

我们需要走通 `other/mfa` 和 `aishell3/tts3` 两个流程

> 另外 windows 电脑也能搞这个 用 Git Bash 就好了 有的地方要小改一下<br/>
> 反正我是没搞出来...

> [大佬](https://github.com/kslz)说:<br/>
> 已经挺细了 可以直接去读一下 shell 代码 基本就知道流程了，因为我不懂 shell 也不怎么懂 python 都能把流程走下来，所以我估计换一个人来走一遍流程也是轻而易举的<br/>
> 我估计我再写的细点，就要去牢里蹬缝纫机了

#### 收集数据

数据收集自网上，一种 speaker 大概需要 600 句话。获取到数据后用 [SpleeterGui](https://github.com/boy1dr/SpleeterGui) 进行背景音乐的分离，只取人声。

```shell
# 视频提取 wav
ffmpeg -i .\12.mp4 -ac 1 -ar 16000 -y 12.wav
```

#### 数据标注

[大佬](https://github.com/kslz)写了个小软件, 啪的一下, 很快啊, 就标注完了，然后模仿 `aishell3` 的格式制作数据集，**记得要排除所有非中文字符**

经过[大佬](https://github.com/kslz)的尝试和读代码, [大佬](https://github.com/kslz)觉得照搬 `aishell3` 的 `speaker` 名的方式是最好的，改动少。

用 `pypinyin` 制作标注文本，效果不怎么喜人，但是大概够用。记得抽出几句来填进 test 文件夹里。



#### 获取 mfa 结果

`other/mfa` 强制对齐(Montreal-Forced-Aligner) 流程走一下

> 可能需要[安装 MFA 命令](https://github.com/MontrealCorpusTools/Montreal-Forced-Aligner)<br/>
> 需要从其[官方网站](https://test.data-baker.com/data/index/source)下载 BZNSYP 并解压缩。并设置数据集的路径为 `~/datasets/BZNSYP`

流程里下载的是 linux 版本的二进制文件

如果你是 windows 的电脑记得改成下载 windows 版本的文件

```shell
# corpus_directory:包含我们的语音文件和文本的文件夹
# dictionary：我们刚刚下载的字典
# acoustic_model：声学模型，pretrained中的english.zip(注意这个文件不能解压）
# output_directory：输出目录文件夹
mfa_align corpus_directory dictionary acoustic_model output_directory
```



#### 数据预处理

`mfa` 结果有了之后去走 `aishell3/tts3` 的流程

先[下载预训练好的那个 `aishell3_fastspeech2` 模型](http://www.aishelltech.com/aishell_3), 挺大的...

然后 **??把脚本里的音素对照表指向这里的音素对照表，不要用你自己生成的那个**

运行 `run.sh` 的时候报错，脚本中用了两块 GPU

将 `gpus` `0`, 将 `local/train.sh` 中的 `ngpu` 改成 `1`

```
Invalid CUDAPlace(1), must inside [0, 1), because GPU number on your machine is 1
```
or
```
Traceback (most recent call last):
  File "/home/PaddleSpeech/paddlespeech/t2s/exps/fastspeech2/train.py", line 222, in <module>
    main()
  File "/home/PaddleSpeech/paddlespeech/t2s/exps/fastspeech2/train.py", line 216, in main
    dist.spawn(train_sp, (args, config), nprocs=args.ngpu)
  File "/usr/local/lib/python3.7/dist-packages/paddle/distributed/spawn.py", line 574, in spawn
    procs_env_list = _get_subprocess_env_list(nprocs, options)
  File "/usr/local/lib/python3.7/dist-packages/paddle/distributed/spawn.py", line 187, in _get_subprocess_env_list
    (len(env_devices_list), nprocs))
RuntimeError: the number of visible devices(1) is less than the number of spawn processes(2), please ensure that the correct `nprocs` argument is passed or the environment variable `CUDA_VISIBLE_DEVICES` is correctly configured.
```

#### 训练

走流程 练一会 然后停下 进 `checkpoints` 文件夹，**??把预训练模型复制进来然后编辑那个 jsonl 文件。删的只剩一行然后把那一行里的 `pdz` 文件指向你刚复制进来的那个模型就可以接着训练了。**

#### 运行

你可以走 `e2e` 那个 `step` 然后指定好 `speaker` 如果不出意外的话，你就能听到你的训练结果了。

> [大佬](https://github.com/kslz)的嘱托<br/>
> 如果你的训练效果特别好 那我只希望<br/>
> ![日后你惹出祸来，不把师傅说出来就行了](https://user-images.githubusercontent.com/54951765/166875062-3ec8e008-483b-4ff3-9f01-ae781613dbc6.jpeg)

