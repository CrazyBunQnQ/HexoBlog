---
title: Java Web 基本概念
date: 2017-04-19 22:22:22
categories: 
- Web 基础
- 待完善
tags: 
- Web
- tomcat
- http 协议
- servlet
---

Web 就是网页的意思，互联网上主机提供的对外访问的资源。
- 静态 Web 资源：网页内容不会随时间改变，不能和后台交互，如 HTML + CSS + JS → jQuery。
- 动态 Web 资源：网页内容会随时间而改变，可以与后台交互，如 servlet/jsp。

<!--more-->

软件开发模式：
B/S 架构：浏览器服务器模式
C/S 架构：客户端服务器模式

## Java Web
Java Web 就是 Java 提供 Web 资源访问的技术总成
>与其他语言的 Web 资源访问技术对比：
>- asp.net —— 小型 Web 应用，快速开发
>- php —— 做网站，性能好，速度快，但是没有 Java Web 安全。
>- Java Web —— 企业级 Web 应用

## 服务器
安装了服务程序的计算机就是服务器。
## 常用服务器
- apache-tomcat —— 免费开源的服务器
只支持 Servlet 和 jsp 规范
- weblogic —— IBM 公司开发的收费的商业服务器
支持 13 中技术规范（netbeans）
- websphere —— 收费的商业版服务器
支持 13 中技术规范（netbeans）
- jboss —— 免费开源的服务器
支持除了 Servlet 和 jsp 的其他技术规范
- Java EE 服务器
两台 tomcat 搭一台 jboss 服务器

> Java EE 有 13 钟技术规范
> JDBC
> JNDI
> EJBs
> RMI
> JSP

## tomcat
官方网站下载

### 启动与关闭

### 目录结构
- bin 目录 —— 存放了 Tomcat 的指令代码，包括启动、停止等
- conf 目录 —— 存放 Tomcat 的配置文件（.xml 和 .properties）
- lib 目录 —— 存放了支持 Tomcat 运行的 jar 文件 
- logs 目录 —— 日志目录，存放了 Tomcat 运行过程中记录
- temp 目录 —— 存放 Tomcat 临时文件
- webapps 目录 —— Web 应用存放的目录
- work 目录 —— Tomcat 的工作目录（将 jsp 文件编译成 .class 文件）

### Tomcat 虚拟目录映射
将存在的 Web 

### 配置 Tomcat
配置 server.xml
在 <Host name="localhost"> 标签下面添加 Context 标签
```
<Context docBase="磁盘路径" path="/映射路径"></Context>
```

或
在 conf/Catelina/localhost 目录中添加一个 "映射路径.xml" 文件(若为 ROOT.xml 则为缺省)
并编辑内容为 <Context docBase="磁盘路径"></Context>
此方法不需要重新启动 tomcat 服务器

该代码表示在浏览器中输入 localhost/映射路径 时，将访问 【磁盘路径】的网页

### 去除端口
配置 server.xml 文件
设置 <Host name="localhost"> 端口为 80 端口。

### 配置 servlet 的映射
配置 jsp 映射
配置监听器，过滤器的映射
配置错误处理页面



## http 协议
HTTP 是 hypertext transfer protocol（超文本传输协议）的简写，它是 TCP/TP 协议的一个应用层协议，用于定义 web 浏览器 与 web 服务器之间交换数据的过程：
版本：
- Http 1.0 只支持单个 web 资源的访问
- HTTP 1.1 支持多个 web 资源访问

### 客户端请求
GET /baidu/index.heml HTTP/1.1
请求的消息投（请求方式，请求资源路径+参数，请求的协议）
Host : localhost:8080
请求的主机地址和端口号
Connection: keep-alive
访问完毕后服务器保持链接
Cache-Control: max-age=0
缓存控制，>=0 表示支持缓存
Upgrade-Insecure-Requests: 1
自动将 HTTP 协议 升级为 HTTPS
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36
浏览器信息
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
告诉服务器能够接受的数据类型
Accept-Encoding: gzip, deflate, sdch, br
支持的压缩格式
Accept-Language: zh-CN,zh;q=0.8
浏览器使用的语言
If-None-Match: W/"20-1492573751023"
记录修改的时间，精确到毫秒
If-Modified-Since: Wed, 19 Apr 2017 03:49:11 GMT
记录上次修改的时间，精确到秒

POST 请求


### 服务器响应
HTTP/1.1 200 OK
响应消息航（协议，响应的状态吗）
Server: Apache-Coyote/1.1
服务器类型
ETag: W/""
访问资源最后修改的时间
Last-Modified: Wed,...
访问资源最后修改的时间精确到秒
Content-Type: text/html
富强武器响应的数据类型
Content-Length: 184
服务器相应数据的长度
Date:
响应的时间


## servlet
Servlet（Server applet）—— 服务器端小程序
servlet 3.1 版本 --- 4.0
可以实现网页的动态 web 资源访问

### 开发 servlet 步骤

1. 
2. 在 classes 目录编写一个 HelloServlet.java
extends GenericServlet
3. 编译生成.class 文件
1. 获取一个服务器写出流
```
PrintWriter out = res.getWriter();
```
2. 写出服务器响应
4. 配置 server.xml 映射
```XML
<!--映射路径-->
<servlet>
	<servlet-name>helloServlet</servlet-name>
	<servlet-class>com.crazybunqnq.HelloServlet</servlet-class>
</servlet>
<!--映射-->
<servlet-mapping>
	<servlet-name>helloServlet</servlet-name>
	<url-pattern>/hello</url-pattern>
</servlet-mapping>
```

>javac -cp jar 包路径 -d pakage 路径 java 文件.java
>javac -cp .\servlet-api.jar -d . HelloServlet.java
>-cp 确定添加的 classpath 路径
>-d 生成对应的 pakage 文件夹
>. 当前目录