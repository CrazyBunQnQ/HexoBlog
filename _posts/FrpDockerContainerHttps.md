---
title: 使用 FRP 内网穿透支持 Docker 容器 HTTPS 访问
date: 2022-03-10 00:22:22
img: "/images/RaspberryPi 4B.jpg"
top: 10
cover: false
coverImg: "/images/RaspberryPi 4B.jpg"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: 触类旁通
tags:
- FRP
- 内网穿透
- HTTPS
keywords: HTTPS
summary: 之前在树莓派上搭了 FRP 内网穿透，并且将博客系统部署在其中一台设备的一个 Docker 容器中，导致原先直接部署到服务器中的博客系统现在不支持 HTTPS 访问了. 最近心血来潮搞一下，支持一下 HTTPS 访问，不再显示`不安全`啦！
---


## 创建证书

这里我们通过 [CertBot](https://certbot.eff.org/) 从 [Let’s Encrypt](https://letsencrypt.org/zh-cn/getting-started/) 自动生成证书

在 [CertBot](https://certbot.eff.org/) 主页选择网页应用及操作系统后按照其操作步骤执行即可生成对应的证书:

> 以下命令在宿主机中执行的，尝试过在容器中执行，但是失败了

```shell
$ sudo apt install snapd
$ sudo snap install core; sudo snap refresh core
$ sudo snap install --classic certbot
$ sudo ln -s /snap/bin/certbot /usr/bin/certbot
$ sudo certbot --nginx
```

这里报错了，提示没有安装 `nginx`，安装 nginx

```shell
$ sudo apt update && sudo apt install nginx -y
```

80 端口占用，安装 nginx 后无法启动, 关闭占用端口的应用(服务所在容器)后重试

```shell
$ sudo certbot --nginx
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Enter email address (used for urgent renewal and security notices)
(Enter 'c' to cancel): 输入你的邮箱

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. You must
agree in order to register with the ACME server. Do you agree?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: y

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing, once your first certificate is successfully issued, to
share your email address with the Electronic Frontier Foundation, a founding
partner of the Let's Encrypt project and the non-profit organization that
develops Certbot? We'd like to send you email about our work encrypting the web,
EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: y
Account registered.
Please enter the domain name(s) you would like on your certificate (comma and/or
space separated) (Enter 'c' to cancel): 输入你的域名, 多个域名用逗号或空格分隔
Requesting a certificate for 你之前输入的域名

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/你之前输入的域名/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/你之前输入的域名/privkey.pem
This certificate expires on 证书过期时间.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

Deploying certificate
Successfully deployed certificate for 你之前输入的域名 to /etc/nginx/sites-enabled/default
Congratulations! You have successfully enabled HTTPS on https://你之前输入的域名

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
* Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
* Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

证书创建成功后在 `/etc/letsencrypt/live/你之前输入的域名` 目录下

由于我们刚刚启动了 nginx 关闭了容器, 所以现在要关闭宿主机的 nginx，并关闭其开机自启动, 然后再启动容器服务

```shell
$ ps -ef | grep nginx   
root      2933     1  0 02:49 ?        00:00:00 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
$ kill -9 2933
$ sudo update-rc.d -f nginx remove
$ sudo systemctl disable nginx
```

## 修改 FRP 客户端配置

> 未修改的配置省略，可以看[https://blog.crazybunqnq.com/2020/02/29/raspberrypi4b/#FRP-配置]

```ini
[common]
略...

[blog]
type = http
local_ip = 你的服务ip
local_port = 你的服务端口
custom_domains = 你的域名

[blog-https]
type = https
local_port = 你的服务端口
custom_domains = 你的域名
plugin = https2http
plugin_local_addr = 你的服务ip:你的服务端口
plugin_crt_path = /etc/letsencrypt/live/你之前输入的域名/fullchain.pem
plugin_key_path = /etc/letsencrypt/live/你之前输入的域名/privkey.pem
plugin_host_header_rewrite = 你的域名
plugin_header_X-From-Where = frp
```

修改完成后重启 frpc 就生效了

## 缺点

这种方式有几个缺点:

1. 生成证书的时候需要停止服务
2. 访问 http 链接时无法自动跳转到 https 链接

等我研究出来之后再来优化~