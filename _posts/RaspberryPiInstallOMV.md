---
title: 树莓派 4B 搭建 NAS
date: 2020-02-29 22:22:22
img: "/images/OpenMediaVault.png"
top: 10
cover: fasle
coverImg: "/images/OpenMediaVault.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: 触类旁通
tags:
  - 树莓派
  - 工具
  - 折腾
keywords: 树莓派
summary: 树莓派刚出了新版 4B，感觉配置不错，就入手了一个玩玩~然而买回来之后一直在吃灰...赶紧拿出来耍耍~
---

树莓派刚出了新版 4B，感觉配置不错，就入手了一个玩玩\~然而买回来之后一直在吃灰...赶紧拿出来耍耍\~

<!--more-->

```shell
sudo apt-get install vlc-bin -y
sudo apt-get upgrade -y
sudo wget -O - https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/install | sudo bash
```

保持网络畅通, 耐心等待就好了(整个过程我用了一盘王者的时间)

安装完成后，打开浏览器，输入树莓派的 IP 地址访问。出现以下页面，及成功安装。

默认帐号密码

帐号：admin
密码：openmediavault

~~未完待续~~