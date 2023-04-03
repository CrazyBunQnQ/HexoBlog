---
title: 你还在用 SVN 吗？
date: 2023-03-25 22:22:22
img: "/images/SvnToGit.png"
top: 10
cover: false
coverImg: "/images/SvnToGit.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: 
tags:
- Python
keywords:
- Java
- Python
- DataStructure
- BasicType
summary: 公司还在用 SVN 进行代码版本管理，真的是太难用了，而且还不支持分支，所以我决定把 SVN 仓库迁移到 Git 上，这样就可以使用 Git 的各种功能了。
---

## 搭建 Git 服务器
[smplatform_git_commit_push_1680154939.log](..%2F..%2F..%2FProjectsBak%2Flogs%2Fsmplatform_git_commit_push_1680154939.log)
直接 Docker 拉取 GitLab 镜像，然后运行即可。

```bash
# 启动镜像
docker run -itd --name gitlab --hostname 192.168.1.58 --restart always  -p 6443:443 -p 6080:80 -p 6022:22 -v /f/docker/data/gitlab/config:/etc/gitlab -v /f/docker/data/gitlab/logs:/var/log/gitlab -v /f/docker/data/gitlab/data:/var/opt/gitlab gitlab/gitlab-ce
# 登录后台
docker exec -it gitlab /bin/bash
# 查看初始密码
cat /etc/gitlab/initial_root_password
```

关闭用户注册，并创建自己的用户，不要用 root 账户直接提代码哟

### 安装一些工具

```shell
# apt 设置国内镜像源
# 进入 apt 目录
cd /etc/apt
# 备份原配置文件
mv sources.list sources.list.bak
# 编辑配置文件
vim sources.list
# 添加国内镜像源
deb http://mirrors.aliyun.com/debian/ buster main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib
deb http://mirrors.aliyun.com/debian-security buster/updates main
deb-src http://mirrors.aliyun.com/debian-security buster/updates main
deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
# 保存退出
# 更新源
apt update

# 安装工具
# apt install -y git git-svn subversion
apt install -y vim
```

### GitLab 设置

#### IP 设置

```shell
# 编辑 gitlab.yml 文件
vim /opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml
# 不好使再编辑这个
vim /var/opt/gitlab/gitlab-rails/etc/gitlab.yml
# 还不好使...那就只能 docker run 的时候加 --hostname 参数了
# 设置 host
host: 192.168.1.58
# 设置 port
port: 6080
https: false
# 保存退出
# 编辑 gitlab.rb 文件
vim /etc/gitlab/gitlab.rb
# 修改 external_url
registry_external_url 'http://192.168.1.58:6080'
# 保存退出
# 重启 gitlab
gitlab-ctl restart
```

#### 发邮件设置

```bash
# 进入容器
docker exec -it gitlab /bin/bash
# 进入配置文件目录
cd /etc/gitlab
# 编辑配置文件
vim gitlab.rb
# 找到下面的配置项，修改为自己的邮箱，这里以配置 QQ 邮箱为发件邮箱为例
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.qq.com"
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = "你的QQ号@qq.com"
gitlab_rails['smtp_password'] = "QQ邮箱授权码"
gitlab_rails['smtp_domain'] = "qq.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
gitlab_rails['gitlab_email_from'] = "你的QQ号@qq.com"
# 重新加载配置
gitlab-ctl reconfigure
# 重启 gitlab
# gitlab-ctl restart
# 测试邮件, 进入 console 时用时比较久
gitlab-rails console
Notify.test_email('1064833740@qq.com', '邮件主题', '邮件内容').deliver_now
```



## 编写脚本

### 更新 SVN 仓库

更新 SVN 代码，并输出更新文件列表

update_svn.sh

