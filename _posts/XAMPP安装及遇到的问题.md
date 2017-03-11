---
title: XAMPP 安装及遇到的问题
date: 2016-10-20 16:48
categories: 触类旁通
tags: 
- 建站
- XAMPP
---

# 下载与安装 #
**先附上中文界面(菜单内部仍为英文)：**
![XAMPP 中文版界面](http://wx2.sinaimg.cn/mw690/a6e9cb00ly1fdiwv3as6aj20kp0d9tba.jpg)
XAMPP 下载地址：[中文版][1] [官网][2]

[1]: http://www.xampps.com
[2]: http://www.xampp.org

linux 下课使用 wget 命令下载
    
    https://www.apachefriends.org/xampp-files/5.6.24/xampp-linux-x64-5.6.24-1-installer.run

下载安装后打开为如下界面：

![XAMPP 初始界面](http://wx4.sinaimg.cn/mw690/a6e9cb00ly9fdiwz8xrcxj20fa05hjte.jpg)

看起来好像出了很多错误，当然并没有。

**默认 Apache 组件处于运行中（注意绿色），但没有加载到 windows 系统中作为服务。先 stop 停止掉 Apache ，然后点击左侧红色的 X 安装 apache 服务，需要添加 Mysql 也是同样的操作。**

**我们开启Apache服务，X 变为绿色的 √，然后打开浏览器访问 localhost (或 127.0.0.1 本机地址)，看到下面的页面，说明服务器环境搭建成功。**

![PHP 界面](http://wx4.sinaimg.cn/mw690/a6e9cb00ly1fdix261yk9j20go0kptb7.jpg)

#### 那我们自己写的文件该放在哪里才能运行呢？ ####

答案是**在 `xampp\htdocs` 目录下，如果存在 index.php 文件，优先执行该文件，如果不存在，则访问 localhost 时将显示网站目录。**

下面是我将原来目录的 index.php 修改为 index2.php 时访问 localhost 出现的页面:
![index.php 错误示例](http://wx2.sinaimg.cn/mw690/a6e9cb00ly1fdix5hsu2aj20e50cx75l.jpg)

# 服务器环境搭建成功后需要做的事 #

1. **修改 phpMyAdmin 配置**
a. 首先打开 D:/XAMPP/phpMyAdmin 文件夹中的 config.inc.php 文件。
b. 搜索 `$cfg['Servers'][$i]['auth_type'] = 'config';`,将其中的 config（系缺省值）更改为“cookie”保存。

2. **登录XAMPP**
a. 通过默认主页 http://localhost 左侧的 phpmyadmin 导航栏进入 phpmyadmin 界面（可直接通过 http://localhost/phpmyadmin/ 进入 web 登陆界面，输入用户名 root 密码 root 后直接点击登录即可）
**注：***在默认状态下，phpmyadmin 有两个用户名，分别是 pma 和 root 。其中，root 是管理员身份，而pma则是普通用户身份，但二者在缺省状态下均无密码*
若提示 服务器无响应(或者本地 MySQL 服务器的套接字没有正确配置)的问题，请看后面解决办法

3. **建立新的管理员账号及删除原有的root账号**
进入用户选项卡，点击root账号编辑其权限，在底端的修改密码输入相应的密码
![用户选项卡](http://wx3.sinaimg.cn/mw690/a6e9cb00ly1fdixbym4g9j20y00hjtbp.jpg)
![修改密码](http://wx3.sinaimg.cn/mw690/a6e9cb00ly1fdixcnissej20nt08egm2.jpg)

**需要注意
>1. root 等管理员密码无需在 config.inc.php 中更改。
>2. 只有 pma 不设置密码时，XAMPP 主界面的 MySQL database 的状态才会显示为 ACTIVATED 状态！
>3. 不要使用 XAMPP for Windows Version 1.5.2 自带的 mysql 管理软件来设置。如果设置了，会在 C:\windows >目录下产生一个 my.ini 文件。如果要重新安装，则需要将此 my.ini 文件删除，以免影响后续设置。
>4. 必要时请更改默认端口，APACHE 的默认端口是 80，如果你装有 IIS，就会有冲突。所以，要更改一个端口。打开 XAMPP/apache/conf/httpd.conf，把 listen 80 改为其它的端口，如 99, 8080 等。
>5. 您可能会遇到安装了 xampp，在本机通过 localhost 和 ip 都可以访问，但是局域网其他机器不能访问的问题。解决方法是：修改 XAMPP/apache/httpd.conf，把 Listen 80 改成 Listen 192.168.0.188:80, 192.168.0.188 换成您服务器的 ip。

# 我遇到的问题以及解决方法： #
## 服务器无响应(或者本地 MySQL 服务器的套接字没有正确配置)的问题 ##
1. 第一种情况：（深度清理垃圾导致 host.MYD 丢失）
原因：host.MYD 文件是一个 0 字节文件，即没有任何内容，但在启动 mysql 时会被调用，写入一些临时信息，深度清理垃圾时，我选择扫描空文件和空文件夹，就将 host.MYD 扫描到并删除了，再次启动 wamp，就产生如上问题；
>解决方案：第一次安装 wamp 时，在安装目录下找到 host.MYD，其路径为 `"C:\wamp\bin\mysql\mysql5.5.20\data\mysql\host.MYD (我默认安装wamp在C盘根目录)"`，你可以选择备份一个 host.MYD，或者新建一个空的“文本文档.txt”将其改为“host.MYD”，放到其正确路径下即           可。
 
2. 第二种情况：（防火墙阻止导致 mysql 无法启动）
原因：未启动本地 mysql 服务器
>解决方法：
        第一步，找到 mysql 的安装路径 D:\Program Files\MySQL\MySQL Server 5.1\bin
        第二步，双击 mysqld.exe 文件，如果 windows 防火墙弹出阻止提示框，点击解除阻止即可

3. 第三种情况：(mysql 套接字文件绑定 ip 无效)
原因：如果未指定主机名或指定了特殊的主机名 localhost，将使用Unix套接字，Unix 套接字默认为 `/tmp/mysql.sock`，而本机并没有配置这样的套接字文件，所以自然是连接失败了。
>解决方法：找到 phpmyadmin 文件夹,在 `wamp\phpmyadmin` 下（具体视自己安装的路径来查找），找到 `config.inc.php` 文件，用 notepad (记事本)等软件打开找到 `$cfg['Servers'][$i]['host'] = 'localhost';` 这一行，然后将这里的 localhost 修改为 127.0.0.1。有网友建议添加 `$cfg['Servers'][$i]['hide_db'] = ‘information_schema’;` //使用登陆后看不见 information_schema 数据库，这一句其实不加也无所谓。

## phpMyAdmin界面左边出现错误提示 ##
![phpMyAdmin 显示错误](http://wx4.sinaimg.cn/mw690/a6e9cb00ly1fdixhm6ecxj205g0b3aam.jpg)
**解决方法**：（我居然吭哧半天看懂了英文...以防以后在遇到的时候看不懂。。。先记下来= =哈哈）
**方法一：**
>You have to run the create_tables.sql inside the examples/ folder on phpMyAdmin to create the tables needed for the advanced features. That or disable those features by commenting them on the config file.
>
>That's an alternative, yes. For importing the .sql file, you should go to the import tab on phpmyadmin and select that file, and then send the form. Just that.

在 phpMyAdmin 的导入选项卡中选择 `XAMPP\phpMyAdmin\examples\` 中的 create_tables.sql 文件上传并执行即可。

![导入](http://wx1.sinaimg.cn/mw690/a6e9cb00ly1fdixjf50fej20op0jctah.jpg)
![导入 sql](http://wx3.sinaimg.cn/mw690/a6e9cb00ly1fdixk0jwyij207906hglv.jpg)

如果还提示上述错误，则
>You will find `create_tables.sql.gz` file in `/usr/share/doc/phpmyadmin/examples/`
Extract it and change pma_ prefix by pma__ or vice versa

编辑 `create_tables.sql` 文件，将其中所有的的 pma_（单下划线）换成 pma__（双下划线）后再次上传执行即可。
![修改 create_tables.sql 文件](http://wx2.sinaimg.cn/mw690/a6e9cb00ly1fdixv68ldsj20ts0ppaeo.jpg)

**方法二：（适用于Linux系统）**
**直接执行**

    sudo dpkg-reconfigure phpmyadmin

## 使用配置文件中定义的控制用户连接失败 ##

![控制用户连接失败](http://wx4.sinaimg.cn/mw690/a6e9cb00ly1fdixwrinafj207p01cq2t.jpg)

编辑 `XAMPP\phpMyAdmin\config.inc.php` 文件将

    $cfg['Servers'][$i]['controluser'] = '';
    $cfg['Servers'][$i]['controlpass'] = '';

两行改成你的数据库用户名和密码，保存即可:

![修改用户名密码1](http://wx1.sinaimg.cn/mw690/a6e9cb00ly1fdixz16ff0j20a201aq2w.jpg)

改为：

![修改用户名密码2](http://wx3.sinaimg.cn/mw690/a6e9cb00ly1fdixzryyvdj20a701baa0.jpg)