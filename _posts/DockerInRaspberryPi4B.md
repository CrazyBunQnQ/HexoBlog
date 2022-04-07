---
title: 树莓派安装 Docker 与持续集成~
date: 2020-03-30 22:22:22
img: "/images/RaspberryPi 4B.jpg"
top: 10
cover: false
coverImg: "/images/RaspberryPi 4B.jpg"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: 触类旁通
tags:
  - 树莓派
  - 容器
keywords: 树莓派
summary: 树莓派刚出了新版 4B，感觉配置不错，就入手了一个玩玩~然而买回来之后一直在吃灰...赶紧拿出来耍耍~
---

树莓派 4B 的性能还是很好的，又入手了 8G 版的 4B，性能真么好，当然要好好利用啦！Docker 走起！

<!--more-->

## 安装 Docker

直接用一键安装脚本，走你！

```shell
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# 启动服务
sudo systemctl enable docker
# 启动 docker
sudo systemctl start docker
```

开启 docker api 端口

```shell
vim /lib/systemd/system/docker.service
# 将 ExecStart 配置改为:
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
```

## Jenkins 持续集成

### 拉取和启动 Jenkins 镜像

拉取镜像并跑起来, 树莓派是 `ARM` 架构的，这里我搭好了一个包含 `Maven 3.6.3` 和 `Oracle JDK8 2.242` 的 `Jenkins` 镜像

```shell
docker pull crazybun/arm-jenkins-jdk8:2.242
docker run --name jenkins -u root -d -t -i -v ~/docker_volumes/Jenkins/var/jenkins_home:/var/jenkins_home -v /run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker -p 8080:8080 --restart always crazybun/arm-jenkins-jdk8:2.242
```

初始化 Jenkins 省略，百毒一大堆...

## 配置 Jenkins 持续集成

### General

#### 丢弃旧的构建

- 保持构建的天数 7
- 保持构建的最大个数 5

### 源码管理 Git

- Repository URL
- Credentials
- Branches to build: `*/baozi`

### 构建触发器

- GitHub hook trigger for GITScm polling

### 构建

#### 调用顶层 Maven 目标

- Maven 版本: 非默认
- 目标:`-Dfile.encoding=UTF-8 -DskipTests=true clean package`

#### 执行 shell

```shell
# 定义变量
API_NAME="ruoyi"
API_PORT="80"
IMAGE_NAME="crazybun/$API_NAME:$BUILD_NUMBER"
CONTAINER_NAME=$API_NAME

# 进入target目录并复制Dockerfile文件
cd $WORKSPACE/docker

# 构建Docker镜像
docker build -t $IMAGE_NAME .

# 推送Docker镜像
#docker push $IMAGE_NAME

# 删除Docker容器
cid=$(docker ps | grep $CONTAINER_NAME |awk '{print $1}')
if [ x"$cid" != x ]
    then
    docker rm -f $cid
fi

# 启动Docker容器
docker run -itd --name $CONTAINER_NAME -v /root/logs/docker-logs/ruoyi:/RuoYi/logs -p $API_PORT:80 --restart always $IMAGE_NAME

# 删除Dockerfile文件
# rm -f Dockerfile
```

### 构建后操作

- E-mail: `crazybunqnq@gmail.com baobao222222@qq.com` 

### 大功告成

提交个代码/或 git hook 测试下能否正常构建，成功~再也不用在构建部署上费时间了，专注开发 100 年！