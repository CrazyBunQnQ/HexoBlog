---
title: Maven
date: 2017-06-26 10:45
categories: 开发工具
tags: 
- Maven
- 构建工具
---

Maven 是一个项目构建工具，他的作用如下：
- 项目构建
- 对依赖的管理（jar 包的管理）
- 生成站点报告或文档

<!--more-->

下载 maven

配置环境变量：
- JDK 环境变量
- M2_HOME: 存放 maven 的位置
PATH: %M2_HOME%\bin;

maven 项目结构：
工程名
	src
		main
			java
		test
			java
			
项目构建的**核心**过程（编译 测试 打包 发布）
编译 mvn compile
测试 mvn test
打包 mvn package
发布 mvn install

maven 中的仓库：
- 中央仓库（外部）
- 私服（公司内部）
- 本地仓库（本机）


构建：
公共资源。
依赖、插件
仓库：
	存放或者管理资源的位置
远程仓库
 中央仓库
  私服仓库
   本地仓库
   
### maven 项目构建的整个生命周期
1. 清理 clean
	1. 清理前的准备工作
	2. 清理上一次的构建内容
2. 默认的 default 生命周期
	1. 初始化
	2. 编译
	3. 测试打包
	4. 集成测试
	5. 安装（本地仓库）或发布（deploy）
	6. 生成站点
3. 生成站点报告、项目文档报告等（需要 maven 插件）
	1. 生成站点的准备工作
	2. 生成站点报告
	3. 生成站点报告后的工作

### 搭建局域网私服
下载 [apache-archiva-x.x.x](https://archiva.apache.org/download.cgi)

Neuex: 私服
下载好后解压，配置环境变量
启动服务器：
archiva.bat console
localhost：8080:
界面：新建用户 user 登陆
添加 centerl 仓库的资源的奥私服中。
需要额外添加 点击 add 按钮添加即可。

配置 maven setting.xml 中的 server 和 mirror 标签
```xml
<server>
	<id>abcde</id>
	<username></username>
	<password></password>
</server>
```
```xml
<mirror>
	<id>abcde</id>
	<mirrorOf>*</>
	<name></name>
	<url></url>
<mirror>
```

### 生成站点
site plugin
```xml
<plugins>
	<plugin>
		<groupId>org.apache.maven</groupId>
		<artifactId>maven-site-api</artifactId>
		<version>3.1.0</version>
	</plugin>
	<reporting>
		<plugin>
			<groupId>org.apache.maven
			<artifactId>maven-doc
			<version>2.1.0</version>
		</plugin>
	</reporting>
</plugins>
```

### webservice
跨平台、跨服务器、跨语言的远程接口调用。
在网络上一个工程（java 项目），可以远程调用另外一个工程中的接口功能（不一定是 java 语言写的

例如支付功能，通常使用 webservice 调用现有的大型支付接口（如支付宝、网银等）

工程之间通过协议（soap 格式的数据）传输数据（xml、json 等工程）。

spring 整合 cxf 框架（webservice 的封装框架）

准备工作，下载 cxf 框架的 jar 包



其他构建工具
Ant：项目构建工具（编译 测试 打包 集成测试）
Gradle：项目构建工具