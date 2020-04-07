---
title: VM 虚拟机(CentOS)搭建 Dubbo、Zookeeper 分布式环境
date: 2018-11-11 11:11:11
categories: 分布式
tags: 
- 微服务
- Dubbo
- Zookeeper
- CentOS
---

本文记录了我从 VM 安装 CentOS 7 开始到完成 Dubbo 2.6.5 管控台的安装。

<!-- more -->

## VM 安装 CentOS 7.6

作为服务器用，所以不需要安装图形界面：[安装 CentOS 7 字符界面](https://blog.csdn.net/qq_18297675/article/details/52563819)

[设置虚拟机静态 ip](https://www.linuxidc.com/Linux/2017-06/144401.htm)

## 运行环境及工具

### [JDK-1.8](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)



```bash
# 将下载好的 JDK 传到服务器上(scp 命令)，解压
tar -xvf jdk-8u191-linux-x64.tar.gz
# 添加环境变量
export JAVA_HOME=/usr/local/jdk1.8.0_191
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
# 检验是否成功
java -version
```

### [Maven-3.6](http://maven.apache.org/download.cgi)

```
# 下载
wget -c http://mirrors.hust.edu.cn/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
# 解压
tar zxvf apache-maven-3.6.0-bin.tar.gz
# 添加环境变量
vim /etc/profile
环境变量中添加如下内容
export M2_HOME=~/apache-maven-3.6.0
export MAVEN_OPTS=-Xms256m
export PATH=$PATH:$M2_HOME/bin
# 生效
source /etc/profile
# 查看 mvn 版本
mvn -v
```

### Git

默认居然安装的是 1.8 的，算了，只是为了下源码而已...用户都不用设置了...

```bash
yum install git
```

### [Tomcat-7.0.92](https://tomcat.apache.org/download-70.cgi)

```bash
# 下载最新版 Tomcat 7
wget -c http://mirror.bit.edu.cn/apache/tomcat/tomcat-7/v7.0.92/bin/apache-tomcat-7.0.92.tar.gz
# 解压 Tomcat
tar -zxvf apache-tomcat-7.0.57.tar.gz
# 重命名为 dubbo-admin-tomcat
mv apache-tomcat-7.0.57 dubbo-admin-tomcat
# 移除 Tomcat webapps 目录下的所有文件
cd dubbo-admin-tomcat/webapps
rm -rf * 
```

### Screen

```bash
yum install screen
# 创建会话
screen
screen -S dubbo
# 暂时离开会话 Ctrl+a d
# 查看已开启的会话
screen -ls
# 连接现有会话
screen -r 3528
screen -r dubbo
# 关闭对话
exit
```

## 安装 Zookeeper

[官网](http://Zookeeper.apache.org/) [下载地址](http://mirrors.hust.edu.cn/apache/Zookeeper/)

### 1.下载解压 Zookeeper

```bash
wget -c http://mirrors.hust.edu.cn/apache/Zookeeper/Zookeeper-3.4.13/Zookeeper-3.4.13.tar.gz
tar -zxvf Zookeeper-3.4.13.tar.gz
```

### 2.创建数据和日志文件夹

```bash
cd Zookeeper-3.4.13
mkdir data
mkdir logs
```
### 3.修改配置

```bash
# 拷贝一份 zoo_sample.cfg，命名为 zoo.cfg
cd conf
cp zoo_sample.cfg zoo.cfg
# 修改 zoo.cfg 配置文件
vi zoo.cfg
```

修改/添加数据/日志路径

```cfg
dataDir=/usr/local/Zookeeper/data
dataLogDir=/usr/local/Zookeeper/logs
# 配置服务器，下面的 ip 也可以用 hosts 别名 Zookeeper-01
server.1=192.168.2.156:2888:3888
server.2=192.168.2.157:2888:3888
```

### 4.创建 myid 文件

在前面创建的 data 目录下创建 myid 并写入对应的 ip 的机器的编号（上面的 server.1）中的 1

```bash
vi myid
1
```

>[参数说明](#Zookeeper%20 参数说明)

### 5.配置环境变量

在 `/etc/profile` 中添加环境变量

```bash
#Zookeeper env
export Zookeeper_HOME=~/Zookeeper-3.4.13
export PATH=$Zookeeper_HOME/bin:$PATH
```

### 启动 Zookeeper

```bash
# 启动 Zookeeper 服务
zkServer.sh start
# 查看状态
zkServer.sh status
# 停止服务
zkServer.sh stop
```

### 设置开机启动

```bash
# centOS 7 中 /etc/rc.d/rc.local 的权限被降低了，所以需要赋予执行权限
chmod +x /etc/rc.d/rc.local
# 编辑开机启动命令
vi /etc/rc.local
# 添加启动脚本
su - root -c '~/zookeeper-3.4.13/bin/zkServer.sh start'
```

## 安装 Dubbo 管控台

Dubbo 2.6.x 的 `dubbo-admin` 管理平台已经经过重构， 改成使用 spring boot 实现了，之前下载源码后使用 `mvn clean package -Dmaven.test.skip=true` 编译打包后会得到一个 war 包，将这个 war 包扔到 Tomcat 应用目录下，配置好 Zookeeper 后，启动 Tomcat 就安装成功了。而现在改成了 spring boot 实现之后，安装方式有很大不同。

```bash
# 下载源码
git https://github.com/apache/incubator-dubbo-ops.git
# 进入目录
cd incubator-dubbo-ops/
# 查看分支
git branch -a
# 切换为 master 分支
git checkout -b master origin/master
# 查看本地分支
git branch
# 进入 incubator-dubbo-ops 目录打包
# PS：第一次时间较长，我用时 24 分钟
mvn clean package -Dmaven.test.skip=true
# 进入 incubator-dubbo-ops/dubbo-admin 目录
mvn spring-boot:run
```

## 6.开启上述端口

```bash
# 开启 Zookeeper 端口
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=2181/tcp --permanent
firewall-cmd --zone=public --add-port=2888/tcp --permanent
firewall-cmd --zone=public --add-port=3888/tcp --permanent
# 开启 Dubbo 管控台端口
firewall-cmd --zone=public --add-port=7001/tcp --permanent
firewall-cmd --zone=public --add-port=20880/tcp --permanent
# 重新加载防火墙
firewall-cmd --reload
# 查看开启的端口
firewall-cmd --zone=public --list-ports
```

打开 dubbo 管理控制台：http://localhost:7001/ 

## Zookeeper 参数说明

|                       参数名                        |                                                                                                                                                                                               说明                                                                                                                                                                                               |
|                                                    |                                                                                                                                                                                                                                                                                                                                                                                                 |
|:--------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
|                     clientPort                     |                                                                                                                                                                     客户端连接 server 的端口，即对外服务端口，一般设置为 2181 吧                                                                                                                                                                      |
|                      tickTime                      |                                                                                                                                    Zookeeper 中的一个时间单元。Zookeeper 中所有时间都是以这个时间单元为基础，进行整数倍配置的。例如，session 的最小超时时间是 2*tickTime                                                                                                                                    |
|                      dataDir                       |                                                                                                                                    存储快照文件 snapshot 的目录。默认情况下，事务日志也会存储在这里。建议同时配置参数 dataLogDir, 事务日志的写性能直接影响 Zookeeper 性能                                                                                                                                    |
|                     dataLogDir                     |                                                                                                                                                       事务日志输出目录。尽量给事务日志的输出配置单独的磁盘或是挂载点，这将极大的提升 Zookeeper 性能                                                                                                                                                       |
|               globalOutstandingLimit               |                                                                最大请求堆积数。默认是 1000。Zookeeper 运行的时候， 尽管 server 已经没有空闲来处理更多的客户端请求了，但是还是允许客户端将请求提交到服务器上来，以提高吞吐性能。当然，为了防止 Server 内存溢出，这个请求堆积数还是需要限制下的。(Java system property: Zookeeper.globalOutstandingLimit.)                                                                |
|                    preAllocSize                    |                                                                                                                                     预先开辟磁盘空间，用于后续写入事务日志。默认是 64M，每个事务日志大小就是 64M。如果 Zookeeper 的快照频率较大的话，建议适当减小这个参数                                                                                                                                      |
|                     snapCount                      |                                                              每进行 snapCount 次事务日志输出后，触发一次快照(snapshot), 此时，Zookeeper 会生成一个 snapshot. 文件，同时创建一个新的事务日志文件 log。默认是 100000.（真正的代码实现中，会进行一定的随机数处理，以避免所有服务器在同一时间进行快照而影响性能）(Java system property: Zookeeper.snapCount)                                                               |
|                     traceFile                      |                                                                                                                                     用于记录所有请求的 log，一般调试过程中可以使用，但是生产环境不建议使用，会严重影响性能。(Java system property:? requestTraceFile)                                                                                                                                      |
|                   maxClientCnxns                   | 单个客户端与单台服务器之间的连接数的限制，是 ip 级别的，默认是 60，如果设置为 0，那么表明不作任何限制。请注意这个限制的使用范围，仅仅是单台客户端机器与单台 Zookeeper 服务器之间的连接数限制，不是针对指定客户端 IP，也不是 Zookeeper 集群的连接数限制，也不是单台 Zookeeper 对所有客户端的连接数限制。指定客户端 IP 的限制策略，这里有一个 patch，可以尝试一下：http://rdc.taobao.com/team/jm/archives/1334（No Java system property） |
|                 clientPortAddress                  |                                                                                                                                             对于多网卡的机器，可以为每个 IP 指定不同的监听端口。默认情况是所有 IP 都监听 clientPort 指定的端口。 New in 3.3.0                                                                                                                                             |
|         minSessionTimeoutmaxSessionTimeout         |                                                                                                                 Session 超时时间限制，如果客户端设置的超时时间不在这个范围，那么会被强制设置为最大或最小时间。默认的 Session 超时时间是在 2 * tickTime ~ 20 * tickTime 这个范围 New in 3.3.0                                                                                                                  |
|              fsync.warningthresholdms              |                                                                                                                       事务日志输出时，如果调用 fsync 方法超过指定的超时时间，那么会在日志中输出警告信息。默认是 1000ms。(Java system property: fsync.warningthresholdms)New in 3.3.4                                                                                                                       |
|              autopurge.purgeInterval               |                                                                                           在上文中已经提到，3.4.0 及之后版本，Zookeeper 提供了自动清理事务日志和快照文件的功能，这个参数指定了清理频率，单位是小时，需要配置一个 1 或更大的整数，默认是 0，表示不开启自动清理功能。(No Java system property) New in 3.4.0                                                                                            |
|             autopurge.snapRetainCount              |                                                                                                                                          这个参数和上面的参数搭配使用，这个参数指定了需要保留的文件数目。默认是保留 3 个。(No Java system property) New in 3.4.0                                                                                                                                          |
|                    electionAlg                     |                                                                                         在之前的版本中， 这个参数配置是允许我们选择 leader 选举算法，但是由于在以后的版本中，只会留下一种 “TCP-based version of fast leader election” 算法，所以这个参数目前看来没有用了，这里也不详细展开说了。(No Java system property)                                                                                         |
|                     initLimit                      |                                      Follower 在启动过程中，会从 Leader 同步所有最新数据，然后确定自己能够对外服务的起始状态。Leader 允许 F 在 initLimit 时间内完成这个工作。通常情况下，我们不用太在意这个参数的设置。如果 Zookeeper 集群的数据量确实很大了，F 在启动的时候，从 Leader 上同步数据的时间也会相应变长，因此在这种情况下，有必要适当调大这个参数了。(No Java system property)                                       |
|                     syncLimit                      |                                                                 在运行过程中，Leader 负责与 Zookeeper 集群中所有机器进行通信，例如通过一些心跳检测机制，来检测机器的存活状态。如果 L 发出心跳包在 syncLimit 之后，还没有从 F 那里收到响应，那么就认为这个 F 已经不在线了。注意：不要把这个参数设置得过大，否则可能会掩盖一些问题。(No Java system property)                                                                 |
|                    leaderServes                    |                                                                                            默认情况下，Leader 是会接受客户端连接，并提供正常的读写服务。但是，如果你想让 Leader 专注于集群中机器的协调，那么可以将这个参数设置为 no，这样一来，会大大提高写操作的性能。(Java system property: Zookeeper. leaderServes)                                                                                             |
|         server.x=[hostname]:nnnnn[:nnnnn]          |                                                                                                           这里的 x 是一个数字，与 myid 文件中的 id 是一致的。右边可以配置两个端口，第一个端口用于 F 和 L 之间的数据同步和其它通信，第二个端口用于 Leader 选举过程中投票通信。(No Java system property)                                                                                                           |
|        group.x=nnnnn[:nnnnn]weight.x=nnnnn         |                                                                                                                                                                    对机器分组和权重设置，可以 参见这里(No Java system property)                                                                                                                                                                     |
|                     cnxTimeout                     |                                                                                                                                                  Leader 选举过程中，打开一次连接的超时时间，默认是 5s。(Java system property: Zookeeper. cnxTimeout)                                                                                                                                                  |
| Zookeeper.DigestAuthenticationProvider.superDigest |                                                                                                                                                    Zookeeper 权限设置相关，具体参见《使用 super 身份对有权限的节点进行操作 》和 《Zookeeper 权限控制》                                                                                                                                                    |
|                      skipACL                       |                                                                                                                              对所有客户端请求都不作 ACL 检查。如果之前节点上设置有权限限制，一旦服务器上打开这个开头，那么也将失效。(Java system property: Zookeeper.skipACL)                                                                                                                               |
|                     forceSync                      |                                                                                                                                  这个参数确定了是否需要在事务日志提交的时候调用 FileChannel.force 来保证数据完全同步到磁盘。(Java system property: Zookeeper.forceSync)                                                                                                                                  |
|                   jute.maxbuffer                   |                                                                                                                                      每个节点最大数据量，是默认是 1M。这个限制必须在 server 和 client 端都进行设置才会生效。(Java system property: jute.maxbuffer)                                                                                                                                       |
