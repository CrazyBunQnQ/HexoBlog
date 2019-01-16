---
title: IDEA 2018.2 及 Mybatis Plugin 破解
date: 2018-10-05 22:22:22
categories: 工具
tags:
- IDEA
- Mybatis
---

在 IntelliJ IDEA 中有一个强大的 Mybatis 收费插件 —— MyBatis Plugin.
这篇文章要做的就是...破解它...

>经济条件允许的话推荐使用正版...

<!-- more -->

## 破解步骤
### 一、[下载插件](https://github.com/LeeWiHong/WiHongNoteBook/tree/master/JAVA/jar%E5%8C%85)

- MyBatis plugin 3.58: MyBatis plugin 插件
- ideaagent-1.2.jar: 用来破解 MyBatis plugin 3.58 插件
- JetbrainsCrack-3.1-release-enc.jar: 用来破解 IDEA 2018.2

### 二、离线安装插件

![](http://wx2.sinaimg.cn/large/a6e9cb00ly1fxdgznqhyuj21c40u01h6.jpg)

### 三、修改 `idea.vmoptions`

- Windows: 直接用 Everything 搜吧，有几个改几个
- Mac: 直接 vim 编辑

    ```bash
    vim /Applications/IntelliJ\ IDEA.app/Contents/bin/idea.vmoptions
    vim ~/Library/Preferences/IntelliJIdea2018.2/idea.vmoptions
    ```
- 在最后添加下面两行代码 (路径改成你自己的并赋予读写权限)

    ```conf
    -javaagent:~/Tools/MyBatisCrack/ideaagent-1.2.jar
    -javaagent:~/Tools/MyBatisCrack/JetbrainsCrack-3.1-release-enc.jar
    ```
    ![修改 idea.vmoptions](http://wx2.sinaimg.cn/large/a6e9cb00ly1fxdbf013orj20ru0jqadk.jpg)

### 四、启动 IDEA

启动后会提示激活

复制粘贴下面的激活信息到激活码并将名称改为你喜欢的名称

```json
{"licenseId":"1337",
"licenseeName":"Your Name",
"assigneeName":"",
"assigneeEmail":"",
"licenseRestriction":"Unlimited license till end of the century.",
"checkConcurrentUse":false,
"products":[
{"code":"II","paidUpTo":"2099-12-31"},
{"code":"DM","paidUpTo":"2099-12-31"},
{"code":"AC","paidUpTo":"2099-12-31"},
{"code":"RS0","paidUpTo":"2099-12-31"},
{"code":"WS","paidUpTo":"2099-12-31"},
{"code":"DPN","paidUpTo":"2099-12-31"},
{"code":"RC","paidUpTo":"2099-12-31"},
{"code":"PS","paidUpTo":"2099-12-31"},
{"code":"DC","paidUpTo":"2099-12-31"},
{"code":"RM","paidUpTo":"2099-12-31"},
{"code":"CL","paidUpTo":"2099-12-31"},
{"code":"PC","paidUpTo":"2099-12-31"},
{"code":"DB","paidUpTo":"2099-12-31"},
{"code":"GO","paidUpTo":"2099-12-31"},
{"code":"RD","paidUpTo":"2099-12-31"}
],
"hash":"2911276/0",
"gracePeriodDays":7,
"autoProlongated":false}
```
![](http://wx4.sinaimg.cn/large/a6e9cb00ly1fxdgpbd4hij20rs0o9470.jpg)

## 问题

1. 提示 **Key is invalid**
    1. 删除电脑中所有旧版 IDEA 配置

        ![](http://wx1.sinaimg.cn/large/a6e9cb00ly1fxdgvpw8drj20rs0cg7bi.jpg)

1. 启动时卡死在初始化界面
    - 检查是否所有 `idea.vmoptions` 文件最后都添加那两行代码了
2. 启动后没提示激活
    - 删除原有的 `idea.key` 后重新启动 IDEA