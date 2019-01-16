---
title: K2 最新版固件刷华硕老毛子
date: 2018-03-02 22:22:22
categories: Some Fun
tags:
- 路由器
- 科学上网
- 老毛子
- 刷机
---

去年通过斐讯 0 元购入手了 K2 路由器，用着还不错吧，前几天又通过 0 元购入手了 K3 路由器，然后 K2 就打算刷个能翻墙的系统玩了，就算刷成砖了也无所谓啦，反正是白给的，哈哈。

<!--more-->

## 需要的工具

- 斐讯 K2 路由器一台
- [斐讯 K2 V22.6.506.28 官方固件](https://pan.baidu.com/s/1slqkvF3) —— 2a2n
- [路由器刷 breed Web 控制台助手 v4.8 版本.7z](http://pan.baidu.com/s/1slym23j) —— 其中包括：
    - 路由器刷 breed Web 助手通用版 v4.8.exe —— 主程序
    - breed Web 懒人工具.exe —— 小白操作 breed 刷机工具（1.3 版本）
    - plink.exe —— telnet_ssh 终端
    - MyWebServer.exe —— HTTP 服务（用于架设 breed 本地服务器）
    - RoutAck.exe —— 坛友 phitools 开发的斐讯激活 Telnet 利器
- [breed Web 懒人工具 v1.4.7z](https://pan.baidu.com/s/1pNr9Soz)
- [RoutAckProV1B2.rar](https://pan.baidu.com/s/1c1FuPDA) —— 4egk
- 华硕老毛子 Padavan 固件 —— [官方最新版固件](https://eyun.baidu.com/s/3pLMbUqR)
    - 下载老毛子固件时应选择对应 K2 路由器型号的版本 —— 即包含 `PSG1218` 的固件
    - `RT-AC54U-GPIO-1-PSG1218-256M_x.x.x.x-xxx.trx`
    - `RT-AC54U-GPIO-1-PSG1218-64M_x.x.x.x-xxx.trx`

>写这篇文章时最新版固件为 `22.6.5.7.43`，所以需要降级才能刷机
>

<br/>
## 刷机

<font color="#dd3333">整个过程路由器都是联网状态（Wan 口），并且用网线连着路由器和电脑（随便一个 Lan 口）</font>

### 1.替换 breed Web 懒人工具版本

上面下载的 breed web 控制台助手 4.8 版本中所包含的 breed Web 懒人工具是 1.3 版本的，要把它换成最新版的

1. 解压 [路由器刷 breed Web 控制台助手 v4.8 版本.7z](http://pan.baidu.com/s/1slym23j)
1. 删除 `路由器刷 breed Web 控制台助手 v4.8 版本` 中的 `breed Web 懒人工具.exe`
1. 解压 [breed Web 懒人工具 v1.4.7z](https://pan.baidu.com/s/1pNr9Soz) 到 `路由器刷 breed Web 控制台助手 v4.8 版本` 中，全部覆盖
1. 将 `路由器刷 breed Web 控制台助手 v4.8` 中的 `breed Web 懒人工具 v1.4 版本.exe` 重命名为 `breed Web 懒人工具.exe`

<br/>
### 2.路由器固件降级

1. 登陆路由器管理界面（默认 192.168.2.1）> 打开功能管理 > 系统管理 > 手动升级
1. 选择 [斐讯 K2 V22.6.506.28 官方固件](https://pan.baidu.com/1slqkvF3) 进行降级，降级后会自动重启路由器
1. 再次登录路由器 > 打开功能管理 > 系统管理 > 备份恢复 > 恢复出厂设置，等待路由器重启完毕
1. 打开 `192.168.2.1` 快速设置路由器，管理员密码设置为 admin（只是为了方便）

>提示升级固件时请选择 否

<br/>
### 3.打开路由器 Telnet

1. 解压 [RoutAckProV1B2.rar](https://pan.baidu.com/s/1c1FuPDA)
1. 打开 `RoutAckProV1B2.exe`
1. 点击 `打开 Telnet` 按钮
1. 若打开失败，请重新执行[路由器降级的第 3、4 步操作](#2-路由器固件降级)后再次尝试

    ![打开 Telnet](http://wx3.sinaimg.cn/mw690/a6e9cb00ly1fozktyl9gbj20a308rt93.jpg)

<br/>
### 4.刷入 breed Web 控制台助手

1. 以管理员身份运行 `路由器刷 breed Web 控制台助手 v4.8 版本.exe`
1. 设置刷机方案为 `斐讯[K1/K2]自动 MTK 方案`，密码若没修改则默认即可
1. 点击 `开始刷机`

    ![刷入 breed Web 控制台助手](http://wx1.sinaimg.cn/mw690/a6e9cb00ly1fozkun2xd5j20bf0fmq3b.jpg)

<br/>
### 5.刷入固件

1. 上一步成功后会自动提示进入 `懒人刷固件` 模式，选择 `是`
1. 自动打开 `breed Web 懒人工具` 后选点击 `自选文件` 选择想要刷入的固件
    >我使用的是 3 月 2 日发布的 `RT-AC54U-GPIO-1-PSG1218-256M_3.4.3.9-099.trx`
1. 确认状态提示为<font color="#EE3333">未进入 breed Web 模式，正在探测 breed Web 模式中......</font>
    - 如果不是该状态，请勾选上面的 `自动探测...`
    ![刷入固件](http://wx1.sinaimg.cn/mw690/a6e9cb00ly1fozktywxyej20bz0bi74c.jpg)
1. 拔下路由器电源
1. 按住路由器背面的 `reset` 按钮不松手
1. 接通路由器电源，此时 `reset` 按钮在通电后继续按住 10 秒
1. `breed Web 懒人工具` 状态有变化后点击 `开始刷机`
1. 等待结束后就成功啦！

>注意此时路由器管理页面 ip 地址改为 `192.168.123.1` 了

<br/>
## 科学上网

根据自身情况设置 VPN 或者 ShadowSocks 即可

我用的是 ShadowSocks，配置如图：

![ShadowSocks 设置](http://wx3.sinaimg.cn/mw690/a6e9cb00ly1fozmout772j21k03744qp.jpg)

## 最终效果图

![最终效果](http://wx3.sinaimg.cn/mw690/a6e9cb00ly1fozml9if9dj21ho1fctog.jpg)