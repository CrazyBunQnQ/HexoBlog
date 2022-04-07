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

## 泛域名

> 不用停止已启动的服务，也不需要解析好域名

```shell
certbot certonly --preferred-challenges dns -d "*.你的域名" -d 你的域名 --manual
Saving debug log to C:\Certbot\log\letsencrypt.log
Enter email address (used for urgent renewal and security notices)
(Enter 'c' to cancel): baobao222222@qq.com

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
(Y)es/(N)o: n
Account registered.
Requesting a certificate for *.你的域名 and 你的域名

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.你的域名.

with the following value:

UfoQY6rDagFen4WPPpP4APQQ_-EQwd9AcEIut9agC8E

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.你的域名.

with the following value:

H402Q80jpUb30EEwuTWanv7Pa-cMSoe96ERqQ15_x_A

(This must be set up in addition to the previous challenges; do not remove,
replace, or undo the previous challenge tasks yet. Note that you might be
asked to create multiple distinct TXT records with the same name. This is
permitted by DNS standards.)

Before continuing, verify the TXT record has been deployed. Depending on the DNS
provider, this may take some time, from a few seconds to multiple minutes. You can
check if it has finished deploying with aid of online tools, such as the Google
Admin Toolbox: https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.你的域名.
Look for one or more bolded line(s) below the line ';ANSWER'. It should show the
value(s) you've just added.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
```

此时按照提示去域名提供商添加域名解析, 这里我们 `-d` 了两个域名，所以添加两个 `TXT` 记录:

![_acme-challenge.png](/images/_acme-challenge.png)

> 解析结果可以在 linux 命令行中执行命令查看:
>
> ```shell
> nslookup -type=txt _acme-challenge.你的域名 114.114.114.114
> Server:         114.114.114.114
> Address:        114.114.114.114#53
>
> Non-authoritative answer:
> _acme-challenge.你的域名 text = "UfoQY6rDagFen4WPPpP4APQQ_-EQwd9AcEIut9agC8E"
> _acme-challenge.你的域名 text = "H402Q80jpUb30EEwuTWanv7Pa-cMSoe96ERqQ15_x_A"
> ```

添加完成后等待解析成功后继续在 cerbort 命令中回车进行下一步

```shell
...
Press Enter to Continue

Successfully received certificate.
Certificate is saved at: C:\Certbot\live\你的域名\fullchain.pem
Key is saved at:         C:\Certbot\live\你的域名\privkey.pem
This certificate expires on 2022-06-13.
These files will be updated when the certificate renews.

NEXT STEPS:
- This certificate will not be renewed automatically. Autorenewal of --manual certificates requires the use of an authentication hook script (--manual-auth-hook) but one was not provided. To renew this certificate, repeat this same certbot command before the certificate's expiry date.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

### 自动生成/更新泛域名证书

因为上面的生成操作中穿插着域名解析的操作，所以想要自动生成需要设置钩子(hook), 去自动调用域名厂商的域名解析接口，这里我们用的阿里云的域名，所以使用 [certbot-dns-aliyun](https://github.com/tengattack/certbot-dns-aliyun) 插件

> 需要 python

```shell
sudo snap install certbot-dns-aliyun
sudo snap set certbot trust-plugin-with-root=ok
sudo snap connect certbot:plugin certbot-dns-aliyun
/snap/bin/certbot plugins
```

创建一个配置文件，设置你的阿里云 api key:

```shell
touch /path/to/credentials.ini
chmod 600 /path/to/credentials.ini
```

```ini
certbot_dns_aliyun:dns_aliyun_access_key = 12345678
certbot_dns_aliyun:dns_aliyun_access_key_secret = 1234567890abcdef1234567890abcdef
```

自动生成泛域名证书:

```shell
/snap/bin/certbot certonly -a certbot-dns-aliyun:dns-aliyun --certbot-dns-aliyun:dns-aliyun-credentials /root/credentials.ini -d 你的域名 -d "*.你的域名"
# 自动输入 y 并不输入邮箱
echo y | /snap/bin/certbot certonly --register-unsafely-without-email -a certbot-dns-aliyun:dns-aliyun --certbot-dns-aliyun:dns-aliyun-credentials /root/credentials.ini -d 你的域名 -d "*.你的域名"

# output
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugin legacy name certbot-dns-aliyun:dns-aliyun may be removed in a future version. Please use dns-aliyun instead.
Requesting a certificate for 你的域名 and *.你的域名
Unsafe permissions on credentials configuration file: /csa/.tmp/credentials.ini
Waiting 30 seconds for DNS changes to propagate

Certbot failed to authenticate some domains (authenticator: certbot-dns-aliyun:dns-aliyun). The Certificate Authority reported these problems:
  Domain: 你的域名
  Type:   unauthorized
  Detail: No TXT record found at _acme-challenge.你的域名

  Domain: 你的域名
  Type:   unauthorized
  Detail: No TXT record found at _acme-challenge.你的域名

Hint: The Certificate Authority failed to verify the DNS TXT records created by --certbot-dns-aliyun:dns-aliyun. Ensure the above domains are hosted by this DNS provider, or try increasing --certbot-dns-aliyun:dns-aliyun-propagation-seconds (currently 30 seconds).

Some challenges have failed.
Ask for help or search for solutions at https://community.letsencrypt.org. See the logfile /var/log/letsencrypt/letsencrypt.log or re-run Certbot with -v for more details.
root@csaserver:~# echo y | certbot certonly --register-unsafely-without-email -a certbot-dns-aliyun:dns-aliyun --certbot-dns-aliyun:dns-aliyun-credentials /csa/.tmp/credentials.ini -d 你的域名 -d "*.你的域名"
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugin legacy name certbot-dns-aliyun:dns-aliyun may be removed in a future version. Please use dns-aliyun instead.
Requesting a certificate for 你的域名 and *.你的域名
Unsafe permissions on credentials configuration file: /csa/.tmp/credentials.ini
Waiting 30 seconds for DNS changes to propagate

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/你的域名/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/你的域名/privkey.pem
This certificate expires on 2022-06-20.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

自动更新泛域名证书:

```shell
/snap/bin/certbot renew -a certbot-dns-aliyun:dns-aliyun --certbot-dns-aliyun:dns-aliyun-credentials /root/credentials.ini
```