---
title: bash 常用命令
date: 2018-03-13 15:49:50
categories: Shell
tags:
- 补位
- 赋值
---

## Shell 中将数字转为字符串并在前面补零

### 示例：生成指定范围内的随机时间

```bash
#!/bin/bash

function rand(){
    min=$1
    max=$(($2-$min+1))
    #增加一个10位的数再求余
    num=$(($RANDOM+1000000000))
    echo $(($num%$max+$min))
}

day='2018-03-13'
# 时分秒字符串（两位数字）
hh=`echo 8 | awk '{printf("%02d\n",$0)}'`
mm=`echo $(rand 0 25) | awk '{printf("%02d\n",$0)}'`
ss=`echo $(rand 0 59) | awk '{printf("%02d\n",$0)}'`
echo $day $hh:$mm:$ss
```

## 登陆 Linux 服务器

```bash
ssh username@ip
```

## Linux 文件传输

```bash
# 将本地文件上传到服务器的目的路径
scp -P 端口号 本地文件路径 username@服务器ip:目的路径
# 将服务器上目的路径的文件下载到本地路径
scp -P 端口号 username@ip:路径 本地路径
```