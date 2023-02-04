---
title: Windows 下修改 Docker 镜像路径
date: 2022-08-22 22:22:22
img: "/images/DockerInWindows.png"
top: 10
cover: false
coverImg: "/images/DockerInWindows.png"
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
summary: 最近发现 Docker 镜像占用的空间太多了，尤其是 Python 相关的镜像，分分钟把 C 盘 D 盘占满了...单独搞了个大硬盘专门装镜像、依赖、数据集
---

## Windows 下修改使用 WSL 的 Docker 镜像路径

配置 Docker 使用 WSL 2 后，默认的镜像存放路径是 `C:\Users\<用户名>\AppData\Local\Docker\wsl\data\ext4.vhdx`

要修改镜像路径，原理就是使用 `wsl` 命令重新指定 `Docker` 使用的数据路径。

首先如果启动了 Docker Desktop 的话，要先在系统托盘中右键 Docker Desktop 的图标，点击退出 Docker Desktop。

在命令行窗口中执行

```shell
wsl --list -v
```

要确保输出列表中 `docker-desktop` 和 `docker-desktop-data` 的 `STATE` 列均为 `Stopped`。即：

```shell
  NAME                   STATE           VERSION
* Ubuntu                 Stopped         2
  docker-desktop         Stopped         2
  docker-desktop-data    Stopped         2
```

接下来是将当前 `docker-desktop-data` 备份出来，以便后面更换路径时还原当前的 Docker 数据。我要将 Docker 镜像路径迁移到 `D:\Docker\wsl\data` 目录下，首先要自己手动创建这些目录（否则执行 `wsl --export` 时会提示路径不存在），然后执行：

```shell
wsl --export docker-desktop-data "G:\Docker\wsl\data\docker-desktop-data.tar"
```

`wsl` 命令会将 `docker-desktop-data` 的数据输出到指定路径中。其实这里的路径是任意路径也可以，真正指定新的镜像路径是在后面的注册命令中，此处为了演示方便将备份文件也输出到新的镜像路径中。

接下来要将原来的 `docker-desktop-data` 解除注册，注意执行解除注册命令后，`docker-desktop-data` 原来的数据文件会被删除，因此要恢复的话一定要提前按照前面的步骤备份数据文件。

```shell
wsl --unregister docker-desktop-data
```

最后重新注册 `docker-desktop-data`，指定它的路径为新路径，并将原来备份的文件恢复：

```shell
wsl --import docker-desktop-data "G:\Docker\wsl\data" "G:\Docker\wsl\data\docker-desktop-data.tar" --version 2
```

此处 `--version` 的值应该和前面 `wsl --list -v` 输出中对应 `VERSION` 列的值一致。恢复后原备份文件可删除。

执行完成后重新启动 Docker Desktop，Docker 的镜像路径已经更改到了新目录中。

注意不要重新注册 `docker-desktop`，重新注册的话会将 `docker-desktop-data` 的路径重新设置回默认目录中，因此只需要按照上面的步骤重新注册 `docker-desktop-data` 即可。