```bash
#!/bin/bash
# sh update_svn.sh /d/ProjectsBak/Singularity /d/ProjectsBak/output.txt

# 获取前一天的日期 yyyy-MM-dd
startday=$(date -d "yesterday" +%Y-%m-%d)
echo $startday

# 读取命令行参数中的项目路径
repodir=$1
outputfile=$2
filename=/d/tmp.txt

# svn 更新代码
echo "更新代码: svn update $repodir"
svn update $repodir

# 命令行中是否有第三个参数
if [ -n "$3" ]; then
  # 有第三个参数，使用第三个参数作为日期
  startday=$3
else
  echo "未指定日期，使用前一天的日期: $startday"
fi
# 一段时间内提交的文件汇总
echo "一段时间内提交的文件汇总: svn diff --summarize -r {$startday}:HEAD $repodir | awk '/^[ADM]/{printf "%s %s\n", substr($1,1,1), $2}' > $filename"
svn diff --summarize -r {$startday}:HEAD $repodir | awk '/^[ADM]/{printf "%s %s\n", substr($1,1,1), $2}' > $filename
# 将 windows 盘符 替换为 linux 路径
echo "将 windows 盘符 替换为 linux 路径: sed -i -E 's/([a-zA-Z]):/\/\1/g' $filename"
sed -i -E 's/([a-zA-Z]):/\/\1/g' $filename
# 将 windows 路径分隔符替换为 linux 路径分隔符
echo "将 windows 路径分隔符替换为 linux 路径分隔符: sed -i -E 's/\\/\//g' $filename"
sed -i -E 's/\\/\//g' $filename

if [ -f "$outputfile" ]; then
  echo "删除旧文件: $outputfile"
  rm "$outputfile"
fi

# 过滤出文件
echo '排除所有目录变更...'
while read line; do
  # 使用空格分隔行，取第二列作为路径
  path=$(echo $line | awk '{print $2}')
  # 判断路径是否为文件
  if [[ $line == D* ]]; then
    # 删除的文件不存在，无法判断，直接保留操作记录
    echo $line >> $outputfile
  elif [ -f $path ]; then
    # 保留文件操作记录
    echo $line >> $outputfile
  fi
done < $filename
echo "输出文件: $outputfile"

# 删除临时文件
if [ -f "$filename" ]; then
  echo "删除临时文件: $filename"
  rm "$filename"
fi
```

### 准备提交资源

git_pull_copy_resources.sh

