---
title: 经典 Issues 集锦
date: 2017-03-15 15:15:15
categories: 
- 杀虫
- Java
tags: 
- bug
- 调试
- 错误
- 异常
- Issues
---

什么是经验？经验，就是遇到问题之后，你通过努力把它解决了，这就是你的经验！
- Java bugs
- MySQL bugs
- HTML bugs

<!-- more -->

在程序员的道路上，会遇到各种各样的问题和错误，我认为我不可能记住每一个问题的解决方式，好脑子不如烂笔头嘛，所以我要把我今后遇到的各种问题与错误都记录在这里～
## Java Issues
### An API baseline has not been set for the current workspace.	

Windows → Preferences → Plug-in Development → API Baselines
在 Options 里找到  Missing API baseline ，根据自己的情况改成 Warning 或者 Ignore，点击 Apply 应用即可。

>建议在[这里](http://www.ibm.com/developerworks/library/os-eclipse-api-tools/)研读一下 API baselines ，然后再决定这些 API baselines 是否对你有用。

<br/>
### java.lang.ClassNotFoundException: com.mysql.jdbc.Driver
**报错信息：**java.lang.ClassNotFoundException: com.mysql.jdbc.Driver...
**报错原因：**
1. 驱动类名称写错
2. 没有添加 jar 包
	1. 项目中没有添加 mysql-connector-java-x.x.xx-bin.jar 包
	2. Web 项目中添加了 mysql-connector-java-x.x.xx-bin.jar 包，但是在 Tomcat 安装目录的 lib 目录下没有该 jar 包

**解决方法:**
- 对于第一种原因仔细查找下改掉拼错的单词就行了，不多解释啦。
- 对于第二种报错原因的第一种情况，下载 mysql-connector-java-x.x.xx-bin.jar 添加进去就可以了，这里也不多说。
- 悲催的我遇到了另一种情况，已经将 mysql-connector-java-x.x.xx-bin.jar 包添加到项目中，测试数据库连接也是没有问题的，但是在 server 中运行时却报错...此时只要将相同的 jar 包复制一份到 Tomcat 安装目录中的 lib 文件夹中重启 Tomcat 服务器即可。

<br/>
## MySQL Issues
### #1089-incorrect prefix key
```MySQL
CREATE TABLE `table`.`users` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL,
    `password` VARCHAR(50) NOT NULL,
    `dir` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id`(11))
) ENGINE = MyISAM;
```
**报错信息：**#1089-incorrect prefix key;the used key part isn't a string,the used length is longer than the key part,or the storage engine doesn't support unique prefix keys.

**报错原因：**
- 在定义 PRIMARY KEY 时候使用了 `(id(11))`, 这定义了 prefix key —— 也就是主键前面的 11 个字符只能用来创建索引。prefix key 只支持 CHAR、VARCHAR、BINARY 和 VARBINARY 类型，而这里使用了 int 类型，所以报错了。翻译自 [stackoverflow](http://stackoverflow.com/questions/28932281/what-is-wrong-with-my-sql-here-1089-incorrect-prefix-key)。

**解决办法：**
- 将
```MySQL
PRIMARY KEY (`id`(11))
```
改为
```MySQL
PRIMARY KEY (`id`)
```

**参考：**[MySQL 官方文档](https://dev.mysql.com/doc/refman/5.5/en/create-index.html)

<br/>
## HTML Issues

<br/>
## Git
###
**错误提示：**You asked to pull from the remote 'master', but did not specify
a branch. Because this is not the default configured remote
for your current branch, you must specify a branch on the command line.

**报错原因：**你拉取指定名为 “master” 的远程仓库，但是该远程仓库没有指定分支。因为你当前的分支不是默认的远程仓库，所以必须要指定一个分支。

**解决办法：**
- 编辑项目下的 `.git/config` 文件，加入下面的代码：
```
[branch "master"]
  remote = origin
  merge = refs/heads/master
```

**参考：**[StackOverFlow](http://stackoverflow.com/questions/4847101/git-which-is-the-default-configured-remote-for-branch)