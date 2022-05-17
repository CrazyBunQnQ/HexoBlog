---
title: MacOS 使用 Easyconnect 远程桌面无法全屏显示
date: 2022-06-17 22:22:22
img: "/images/MacOSEasyconnectRemoteDesktop.png"
cover: false
coverImg: "/images/MacOSEasyconnectRemoteDesktop.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: 触类旁通
tags:
- Easyconnect
- 远程桌面
- 全屏
keywords: Easyconnect
summary: 疫情原因，需要远程办公，但是办公环境涉密，不能连外网，所以要用**指定版本**的 Easyconnect 软件连接远程桌面进行远程办公，然后，使用 Mac 客户端的我就出现了神器的界面...
---

疫情原因，需要远程办公，但是办公环境涉密，不能连外网，所以要用**指定版本**的 Easyconnect 软件连接远程桌面进行远程办公，然后，使用 Mac 客户端的我就出现了神器的界面...

![img_1.png](../images/MacOSEasyconnectRemoteDesktop.png)

偌大一个屏幕，远程界面只显示四分之一，这还没完，你看到的鼠标位置是相对于全屏的鼠标位置，而鼠标实际操作位置则是相对于全屏位置等比映射到小屏幕上...

就比如我要双击回收站图标，鼠标直接过去点，点不到的！要把鼠标挪到红色背景左上角，靠下一点的位置才能点到那个回收站！

我太难了...

在 Easyconnect 官方社区查到如下[资料](https://bbs.sangfor.com.cn/forum.php?mod=viewthread&tid=161747):

> 当前问题是 2021 年 11 月 3 日 mac 客户端更新后出现的，这次更新中没有更新远程应用功能，并且未修改远程相关代码，初步判断是跟编译有关系，可以重装我们对应修复此问题的 Easyconnect 客户端解决

文中有修复问题的版本下载链接，但是各单位远程连接服务会校验 Easyconnect 客户端的版本, 使用文中的安装包不一定好使

若按照文中的安装包仍然不好使，可参考下面的步骤进行解决

1. 在[该页面](https://bbs.sangfor.com.cn/forum.php?mod=viewthread&tid=161747)下载对应的修复版本包，下载后解压备用
2. 查看公司提供的 Easyconnect 版本信息
   1. 安装单位 vpn 服务提供的客户端
   2. 打开终端执行下面的命令查看版本信息
       ```shell
       cat /Applications/EasyConnect.app/Contents/Resources/conf/Version.xml
       ```
   3. 打开第 `1` 步解压后的 `Version.xml` 文件，将上一步输出的内容覆盖粘贴进去，保存退出
3. 卸载公司提供的 Easyconnect 客户端
4. 安装第 `1` 步解压出来的 `dmg` 文件
5. 安装完成后双击第 `1` 步解压出来的 `version` 程序

此时，无法全屏的问题得到解决，并且客户端也能过通过公司的版本校验了...