```shell
#!/bin/bash
# sh git_pull_copy_resources.sh /f/CodeRepo/Singularity /d/ProjectsBak/output.txt

# 设置git项目目录
git_project=$1
project_name=$(basename $git_project)
# 更新文件列表文件路径
update_list_file=$2
# 命令行中是否有第三个参数
dir_struct=module_branch
if [ -n "$3" ]; then
  # 有第三个参数，使用第三个参数作为目录结构
  dir_struct=$3
  echo "目录结构为: $dir_struct"
else
  echo "未指定目录结构，默认为: $dir_struct"
fi
# svn 与 git 项目映射文件
dicfile=$git_project/svn_git_map.properties
# 模块数组
models=()
# 需要特殊处理的模块数组
special_models=()
# 分支文件夹
branchs_dir=$git_project/.branches
# 分支文件夹若存在则删除重建
if [ -d $branchs_dir ]; then
  rm -rf $branchs_dir
fi
echo "创建临时分支目录: $branchs_dir"
mkdir $branchs_dir

# 切换到项目目录，并更新
echo "切换到项目目录，并更新分支信息: cd $git_project && git fetch"
cd $git_project && git fetch

# 切换到 main 分支并更新分支
echo "切换到 main 分支并更新分支: git checkout main && git pull"
git checkout main && git pull

# 定义映射字典
echo "定义映射字典: declare -A map_dict"
declare -A map_dict
# 读取映射配置到字典, 顺便提取出涉及的分支列表
echo "读取映射配置到字典并提取涉及的分支列表"
start_time=$(date +%s)
while read line; do
    # 如果以 '#' 开头，就跳过此次循环
  if [[ $line == \#* ]]; then
    continue
  fi
  # 将每行按照等号拆分成key和value
  key=$(echo $line | cut -f1 -d=)
  value=$(echo $line | cut -f2 -d=)
  # echo "$key = $value"
  if [[ $key == *_* ]]; then
    model=${key%_*}
    # 如果 dir_struct 为 stable 则 model = key
    if [ $dir_struct == "stable" ]; then
      model=$key
    fi
    svn_branch=${key/$model/}
    echo "$model 模块分支1为 $svn_branch"
    svn_branch=${svn_branch/_/}
    echo "$model 模块分支为 $svn_branch"
    # 判断 $branchs_dir/$svn_branch 是否存在，不存在则创建
    if [ ! -d $branchs_dir/$svn_branch ]; then
      echo "创建目录: $branchs_dir/$svn_branch"
      mkdir $branchs_dir/$svn_branch
    fi

    # 添加到模块数组中
    if [[ ! " ${models[@]} " =~ " ${model} " ]]; then
      echo "涉及模块: $model"
      models+=("${model}")
    fi
    # 添加到特殊处理模块数组中
    if [[ ! " ${special_models[@]} " =~ " ${model} " ]]; then
      # 添加元素到数组中
      echo "特殊处理模块: $model"
      special_models+=("${model}")
    fi
    # TODO 特殊模块映射处理
  else
    while read -r line; do
      svn_branch=${line#*/}
      svn_branch=${svn_branch%/*}
      echo "$key 模块分支为 $svn_branch"
      # 判断 $branchs_dir/$svn_branch 是否存在，不存在则创建
      # echo "判断 $branchs_dir/$svn_branch 是否存在，不存在则创建"
      if [ ! -d $branchs_dir/$svn_branch ]; then
        echo "创建目录: $branchs_dir/$svn_branch"
        mkdir $branchs_dir/$svn_branch
      fi
    done < <(grep -Eo "$value" $update_list_file | sort -u)
    # 添加到模块数组中
    if [[ ! " ${models[@]} " =~ " ${key} " ]]; then
      echo "涉及模块: $key"
      models+=("${key}")
    fi
  fi
  map_dict["$key"]="$value"
done < $dicfile
# 计算耗时
end_time=$(date +%s)
echo "读取映射、提取分支耗时 $((end_time - start_time)) 秒"

echo ""
echo "================================================"

# 读取文本文件 update_list_file 中的每一行变更
# 获取时间戳, 用来计算耗时
start_time=$(date +%s)
while read line; do
  # 截取 line 的第二列，作为文件路径
  update_path=${line#* }
  # 根据 project_name 截取出模块路径
  model_path=${update_path#*$project_name/}
  # 获取第一个 / 之前的内容作为模块名
  model=${model_path%%/*}
  # 如果 special_models 中包含 model, 则跳过
  if [[ " ${special_models[@]} " =~ " ${model} " ]]; then
    # TODO 特殊处理
    echo "跳过 $model 模块"
    continue
  fi

  # 从 model_path 中截取出分支
  branch_path=${model_path#*$model/}
  if [ $dir_struct == "stable" ]; then
    tmp=$branch_path
    branch_path=$model_path
    model_path=$tmp
    model=${model_path%%/*}
  fi
  # 获取第一个 / 之前的内容作为分支
  branch=${branch_path%%/*}
  # echo "模块路径: $model_path"
  # echo "模块: $model"
  # echo "分支路径: $branch_path"
  # echo "分支: $branch"
  # 从 branch_path 中截取出文件路径
  file_path=${branch_path#*$branch/}
  # 获取第一个 / 之后的内容作为文件路径
  file_path=${file_path#*/}

  # 如果是否以 D 开头, 则是需要删除的文件或目录
  if [[ $line == D* ]]; then
    # echo "文件路径: $file_path"
    target_path=$git_project/$model/$file_path
    delete_list_file=$branchs_dir/$branch/delete_files.txt
    # 判断 delete_list_file 是否存在，不存在则创建一个
    if [ ! -f $delete_list_file ]; then
      echo "创建文件: $delete_list_file"
      touch $delete_list_file
    fi
    echo "添加待删除文件 $update_path"
    echo "到 $delete_list_file"
    echo $target_path >> $delete_list_file
  else
    # echo "文件路径: $file_path"
    target_path=$branchs_dir/$branch/$model/$file_path
    # 复制到对应分支目录
    echo "复制文件 $update_path"
    echo "到 $target_path"
    target_dir=$(dirname $target_path)
    # 如果目录不存在则创建
    if [ ! -d $target_dir ]; then
      echo "创建目录: $target_dir"
      mkdir -p $target_dir
    fi
    cp $update_path $target_path
  fi
done < $update_list_file
# 计算耗时
end_time=$(date +%s)
echo "拷贝待提交资源耗时: $((end_time - start_time)) 秒"
```

