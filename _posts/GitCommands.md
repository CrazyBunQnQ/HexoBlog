---
title: 常用 Git 命令
date: 2018-04-05 22:22:22
categories: CVS
tag:
- Git
- 版本控制
- 命令行
- Command
---

虽然现在有很多 Git 图形化工具，但是它们都有一个共通的缺点：功能不全。

所以有时候遇到一些棘手问题，是无法通过图形化工具来解决的，这时候就只能使用命令行来解决了。

<!-- more -->

## Git 撤销

### 撤销 add 的文件

有时候，我们会不小心 add 了不想添加的文件，或者 add 之后后悔了，此时就需要对 add 的文件进行撤销了

1. 查看状态，看看 add 的文件有哪些
    ```bash
    git status
    ```
    ![查看状态](http://wx4.sinaimg.cn/large/a6e9cb00ly1fqvmara03jj210y0qik2x.jpg '撤销前的状态')

2. 撤销
    ```bash
    git reset HEAD #将最后一个版本之后添加的文件全部撤销为未添加状态
    git reset XXX/XXX/XXX.java #对指定的已添加某个文件进行撤销
    ```
    ![查看状态](http://wx4.sinaimg.cn/large/a6e9cb00ly1fqvmlmug4zj21080pon7q.jpg '撤销后的状态')

>此操作只适用于 add 后、commit 前的文件

<br/>

### 撤销 commit 的文件

不小心 add 的文件其实影响不大，更常出现的情况是不小心把错误的文件或不应该提交的文件给提交了

遇到这种情况，在图形化界面的操作往往是迅速修改为正确的文件再提交一下，或者把不应该提交的文件删除掉再提交一遍然后本地再添加一下不该提交的文件(累不累...)

但是，如果这样做的话在版本记录中还是会留下痕迹的。此时如果用命令行进行撤销的话就不会在版本中留下记录了

1. 查看提交记录
    ```bash
    git log
    ```
    ![提交记录](http://wx3.sinaimg.cn/large/a6e9cb00ly1fqvoh546bbj20uu0g8tfo.jpg '撤销前的提交记录')
    >`git log` 界面中按 `q` 退出
1. 撤销最后一次提交的内容
    ```bash
    # 保留当前修改
    git reset 上一次的提交id
    # 抛弃当前修改，完全回到上个版本的状态
    git reset --hard 上一次的提交id
    ```
    ![撤销提交内容](http://wx3.sinaimg.cn/large/a6e9cb00ly1fqvomg7zpyj20wy05utbq.jpg '撤销最后一次提交')
1. 提交正确内容
    ```bash
    git add xxx
    git commit -'xxx'
    ```
    ![提交记录](http://wx4.sinaimg.cn/large/a6e9cb00ly1fqvovt12fgj20v80g4trf.jpg '撤销后的提交记录')

>此操作只适用于 commit、push 前的文件，即撤销本地提交的内容

<br/>
### 撤销 push 的文件

还有一种情况，push 到远端后发现 commit 了多余的文件，或者希望远端也能够回退到以前的版本

此时就需要撤销远端的提交记录了

1. 先在[本地回退到相应的版本]()
2. 强制 push 覆盖掉远程仓库，使远程仓库也回退到相应版本
    ```bash
    git push origin 分支名 --force
    ```
    >如果此时只使用 `git push origin 分支名` 则会因为本地版本落后于远程仓库版本而报错
    >远端撤销就不再截图了，感兴趣的自行尝试吧

<!-- 感谢阅读，如有其它想知道的内容欢迎留言，此文会不定期更新 -->