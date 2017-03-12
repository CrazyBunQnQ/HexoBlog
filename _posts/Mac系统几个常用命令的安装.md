---
title: Mac系统几个常用命令的安装
date: 2017-03-11 22:17:16
categories: 触类旁通
tags: 
- 命令行
- 终端
---

用过 Linux 的大概都觉着没有 wget 的日子是非常难过的，很多程序的安装和更新都可以用一行命令解决，下面介绍 Mac 系统中 wget 命令以及另外几个常用的命令安装方式。

<!-- more -->

# curl 命令
>这个命令 Mac 系统自带的，不用安装。

# brew 命令
全称：[Homebrew][1]，安装很简单，只需要打开终端窗口，粘贴以下命令回车即可：

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    
>啊！这是最容易安装的一个命令了！简直不能再轻松！


# wget 命令
没有 wget 的日子是非常难过的，用了好几种办法安装 wget 都不好使，实践证明使用 brew 命令轻松搞定！

    brew install wget --with-libressl

>我不会告诉你我是为了安装 wget 才安装了 Homebrew 的……

# port 命令
全称：[MacPorts][2],安的我头都大了……

**1. 需要先安装 Xcode 和 Xcode Command Line Tools**

**2. 还要通过在终端中输入下面的命令同意 Xcode 许可：**

    sudo xcodebuild -license

**3. 利用 wget 命令输入下面的命令安装 2.4.1 版本的 MacPorts：**

    wget http://distfiles.macports.org/MacPorts/MacPorts-2.4.1.tar.gz
    tar zxvf MacPorts-2.4.1.tar.gz
    cd MacPorts-2.4.1
    ./configure
    make
    sudo make install
    
**4. 安装成功后返回上级目录，删除 MacPorts2.4.1 文件和安装包：**

    cd ../
    rm -rf MacPorts-2.4.1*    
    
**5. 编辑 `/etc/profile` 文件，将 `/opt/local/bin` 和 `opt/local/sbin` 添加到 $PATH 搜索路径中：**

    export PATH="/opt/local/bin:$PATH"
    export PATH="/opt/local/sbin:$PATH"

>不知道是不是我脸黑，使用了各种安装包都安装失败 orz……


# aircrack-ng 命令

只需要利用 port 命令在终端中输入下面的命令即可安装：

    sudo port install aircrack-ng

[1]: https://brew.sh/index_zh-cn.html
[2]: https://www.macports.org/install.php