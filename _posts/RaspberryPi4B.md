---
title: 树莓派 4B：别让我吃灰~
date: 2020-02-29 22:22:22
categories: 触类旁通
tags:
- 折腾
---

树莓派刚出了新版 4B，感觉配置不错，就入手了一个玩玩~然而买回来之后一直在吃灰...赶紧拿出来耍耍~

<!-- more -->

## FRP 内网穿透

### 安装 FRP

不得不夸一下 frp, 太简练了, 做的太好了!

1. 到其 GitHub 的 [release](https://github.com/fatedier/frp/releases) 页面, 下载 相应操作系统及架构的安装压缩包.
   - 我的树莓派系统是官方推荐的 Raspbian, 即 32 位的 debian, CPU 是 ARM 架构, 所以下载的软件包是 [frp_0.31.2_linux_arm.tar.gz](https://github.com/fatedier/frp/releases/download/v0.31.2/frp_0.31.2_linux_arm.tar.gz)
   - 我的服务器系统是 64 位 CentOS 7,  所以下载的软件包是 [frp_0.31.2_linux_amd64.tar.gz](https://github.com/fatedier/frp/releases/download/v0.31.2/frp_0.31.2_linux_amd64.tar.gz)
2. 解压下载的软件包, 将其中的
   - frps 及 `frps.ini` 文件放到具有公网IP的机器上,
   - frpc 及 `frpc.ini` 文件放到处于内网环境的机器上(即我的树莓派上).

只要 2 个文件放在相同目录下, 放在什么位置都行, 当然建立个 frp 目录存放更好.

至此, 安装完成!

> 这里不得不吐槽一下, GitHub 下载实在是太慢了!!! 建议服务器端直接从服务器去下载...

### FRP 配置

配置是通过编辑ini文件实现. 下面分别说明服务器和客户端的配置.

由于有多个二级域名，可以用多个二级域名的 A 记录同时指向外网 VPS 地址

- jenkins.skywind.com -> 202.115.8.1
- gitlab.skywind.com -> 202.115.8.1

配置两个二级域名都指向 VPS 外网地址，对于多个 http/https 转发，在 frps 那里都可以共用同一个端口

#### 服务端 FRPS 配置:

```bash
# frps.ini
[common]
bind_port = 7000
token = 1234567
vhost_http_port = 80
vhost_https_port = 443
dashboard_port = 7500
dashboard_user = root
dashboard_pwd = *****
```

- `bind_port` 指定了 frp 服务端端口
- `vhost_http_port` 指定了 http 服务的端口, 通过访问服务器此端口就可访问到内网中提供的 web 服务
- 服务器端 frp 提供了 `dashboard` 功能, 可监控 frp 的工作状态, 挺好用的. 端口号可指定, 登陆用户名和密码也在这里配置. `dashboard` 的配置只出现在服务器端, 和客户端没有关系.
- `token` 提供身份验证功能, 服务端和客户端的 `common` 配置中的 `token` 参数一致则身份验证通过

> 用了一堆端口，别忘了设置防火墙哟
> CentOS 7 使用 firewall-cmd 设置防火墙，这里不赘述了

#### 内网 FRPC 配置

```bash
# frpc.ini
[common]
admin_addr = 127.0.0.1
admin_port = 7400
server_addr = 202.115.8.1 
server_port = 7000 
token = 1234567

[jenkins]
type = https
local_ip = 127.0.0.1
local_port = 888
custom_domains = jenkins.skywind.com

[gitlab]
type = https
local_ip = 127.0.0.1
local_port = 666
custom_domains = gitlab.skywind.com

# 反向代理 ssh
[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000

# 反向代理数据库
[mysql]
type = tcp
local_ip = 127.0.0.1
local_port = 3306
remote_port = 1006
```

- `common` 中的 `server_addr` 指定了服务器的 IP 地址.
- `common 中的 `server_port` 必须和服务器端的 `bind_port` 参数一致.
- `token` 也要一致, 就不赘述了.
- `ssh` 中的 `local_port` 指定了客户端本机的 ssh 服务端口
- `ssh` 中的 `remote_port`, 外网可通过访问服务器的此端口来访问客户端的 `local_port` 端口(上一个参数).
- `gitlab` 和 `jenkins` 中的 `local_ip` 为内网某台需要对外开放 web 服务的设备 ip 地址，由于我这两个服务都在树莓派的 docker 里，所以 ip 一样.
- `gitlab` 和 `jenkins` 中的 `local_port`, 即内网对外开放的 web 服务端口. 外网访问服务器的 `vhost_http_port` 端口(见服务器端配置)时, 被映射到内网客户端的此端口, 达到暴漏内网 web 服务的目的.
- `gitlab` 和 `jenkins` 中的 `custom_domains` 指定了服务器的域名.

所以, 整个域名端口映射过程为:

- `jenkins.skywind.com` <---> `202.115.8.1` <---> `树莓派内 docker 容器:888`
- `gitlab.skywind.com`  <---> `202.115.8.1` <---> `树莓派内 docker 容器:666`
- `202.115.8.1:6000`  <--->  `树莓派 SSH 端口:22`
- `202.115.8.1:1006`  <--->  `树莓派 mysql 端口:3306`

> 同样，开了很多端口，如果开了防火墙，记得设置[开启端口(见下文: 防火墙规则设置)](#防火墙规则设置)

#### 服务器端运行

启动运行很简单, 在 `frps` 文件所在目录下, 运行如下指令:

```bash
./frps -c ./frps.ini
```

我的服务器端没搞自动运行, 反正服务器难得启动一次.

搞个后台运行就行了, 我使用的 `screen`, 也可以用 `nohup`

#### 客户端运行

客户端启动运行, 和服务器端类似, 在 `frpc` 所在目录下, 运行如下指令:

```bash
./frpc -c ./frpc.ini
```

由于树莓派的掉电不可避免, 还是搞个开机自启动比较好.

编辑 `/etc/rc.local` 文件, 在其最后一行 `exit 0` 之前, 插入如下 2 行:

```bash
/bin/sleep 60
sudo /root/frp/frpc -c /root/frp/frpc.ini &
```

我的 `frpc` 文件所在位置是 root 用户下的 frp 目录下, 在 `/etc/rc.local` 文件中, 要使用绝对路径, `&` 也必须带上.

另外, 我在 `frpc` 运行前, 加了 60 秒的延时, 不加这个延时自启动就会失败...

### 参考链接

[FRP 官方中文文档](https://github.com/fatedier/frp/blob/master/README_zh.md)

## 安装 MariaDB 数据库

### 安装及登录

```bash
sudo apt install mariadb-server # 安装
sudo mysql_secure_installation # 设置 root 密码
sudo mysql -u root -p # 登陆
```
### 查看与修改用户登录权限

```mariadb
select User, host from mysql.user;
```

修改用户权限。%表示针对所有IP，password表示将用这个密码登录root用户，如果想只让某个IP段的主机连接，可以修改为

```mariadb
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
```

修改立即生效

```mariadb
FLUSH PRIVILEGES;
```

```bash
service mysql restart # 重启 mysql
```

## 安装 Jenkins

先安装 JDK 和 Maven

```bash
apt-get install openjdk-8-jdk
apt-get install maven
```

安装 Jenkins

```bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add
```
编辑 `/etc/apt/sources.list` 文件在结尾添加一行：
```bash
deb https://pkg.jenkins.io/debian-stable binary/
```

```bash
apt-get update
apt-get install jenkins
sudo ufw allow 8080 # 开启 8080 端口
sudo /etc/init.d/jenkins start # 启动 jenkins
cat /var/lib/jenkins/secrets/initialAdminPassword # 查看 Jenkins 初始密码
```

## 树莓派 4B 的一些相关配置

由于树莓派的系统架构是 arm 的, 所以很多东西可能跟平时常用的 Linux 有些区别

### 防火墙规则设置

树莓派使用的防火墙与 Ubuntu 一样, 也是 `ufw`. `ufw` 是一个主机端的 `iptables` 类防火墙配置工具，比较容易上手。如果你有一台暴露在外网的树莓派，则可通过这个简单的配置提升安全性。
注意开启常用的默认端口 ssh 端口 22，ftp 端口 20, 21, vnc 端口 1.

#### 推荐设置  
```bash
sudo apt-get install ufw # 安装防火墙
sudo ufw enable # 启用防火墙
sudo ufw default deny # 默认 关闭所有端口，拒绝所有外部对本机的访问（本机访问外部正常）
```

>这样设置已经很安全，如果有特殊需要，可以使用 `sudo ufw allow` 开启相应服务
 
#### 常用命令

1. `sudo ufw disable` 关闭
2. `sudo ufw status` 查看防火墙状态
3. `sudo ufw allow 80` # 允许外部访问 80 端口
4. `sudo ufw delete allow 80` # 禁止外部访问 80 端口
5. `sudo ufw allow from 192.168.1.1` # 允许此IP访问所有的本机端口
6. `sudo ufw deny smtp` # 禁止外部访问 smtp 服务
7. `sudo ufw delete allow smtp` # 删除上面建立的某条规则
8. `sudo ufw deny proto tcp from 10.0.0.0/8 to 192.168.0.1 port` # 要拒绝所有的流量从 TCP 的 10.0.0.0/8 到端口 22 的地址 192.168.0.1
9. sudo ufw allow from 10.0.0.0/8 # 可以允许所有 RFC1918 网络（局域网/无线局域网的）访问这个主机（/8,/16,/12是一种网络分级)
10. sudo ufw allow from 172.16.0.0/12
11. sudo ufw allow from 192.168.0.0/16
配置允许的端口范围 
12. `sudo ufw allow 6000:6007/tcp`
13. `sudo ufw allow 6000:6007/udp`