### 提交变更到 Git 仓库

git_commit_push.sh

```shell
#!/bin/bash
# sh git_commit_push.sh /f/CodeRepo/Singularity

# 设置git项目目录
git_project=$1
project_name=$(basename $git_project)
# 命令行中是否有第三个参数
dir_struct=module_branch
if [ -n "$2" ]; then
  # 有第三个参数，使用第三个参数作为目录结构
  dir_struct=$2
  echo "目录结构为: $dir_struct"
else
  echo "未指定目录结构，默认为: $dir_struct"
fi
# 分支文件夹
branchs_dir=$git_project/.branches
echo "各分支待提交文件夹: $branchs_dir"

echo "切换到项目目录: cd $git_project"
cd $git_project

start_time=$(date +%s)
# 遍历 $branchs_dir 目录下的所有分支
for branch in $(ls $branchs_dir); do
  git_branch_name=$branch
  echo $git_branch_name
  # 如果 $branch 不是 dev 则添加前缀 release_
  if [ $branch != "dev" ]; then
    if [ $dir_struct != "stable" ]; then
      git_branch_name="release_$branch"
    fi
  fi
  # 如果分支不存在则跳过
  if [ -z "$(git branch -a | grep $git_branch_name)" ]; then
    echo "跳过不存在的分支: $git_branch_name"
    continue
  fi
  # 切换到分支并更新
  git checkout $git_branch_name && git pull
  # 从 main 分支检出 .gitignore 文件
  git checkout main .gitignore
  git checkout main svn_git_map.properties
  # 如果 .gitignore 有变更则立刻提交并 push
  if [ -n "$(git status --porcelain)" ]; then
    echo "更新 .gitignore 文件"
    git add .gitignore && git add svn_git_map.properties && git commit -m "update .gitignore" && git push
  fi
  # 如果存在 delete_files.txt 文件, 则删除文件
  delete_list_file=$branchs_dir/$branch/delete_files.txt
  if [ -f $delete_list_file ]; then
    echo "删除文件: xargs rm -rf < $delete_list_file"
    xargs rm -rf < $delete_list_file
    # 提交并 push
    git add . && git commit -m "从 SVN 同步删除文件"
    # git push
  fi
  # 变更文件目录
  update_dir=$branchs_dir/$branch
  # 遍历 $update_dir 目录下所有文件夹
  echo "拷贝 $update_dir 目录下所有文件夹到 $git_project 目录下..."
  for model_dir in $(ls $update_dir); do
    # 如果是 delete_list_file 则跳过
    if [ $model_dir == "delete_files.txt" ]; then
      echo "跳过文件: $update_dir/$model_dir"
      continue
    fi
    # 如果 model_dir 是目录则跳过
    if [ -d $update_dir/$model_dir ]; then
      # 拷贝文件夹到 $git_project 目录下
      echo "拷贝目录: cp -r $update_dir/$model_dir/* $git_project/$model_dir/"
      cp -r $update_dir/$model_dir/* $git_project/$model_dir/
    else
      # 拷贝文件到 $git_project 目录下
      echo "拷贝文件: cp $update_dir/$model_dir $git_project/$model_dir"
      cp $update_dir/$model_dir $git_project/$model_dir
    fi
  done
  # 提交并 push
  git add . && git commit -m "从 SVN $branch 分支同步变更"
  git push
done
end_time=$(date +%s)
echo "提交到 Git 耗时: $((end_time - start_time)) 秒"
```