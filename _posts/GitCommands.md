---
title: 不常用的 Git 命令
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
    git reset 上一次的提交 id
    # 抛弃当前修改，完全回到上个版本的状态
    git reset --hard 上一次的提交 id
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

<br/>
## 合并指定文件或文件夹

```bash
git checkout 分支名 目标文件夹或目标文件名
```

<br/>
## 忽略本地文件修改

```bash
git update-index --assume-unchanged build/conf/a.conf
```

> 需要提前设置好默认编辑器

想要恢复的话执行如下命令:

```bash
git update-index --no-assume-unchanged build/conf/a.conf
```

> `build/conf/a.conf` 为想要忽略改动的文件

使用如下命令可以查看当前被忽略修改的本地文件列表:

```bash
git ls-files -v | grep -e "^[hsmrck]"
```

<br/>
## 想撤销中间某次提交

> 使用 `revert` 命令，而不是 `reset`
> `git reset –hard commit_id` 虽然可以回退远程库，但是其要求 `pull` 最新代码的每个人的本地分支都要进行版本回退

### 正确的步骤：

```bash
git revert commit_id
# 如果 commit_id 是 merge 节点的话, -m 是指定具体哪个提交点
git revert commit_id -m 1
# 接着就是解决冲突
git add -A
git commit -m ".."
git revert commit_id -m 2
# 接着就是解决冲突
git add -A
git commit -m ".."
git push
```

> 其中 `git revert commit_id -m 数字` 是针对 `merge` 提交点的操作


<br/>
## 修改远程默认分支

远程默认分支初始是 master

```bash
# 登录到远程 git 库所在的服务器
ssh root@192.168.1.1
# 创建临时目录(默认你已经有其他分支了)
mkdir tmp
# 检出另一个分支并将该分支作为默认分支
git --git-dir=./Project --work-tree=./tmp checkout 分支名
# 查看分支
git branch -a
```

<br/>
## 删除远程 master 分支

因为 master 分支是默认分支，所以直接使用 `git branch -d master` + `git push origin :master` 无法删除远程 master 分支

所以想要删除远程 master 分支就要先[修改默认分支](#修改远程默认分支)

然后再使用那两个命令删除 master 分支就可以了

```bash
git branch -d master
git push origin :master
```

#### 查看分支时报错

删除远程分支后再查看分支报错了: `warning: ignoring broken ref refs/remotes/origin/HEAD warning: ignoring broken ref refs/remotes/origin/HEAD`

可以使用如下命令检查状态:

```bash
git symbolic-ref refs/remotes/origin/HEAD
```

用如下命令修复该问题:

```bash
git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/分支名
```

将`分支名`替换为您希望 HEAD 指向的分支的名称

---

感谢阅读，如有其它想知道的内容欢迎留言，此文会不定期更新