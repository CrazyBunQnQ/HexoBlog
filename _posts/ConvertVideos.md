---
title: Mac 批量视频转换
date: 2018-02-06 22:22:22
catdgories: Shell
tags:
- zsh
- video
- tool
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

```bash
#!/bin/zsh
# ffmpeg -i input.mp4 output.avi
zmodload zsh/regex
echo "当前正在使用 $SHELL 执行脚本..."
path=$1
# path="/Users/baojunjie/Pictures/H/video"
targetType=$2
# targetType="mp4"
# 设置支持的格式（空格隔开）
suportType=(webm mp4 avi)

echo "支持转化以下的视频格式..."
echo $suportType
# 设置安装的 ffmpeg 路径
ffmpegPath=/usr/local/bin
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

echo ""
echo "任务开始"
echo "进入目录：$path"
cd $path
echo "搜索 $path 目录下的所有文件..."

for file (*.*) {
    echo "当前文件：$file"
    if (test -f $file)
        # echo $file 是文件
        # echo $file[2,4]
         name=${file%%.*}
        if [[ $file -regex-match $reg ]] {
            echo "正在转换视频："
            echo "$file >>>> $name.$targetType"
            if {$ffmpegPath/ffmpeg -i $file $name.$targetType} {
                echo "转换完成!"
             } else {
                echo "转换失败"
             }
            echo ""
        } else {
            echo "格式不支持：$file"
        }
}
```

## 使用方式

终端中输入下面的命令即可执行

```bash
zsh ffmpegs 目录 类型
```

![效果演示](http://wx3.sinaimg.cn/large/a6e9cb00ly1fo7vx1d0dog20n30h94qp.gif)

>感觉不错的话帮我点个赞哟，谢谢~