---
title: Mac 批量视频转换
date: 2018-02-06 22:22:22
catdgories: Shell
tags:
- zsh
- video
- tool
- bash
---

前几天需要转换一下视频格式，结果网上搜了很多工具都只能一个一个的转换，很耗时。
但是其中发现了一个可以用命令行来转化视频格式的命令 [ffmpeg](https://www.ffmpeg.org)，所以就想着干脆利用这个命令自己写一个批量转换的脚本好了~
正好练习下 [zsh](https://ohmyz.sh) 脚本~

<!--more-->

## 注意事项

- 该脚本使用 [zsh](https://ohmyz.sh) 语法，与 `bash` 语法有区别，后续我会补上 `bash` 版本的脚本。
- 使用该脚本需要先安装 [ffmpeg](https:www.ffmpeg.org) 工具（推荐使用 [homebrew](https://brew.sh) 安装，简单省事~）

## 代码

思路很简单，就是遍历当前目录下的所有支持转换的视频文件，然后循环执行 `ffmpeg` 命令。

废话不多说啦！直接上代码！

### bash

```bash
#!/bin/bash
# ffmpeg -i input.mp4 output.avi
echo "当前正在使用 $SHELL 执行脚本..."
# 视频路径
path=$1
# 目标类型
targetType=$2
# targetType="mp4"
# 输出目录，为空则与原目录相同
output=$3
# 设置支持的格式（空格隔开）
suportType=(webm mp4 avi)
#该目录下的所有文件
files=$path/*
# 设置安装的 ffmpeg 路径
ffmpegPath=/usr/local/bin
# 计数
count=0

# 判断输出目录是否为空
if [ ${targetType} ]
then
    echo "目标类型为 mp4"
else
    echo "目标类型未指定，设置为默认值 mp4"
    targetType="mp4"
fi

# 判断输出目录是否为空
if [ ${output} ]
then
    echo "输出目录为 $output"
else
    echo "目标类型未指定，设置为默认值: $path/output"
    output=$path/output
fi

#如果文件夹不存在，创建文件夹
if [ ! -d "$output" ]
then
  mkdir $output
fi

echo "支持转化以下的视频格式..."
echo $suportType

echo ""
echo "任务开始"
echo "搜索 $path 目录下的所有文件..."
for file in $files
do
    if (test -f $file)
    then
        # 文件全名
        name=${file##*/}
        # 文件类型
        curType=${name##*.}
        # 文件名（不包含扩展名）
        name=${name%%.*}
        echo "文件类型为 $curType"
        for type in $suportType
        do
            # 判断是否是支持的类型，已经是目标类型的文件不转换
            echo "$type==$curType && $type!=$targetType"
            if [ "$type"=="$curType" ] && [ "$type"!="$targetType" ]
            then
                echo "正在转换视频："
                echo "$file >>>> $name.$targetType"
                # 执行视频转换命令
                echo "执行命令 $ffmpegPath/ffmpeg -i $file $output/$name.$targetType -threads 1"
                $ffmpegPath/ffmpeg -i $file $output/$name.$targetType -threads 1
                count=$((count+1))
                break
            fi
        done
    fi
done
echo "转换完成，共转换 $count 个视频文件"
```

### zsh

```bash
#!/bin/zsh
# ffmpeg -i input.mp4 output.avi
zmodload zsh/regex

echo "当前正在使用 $SHELL 执行脚本..."
# 视频路径
path=$1
# path="/Users/baojunjie/Pictures/video"
# 目标类型
targetType=$2
# targetType="mp4"
output=$3
# 设置支持的格式（空格隔开）
suportType=(webm mp4 avi)
# 设置安装的 ffmpeg 路径
ffmpegPath=/usr/local/bin
# 日志文件
log=$path/log.log
# 计数
count=0

# 判断目标类型是否为空
if [[ ${targetType} ]] {
    echo "目标类型为 mp4"
} else {
    echo "目标类型未指定，设置为默认值 mp4"
    targetType="mp4"
}

# 判断输出目录是否为空
if [[ ${output} ]] {
    echo "输出目录为 $output"
} else {
    echo "output 为默认值"
    output=$path/output
}
echo "输出目录为 $output"

# 判断目录是否存在，不存在则创建目录
if [[ ! -d "$output" ]] {
    /bin/mkdir $output
}

# 初始化正则表达式
reg="^(.*\.("
for type ($suportType) {
    if [[ $type != $targetType ]] {
        reg="$reg($type)|"
    } else {
        echo "已经是 $type 格式的视频不再转换"
    }
}
reg=$reg[1,-2]
reg=$reg"))$"
# echo "正则表达式：$reg"

echo "支持转化以下的视频格式..."
echo $suportType

echo ""
echo "任务开始"
echo "搜索 $path 目录下的所有文件..."
cd $path
for file (*.*) {
    echo "当前文件：$file"
    if (test -f $file)
         name=${file%%.*}
        if [[ $file -regex-match $reg ]] {
            echo "正在转换视频："
            echo "$file >>>> $name.$targetType"
            # 执行视频转换命令
            echo "$ffmpegPath/ffmpeg -i $file $output/$name.$targetType -threads 1"
            if {$ffmpegPath/ffmpeg -i $file $output/$name.$targetType -threads 1} {
                count=$((count+1))
            } else {
                echo "$file 转换失败" >> $log
            }
            echo ""
        } else {
            echo "格式不支持：$file"
        }
}
echo "转换完成，共转换 $count 个视频文件"
```

## 使用方式

终端中输入下面的命令即可执行

```bash
# bash
sh ffmpegs.sh 目录 [类型] [输出目录]

# zsh
zsh ffmpegs.zsh 目录 [类型] [输出目录]
```

![效果演示](http://wx3.sinaimg.cn/large/a6e9cb00ly1fo7vx1d0dog20n30h94qp.gif)

## 注意事项

批量转换视频时 CPU 的使用率很高，尽量减少任务量。

目前已设置 `-threads 1` 参数进行单线程操作，但是看起来是每个核一个线程，在 `ffmpeg` 中并没有找到限制核心使用数量的参数，希望有知道怎么解决这一问题的大神能够告知，谢谢！

>感觉不错的话帮我点个赞哟，谢谢~