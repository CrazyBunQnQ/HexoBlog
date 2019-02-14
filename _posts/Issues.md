---
title: 经典 Issues 集锦
date: 2017-03-15 15:15:15
categories: 
- 杀虫
- Java
- 待完善
tags: 
- bug
- 调试
- 错误
- 异常
- Issues
top: 9
---

什么是经验？经验，就是遇到问题之后，你通过努力把它解决了，这就是你的经验！

在程序员的道路上，会遇到各种各样的问题和错误，我认为我不可能记住每一个问题的解决方式，好脑子不如烂笔头嘛，所以我要把我今后遇到的各种问题与错误都记录在这里～

<!-- more -->

## Java Issues

### An API baseline has not been set for the current workspace.    

Windows → Preferences → Plug-in Development → API Baselines
在 Options 里找到  Missing API baseline ，根据自己的情况改成 Warning 或者 Ignore，点击 Apply 应用即可。

>建议在[这里](http://www.ibm.com/developerworks/library/os-eclipse-api-tools/)研读一下 API baselines ，然后再决定这些 API baselines 是否对你有用。

<br/>
### java.lang.ClassNotFoundException: com.mysql.jdbc.Driver

#### 报错信息：

java.lang.ClassNotFoundException: com.mysql.jdbc.Driver...

#### 报错原因：

1. 驱动类名称写错
2. 没有添加 jar 包
    1. 项目中没有添加 mysql-connector-java-x.x.xx-bin.jar 包
    2. Web 项目中添加了 mysql-connector-java-x.x.xx-bin.jar 包，但是在 Tomcat 安装目录的 lib 目录下没有该 jar 包

#### 解决方法：

- 对于第一种原因仔细查找下改掉拼错的单词就行了，不多解释啦。
- 对于第二种报错原因的第一种情况，下载 mysql-connector-java-x.x.xx-bin.jar 添加进去就可以了，这里也不多说。
- 悲催的我遇到了另一种情况，已经将 mysql-connector-java-x.x.xx-bin.jar 包添加到项目中，测试数据库连接也是没有问题的，但是在 server 中运行时却报错...此时只要将相同的 jar 包复制一份到 Tomcat 安装目录中的 lib 文件夹中重启 Tomcat 服务器即可。

<br/>
### ERROR StatusLogger No log4j2 configuration file found.

#### 报错信息：

ERROR StatusLogger No log4j2 configuration file found. Using default configuration: logging only errors to the console. Set system property 'org.apache.logging.log4j.simplelog.StatusLogger.level' to TRACE to show Log4j2 internal initialization logging.

#### 报错原因：

- 没有找到 log4j2 的配置文件

#### 解决办法：

因为用的是 log4j2 所以不能按照大多数网站上写的配置 `log4j.properties` ，需要将配置文件名改为 `log4j2.properties`。

<br/>
### <!DOCTYPE log4j:configuration SYSTEM "log4j.dtd"> 系统找不到指定的文件

#### 警告信息：

The file cannot be validated as the XML definition "项目路径\src\log4j.dtd (系统找不到指定的文件。)" that is specified as describing the syntax of the file cannot be located.

#### 报错原因：

- 要么缺少 log4j.dtd 文件
- log4j.dtd 名称写错。
- log4j.dtd 文件未放在 src 目录下

#### 解决办法：

- log4j.dtd 位置（若已有 log4j.dtd 文件则忽略此条）
    - log4j 1.x：使用解压缩工具解压 log4j.jar 文件，找到 org/apache/log4j/xml 目录下的 log4j.dtd 文件。
    - log4j 2.x：使用解压缩工具解压 log4j-core-2.8.2.jar 文件，找到根目录下的 Log4j-events.dtd 文件。
- 将找到的 log4j.dtd 文件拷贝到项目路径的 src 目录下即可。

#### 参考：

[log4j.xml 提示不能找到 log4j.dtd](http://blog.csdn.net/linshutao/article/details/6578788)

<br/>
### Project facet Java 1.8 is not supported by target runtime Apache Tomcat v7.0.

#### 报错信息：

- Project facet Java 1.8 is not supported by target runtime Apache Tomcat v7.0.
- Project facet Java version 1.8 is not supported.
![Project facet Java version 1.8 is not supported.](http://wx1.sinaimg.cn/mw690/a6e9cb00ly1ff4q9grjocj20el0goaae.jpg)

#### 报错原因：

- 根本原因：JDK 的版本与 Tomcat 设置的版本不匹配
- 可能是你导入的项目中的 JDK 与你的 Tomcat 设置不同
- 也可能是你更换/更新了 JDK 版本(需要完全一致，包括第几次修订)导致该版本与 Tomcat 设置的版本不匹配

#### 解决办法：

重新配置 tomcat
1. 如图：右键 Servers 窗口空白位置 —— New —— Server —— Configure runtime environments... —— Add —— 选择 Tomcat 版本 —— Next
![设置 Tomcat 对应的 JDK 版本 No.1](http://wx4.sinaimg.cn/mw690/a6e9cb00ly1ff4rlvtwfdj217f0jrwi6.jpg)
2. 如图：选择 Tomcat 安装目录 —— 选择 JDK 版本 —— Finish
![设置 Tomcat 对应的 JDK 版本 No.2](http://wx4.sinaimg.cn/mw690/a6e9cb00ly1ff4red30u5j20el0fqmxw.jpg)

<br/>
### Exception starting filter [struts2] java.lang.ClassNotFoundException: org.apache.struts2.dispatcher.filter.StrutsPrepareAndExecuteFilter

#### 报错信息：

```log
org.apache.catalina.core.StandardContext.filterStart Exception starting filter [struts2]
 java.lang.ClassNotFoundException: org.apache.struts2.dispatcher.filter.StrutsPrepareAndExecuteFilter
    at org.apache.catalina.loader.WebappClassLoaderBase.loadClass(WebappClassLoaderBase.java:1275)
    at org.apache.catalina.loader.WebappClassLoaderBase.loadClass(WebappClassLoaderBase.java:1109)
    at org.apache.catalina.core.DefaultInstanceManager.loadClass(DefaultInstanceManager.java:508)
    at org.apache.catalina.core.DefaultInstanceManager.loadClassMaybePrivileged(DefaultInstanceManager.java:489)
    at org.apache.catalina.core.DefaultInstanceManager.newInstance(DefaultInstanceManager.java:119)
    at org.apache.catalina.core.ApplicationFilterConfig.getFilter(ApplicationFilterConfig.java:264)
    at org.apache.catalina.core.ApplicationFilterConfig.<init>(ApplicationFilterConfig.java:108)
    at org.apache.catalina.core.StandardContext.filterStart(StandardContext.java:4580)
    at org.apache.catalina.core.StandardContext.startInternal(StandardContext.java:5222)
    at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:183)
    at org.apache.catalina.core.ContainerBase.addChildInternal(ContainerBase.java:752)
    at org.apache.catalina.core.ContainerBase.addChild(ContainerBase.java:728)
    at org.apache.catalina.core.StandardHost.addChild(StandardHost.java:734)
    at org.apache.catalina.startup.HostConfig.manageApp(HostConfig.java:1702)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
    at sun.reflect.DelegatingMethodAccessorImpl.__invoke(DelegatingMethodAccessorImpl.java:43)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java)
    at java.lang.reflect.Method.invoke(Method.java:498)
    at org.apache.tomcat.util.modeler.BaseModelMBean.invoke(BaseModelMBean.java:300)
    at com.sun.jmx.interceptor.DefaultMBeanServerInterceptor.invoke(DefaultMBeanServerInterceptor.java:819)
    at com.sun.jmx.mbeanserver.JmxMBeanServer.invoke(JmxMBeanServer.java:801)
    at org.apache.catalina.mbeans.MBeanFactory.createStandardContext(MBeanFactory.java:456)
    at org.apache.catalina.mbeans.MBeanFactory.createStandardContext(MBeanFactory.java:405)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
    at sun.reflect.DelegatingMethodAccessorImpl.__invoke(DelegatingMethodAccessorImpl.java:43)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java)
    at java.lang.reflect.Method.invoke(Method.java:498)
    at org.apache.tomcat.util.modeler.BaseModelMBean.invoke(BaseModelMBean.java:300)
    at com.sun.jmx.interceptor.DefaultMBeanServerInterceptor.invoke(DefaultMBeanServerInterceptor.java:819)
    at com.sun.jmx.mbeanserver.JmxMBeanServer.invoke(JmxMBeanServer.java:801)
    at javax.management.remote.rmi.RMIConnectionImpl.doOperation(RMIConnectionImpl.java:1468)
    at javax.management.remote.rmi.RMIConnectionImpl.access$300(RMIConnectionImpl.java:76)
    at javax.management.remote.rmi.RMIConnectionImpl$PrivilegedOperation.run(RMIConnectionImpl.java:1309)
    at javax.management.remote.rmi.RMIConnectionImpl.doPrivilegedOperation(RMIConnectionImpl.java:1401)
    at javax.management.remote.rmi.RMIConnectionImpl.invoke(RMIConnectionImpl.java:829)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
    at sun.reflect.DelegatingMethodAccessorImpl.__invoke(DelegatingMethodAccessorImpl.java:43)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java)
    at java.lang.reflect.Method.invoke(Method.java:498)
    at sun.rmi.server.UnicastServerRef.dispatch(UnicastServerRef.java:346)
    at sun.rmi.transport.Transport$1.run(Transport.java:200)
    at sun.rmi.transport.Transport$1.run(Transport.java:197)
    at java.security.AccessController.doPrivileged(Native Method)
    at sun.rmi.transport.Transport.serviceCall(Transport.java:196)
    at sun.rmi.transport.tcp.TCPTransport.handleMessages(TCPTransport.java:568)
    at sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run0(TCPTransport.java:826)
    at sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.lambda$run$0(TCPTransport.java:683)
    at java.security.AccessController.doPrivileged(Native Method)
    at sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run(TCPTransport.java:682)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
    at java.lang.Thread.run(Thread.java:748)
```

#### 报错原因：

- Web 项目中没有导入自定义的依赖包

#### 解决办法：

- Eclipse 中，可以按照下面的步骤解决该问题：
    - 打开 Markers 选项卡（Windows > Show View > Markers)
    - 展开 "Classpath Dependency Validator Message"
    - 右键 "Classpath entry org.eclipse.jdt.USER_LIBRARY/struts2 will not be exported or published. Runtime ClassNotFoundExceptions may result."
    - 点击 "Quick Fix"
    - 选择 "Mark the associated raw classpath entry as a publish/export dependency."
    - 点击 "Finish"
- IDEA 中，可以按照下面的步骤解决：
![解决方法](http://wx1.sinaimg.cn/mw690/a6e9cb00ly1fgf11jojlwj21kw1bpdoe.jpg)

#### 参考：

[stackoverflow.com](https://stackoverflow.com/questions/23421278/exception-starting-filter-struts2-java-lang-classnotfoundexception-org-apache-s)

<br/>
### !!! JUnit version 3.8 or later expected:

#### 报错信息：

```
!!! JUnit version 3.8 or later expected:

java.lang.RuntimeException: Stub!
    at junit.runner.BaseTestRunner.<init>(BaseTestRunner.java:5)
    at junit.textui.TestRunner.<init>(TestRunner.java:54)
    at junit.textui.TestRunner.<init>(TestRunner.java:48)
    at junit.textui.TestRunner.<init>(TestRunner.java:41)
    at com.intellij.rt.execution.junit.JUnitStarter.junitVersionChecks(JUnitStarter.java:224)
    at com.intellij.rt.execution.junit.JUnitStarter.canWorkWithJUnitVersion(JUnitStarter.java:207)
    at com.intellij.rt.execution.junit.JUnitStarter.main(JUnitStarter.java:61)
```

#### 报错原因：

Android 平台（android.jar）已经包含了 JUnit 类。当你试图用新的 JUnit 注解测试代码时，IDEA 测试运行这些类并认为这些类来自旧的 JUnit，所以得到了这个错误信息。
>[原文](https://stackoverflow.com/questions/2422378/intellij-idea-with-junit-4-7-junit-version-3-8-or-later-expected)：This problem happens because Android Platform (android.jar) already contains JUnit classes. IDEA test runner loads these classes and sees that they are from the old JUnit, while you are trying to use annotated tests which is a feature of the new JUnit, therefore you get the error from the test runner.

#### 解决办法：

- 打开 Project Structure > Modules > Dependencies
- 移除 你自己导入的 JUnit-x.x.jar.

<br/>
## MySQL Issues

### #1089-incorrect prefix key

```MySQL
CREATE TABLE `table`.`users` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL,
    `password` VARCHAR(50) NOT NULL,
    `dir` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id`(11))
) ENGINE = MyISAM;
```
#### 报错信息：

#1089-incorrect prefix key;the used key part isn't a string,the used length is longer than the key part,or the storage engine doesn't support unique prefix keys.

#### 报错原因：

- 在定义 PRIMARY KEY 时候使用了 `(id(11))`, 这定义了 prefix key —— 也就是主键前面的 11 个字符只能用来创建索引。prefix key 只支持 CHAR、VARCHAR、BINARY 和 VARBINARY 类型，而这里使用了 int 类型，所以报错了。翻译自 [stackoverflow](http://stackoverflow.com/questions/28932281/what-is-wrong-with-my-sql-here-1089-incorrect-prefix-key)。

#### 解决办法：

- 将
```MySQL
PRIMARY KEY (`id`(11))
```
改为
```MySQL
PRIMARY KEY (`id`)
```

#### 参考：

[MySQL 官方文档](https://dev.mysql.com/doc/refman/5.5/en/create-index.html)

<br/>
### com.mysql.jdbc.exceptions.jdbc4.CommunicationsException: Communications link failure

#### 报错信息：

com.mysql.jdbc.exceptions.jdbc4.CommunicationsException: Communications link failure.
The last packet sent successfully to the server was 0 milliseconds ago. The driver has not received any packets from the server.

#### 报错原因：

- 未开启 mysql 服务

#### 解决办法：

- 启动 mysql 服务

<br/>
### 使用 PreparedStatement 将中文数据存入 mysql 中显示 "?"

#### 表现形式：

- 在数据库中查看插入的中文数据全都显示 "?"，Java 取出来的数据也显示 "?"
- 在数据库工具中手动插入的中文数据正常显示，Java 取出来的数据也正常显示。
- preparedStatement 语句执行前，通过
```Java
System.out.println(preparedStatement.toString());
```
输出的 mysql 语句，其中文数据也显示 ?
```
com.mysql.jdbc.JDBC42PreparedStatement@4102b8: INSERT INTO catgory VALUES ('d6509', '??', 1)
```

#### 问题原因：

设置驱动时未指定编码格式。

#### 解决办法：

将原先的数据库驱动配置
```
jdbc:mysql://localhost:3306/数据库名
```
改为
```
jdbc:mysql://localhost:3306/数据库名?characterEncoding=utf8
```
>其中数据库名为你自己的数据库名称

<br/>
### Unknown systme variable 'xxxx'

#### 表现形式：

- 执行 SQL 或连接数据库时提示类似 `[HY000][1193] Unknown system variable 'OPTION'` 的错误

#### 问题原因：

MySQL 版本和 JDBC 驱动版本不一致导致的

#### 解决办法：

更换与当前 MySQL 对应的 JDBC 驱动

<br/>
## HTML Issues

<br/>
## Git

### You asked to pull from the remote 'master', but did not specify
a branch. 

#### 错误提示：
You asked to pull from the remote 'master', but did not specify
a branch. Because this is not the default configured remote
for your current branch, you must specify a branch on the command line.

#### 报错原因：

你拉取指定名为 “master” 的远程仓库，但是该远程仓库没有指定分支。因为你当前的分支不是默认的远程仓库，所以必须要指定一个分支。

#### 解决办法：

- 编辑项目下的 `.git/config` 文件，加入下面的代码：
```
[branch "master"]
  remote = origin
  merge = refs/heads/master
```

#### 参考：

[StackOverFlow](http://stackoverflow.com/questions/4847101/git-which-is-the-default-configured-remote-for-branch)

<br/>
## IntelliJ IDEA

### java: Compilation failed: internal java compiler error

#### 错误提示：

![错误提示](http://wx3.sinaimg.cn/mw690/a6e9cb00ly1fgrfd1loxcj20yg04wdm9.jpg)

#### 报错原因：

- 代码中使用了高版本的 Java 特性，而项目的编译器版本低于该版本，导致无法编译。

#### 解决办法：

- 设置项目的编译器版本高于等于支持该特性的 Java 版本

![错误提示](http://wx1.sinaimg.cn/mw690/a6e9cb00ly1fgrfgso7ktj21kw14dqaa.jpg)
>此设置只是表明了该项目支持的最低 JDK 版本，与项目中用到的 JDK 无关。

<br/>
## Eclipse

### An internal error occurred during: “Launching Project”. Java.lang.NullPointerException.

#### 错误提示：

![错误提示](http://wx4.sinaimg.cn/mw690/a6e9cb00ly1ffyhhppv7kj20aa07jdfx.jpg)

#### 报错原因：

- 我的报错原因大概是写代码的时候突然断电，笔记本上没有电池，开机之后就这样了

#### 解决办法：

1. 退出 eclipse
2. 进入 eclipse 的工作区间
3. 删除 .metadata 文件夹，确保 .metadata 文件夹得隐藏文件也要删除
4. 重启 eclipse，并重新导入你的工程
5. 常用设置也被还原了，记得改回来...TAT

<br/>
## Framework

### Spring: java.lang.IllegalArgumentException

#### 错误提示：

```
java.lang.IllegalArgumentException
    at org.springframework.asm.ClassReader.<init>(Unknown Source)
    at org.springframework.asm.ClassReader.<init>(Unknown Source)
    at org.springframework.asm.ClassReader.<init>(Unknown Source)
    at org.springframework.core.type.classreading.SimpleMetadataReader.<init>(SimpleMetadataReader.java:52)
    at org.springframework.core.type.classreading.SimpleMetadataReaderFactory.getMetadataReader(SimpleMetadataReaderFactory.java:80)
    at org.springframework.core.type.classreading.CachingMetadataReaderFactory.getMetadataReader(CachingMetadataReaderFactory.java:101)
    at org.springframework.core.type.classreading.SimpleMetadataReaderFactory.getMetadataReader(SimpleMetadataReaderFactory.java:76)
    at org.springframework.context.annotation.ConfigurationClassParser.getImports(ConfigurationClassParser.java:298)
    at org.springframework.context.annotation.ConfigurationClassParser.getImports(ConfigurationClassParser.java:300)
    at org.springframework.context.annotation.ConfigurationClassParser.getImports(ConfigurationClassParser.java:300)
    at org.springframework.context.annotation.ConfigurationClassParser.doProcessConfigurationClass(ConfigurationClassParser.java:230)
    at org.springframework.context.annotation.ConfigurationClassParser.processConfigurationClass(ConfigurationClassParser.java:153)
    at org.springframework.context.annotation.ConfigurationClassParser.parse(ConfigurationClassParser.java:130)
    at org.springframework.context.annotation.ConfigurationClassPostProcessor.processConfigBeanDefinitions(ConfigurationClassPostProcessor.java:285)
    at org.springframework.context.annotation.ConfigurationClassPostProcessor.postProcessBeanDefinitionRegistry(ConfigurationClassPostProcessor.java:223)
    at org.springframework.context.support.AbstractApplicationContext.invokeBeanFactoryPostProcessors(AbstractApplicationContext.java:630)
    at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:461)
    at org.springframework.web.context.ContextLoader.configureAndRefreshWebApplicationContext(ContextLoader.java:383)
    at org.springframework.web.context.ContextLoader.initWebApplicationContext(ContextLoader.java:283)
    at com.demo.web.listener.InitApplicationListener.contextInitialized(InitApplicationListener.java:32)
    at org.apache.catalina.core.StandardContext.listenerStart(StandardContext.java:4729)
    at org.apache.catalina.core.StandardContext.startInternal(StandardContext.java:5167)
    at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:150)
    at org.apache.catalina.core.ContainerBase.addChildInternal(ContainerBase.java:725)
    at org.apache.catalina.core.ContainerBase.addChild(ContainerBase.java:701)
    at org.apache.catalina.core.StandardHost.addChild(StandardHost.java:717)
    at org.apache.catalina.startup.HostConfig.deployWAR(HostConfig.java:945)
    at org.apache.catalina.startup.HostConfig$DeployWar.run(HostConfig.java:1768)
    at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
    at java.util.concurrent.FutureTask.run(FutureTask.java:266)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
at java.lang.Thread.run(Thread.java:745)
```

#### 报错原因：

ASM 与 JDK 8 不兼容

#### 解决办法：

如果你想继续使用 JDK 8 的话，需要使用 Spring 4.0 或更高版本。

#### 参考：

[CSDN](http://blog.csdn.net/sgls652709/article/details/49878741)

<br/>

### Mybatis: org.apache.ibatis.binding.BindingException

#### 错误信息：

org.apache.ibatis.binding.BindingException: Invalid bound statement (not found)

#### 报错原因：

- 这个问题，通常是由 Mapper interface 和对应的 xml 文件的定义对应不上引起的，这时就需要仔细检查对比包名、xml 中的 namespace、接口中的方法名称等是否对应。

#### 解决办法：


1. 检查 xml 文件所在 package 名称是否和 Mapper interface 所在的包名一一对应；
2. 检查 xml 的 namespace 是否和 xml 文件的 package 名称一一对应；
3. 检查方法名称是否对应；
4. 去除 xml 文件中的中文注释；
5. 随意在 xml 文件中加一个空格或者空行然后保存。

#### 参考：

[mybatis 绑定错误](http://blog.csdn.net/softwarehe/article/details/8889206)

<br/>

### SpringMVC: java.lang.IllegalStateException: getOutputStream() has already been called for this response

#### 报错信息：


```
七月 05, 2017 9:27:36 下午 org.apache.catalina.core.ApplicationDispatcher invoke
严重: Servlet.service() for servlet jsp threw exception
java.lang.IllegalStateException: getOutputStream() has already been called for this response
    at org.apache.catalina.connector.Response.getWriter(Response.java:662)
    at org.apache.catalina.connector.ResponseFacade.getWriter(ResponseFacade.java:213)
    at javax.servlet.ServletResponseWrapper.getWriter(ServletResponseWrapper.java:104)
    at org.apache.jasper.runtime.JspWriterImpl.initOut(JspWriterImpl.java:125)
    at org.apache.jasper.runtime.JspWriterImpl.flushBuffer(JspWriterImpl.java:118)
    at org.apache.jasper.runtime.PageContextImpl.release(PageContextImpl.java:186)
    at org.apache.jasper.runtime.JspFactoryImpl.internalReleasePageContext(JspFactoryImpl.java:125)
    at org.apache.jasper.runtime.JspFactoryImpl.releasePageContext(JspFactoryImpl.java:79)
    at org.apache.jsp.jsp.product.productList_jsp._jspService(productList_jsp.java:678)
    at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:70)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:731)
    at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:439)
    at org.apache.jasper.servlet.JspServlet._serviceJspFile(JspServlet.java:395)
    at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java)
    at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:339)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:731)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:303)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:208)
    at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:743)
    at org.apache.catalina.core.ApplicationDispatcher.doInclude(ApplicationDispatcher.java:603)
    at org.apache.catalina.core.ApplicationDispatcher.include(ApplicationDispatcher.java:542)
    at org.springframework.web.servlet.view.InternalResourceView.renderMergedOutputModel(InternalResourceView.java:160)
    at org.springframework.web.servlet.view.AbstractView.render(AbstractView.java:303)
    at org.springframework.web.servlet.DispatcherServlet.render(DispatcherServlet.java:1286)
    at org.springframework.web.servlet.DispatcherServlet.processDispatchResult(DispatcherServlet.java:1041)
    at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:984)
    at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:901)
    at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)
    at org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:872)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:650)
    at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:731)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:303)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:208)
    at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:52)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:241)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:208)
    at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:197)
    at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:241)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:208)
    at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:218)
    at org.apache.catalina.core.StandardContextValve.__invoke(StandardContextValve.java:110)
    at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java)
    at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:506)
    at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:169)
    at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:103)
    at org.apache.catalina.valves.AccessLogValve.invoke(AccessLogValve.java:962)
    at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:116)
    at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:445)
    at org.apache.coyote.http11.AbstractHttp11Processor.process(AbstractHttp11Processor.java:1115)
    at org.apache.coyote.AbstractProtocol$AbstractConnectionHandler.process(AbstractProtocol.java:637)
    at org.apache.tomcat.util.net.JIoEndpoint$SocketProcessor.run(JIoEndpoint.java:316)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
    at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
    at java.lang.Thread.run(Thread.java:748)
七月 05, 2017 9:27:36 下午 org.apache.catalina.core.StandardWrapperValve invoke
严重: Servlet.service() for servlet [SpringMVC] in context with path [] threw exception [java.lang.IllegalStateException: getOutputStream() has already been called for this response] with root cause
java.lang.IllegalStateException: getOutputStream() has already been called for this response
    at org.apache.catalina.connector.Response.getWriter(Response.java:662)
    at org.apache.catalina.connector.ResponseFacade.getWriter(ResponseFacade.java:213)
    at javax.servlet.ServletResponseWrapper.getWriter(ServletResponseWrapper.java:104)
    at org.apache.jasper.runtime.JspWriterImpl.initOut(JspWriterImpl.java:125)
    at org.apache.jasper.runtime.JspWriterImpl.flushBuffer(JspWriterImpl.java:118)
    at org.apache.jasper.runtime.PageContextImpl.release(PageContextImpl.java:186)
    at org.apache.jasper.runtime.JspFactoryImpl.internalReleasePageContext(JspFactoryImpl.java:125)
    at org.apache.jasper.runtime.JspFactoryImpl.releasePageContext(JspFactoryImpl.java:79)
    at org.apache.jsp.jsp.product.productList_jsp._jspService(productList_jsp.java:678)
    at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:70)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:731)
    at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:439)
    at org.apache.jasper.servlet.JspServlet._serviceJspFile(JspServlet.java:395)
    at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java)
    at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:339)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:731)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:303)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:208)
    at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:743)
    at org.apache.catalina.core.ApplicationDispatcher.doInclude(ApplicationDispatcher.java:603)
    at org.apache.catalina.core.ApplicationDispatcher.include(ApplicationDispatcher.java:542)
    at org.springframework.web.servlet.view.InternalResourceView.renderMergedOutputModel(InternalResourceView.java:160)
    at org.springframework.web.servlet.view.AbstractView.render(AbstractView.java:303)
    at org.springframework.web.servlet.DispatcherServlet.render(DispatcherServlet.java:1286)
    at org.springframework.web.servlet.DispatcherServlet.processDispatchResult(DispatcherServlet.java:1041)
    at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:984)
    at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:901)
    at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)
    at org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:872)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:650)
    at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:731)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:303)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:208)
    at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:52)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:241)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:208)
    at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:197)
    at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:241)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:208)
    at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:218)
    at org.apache.catalina.core.StandardContextValve.__invoke(StandardContextValve.java:110)
    at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java)
    at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:506)
    at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:169)
    at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:103)
    at org.apache.catalina.valves.AccessLogValve.invoke(AccessLogValve.java:962)
    at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:116)
    at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:445)
    at org.apache.coyote.http11.AbstractHttp11Processor.process(AbstractHttp11Processor.java:1115)
    at org.apache.coyote.AbstractProtocol$AbstractConnectionHandler.process(AbstractProtocol.java:637)
    at org.apache.tomcat.util.net.JIoEndpoint$SocketProcessor.run(JIoEndpoint.java:316)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
    at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
    at java.lang.Thread.run(Thread.java:748)
```

#### 报错原因：

1. HTTP 的基本原则：一个请求，一个响应。你只能将一件事送回请求。HTML 页面或 PDF 文档或图像等。如果您已经获得了输入/输出流，则 Java 会抱怨，因为你应该只获取其中的一个。
2. 在 <% 或 %> 后面有空格或空行

我遇到的是第一种。

#### 解决办法：

1. 我属于第一种情况，下载文件的 action 在文件下载后又返回了一个 boolean 值到请求，导致该问题。我将该方法的返回类型更改为 void 后问题解决。参考 [stackoverflow](https://stackoverflow.com/questions/25909657/java-lang-illegalstateexception-getoutputstream-has-already-been-called-for-t)
2. 第二种我没遇到，[stackoverflow 上的回答](https://stackoverflow.com/questions/1776142/getoutputstream-has-already-been-called-for-this-response)：
Ok, you should be using a servlet not a JSP but if you really need to... add this directive at the top of your page:

```jsp
<%@ page trimDirectiveWhitespaces="true" %>
```

Or in the jsp-config section your web.xml
```xml
<jsp-config>
  <jsp-property-group>
    <url-pattern>*.jsp</url-pattern>
    <trim-directive-whitespaces>true</trim-directive-whitespaces>
  </jsp-property-group>
</jsp-config>
```

Also flush/close the OutputStream and return when done.
```java
dataOutput.flush();
dataOutput.close();
return;
```

## Tools

### SQL Developer 连接 Oracle 数据库被拒绝

#### 报错信息：

- 状态: 失败 -测试失败: Listener refused the connection with the following error:
ORA-12505, TNS:listener does not currently know of SID given in connect descriptor.

#### 报错原因：

- 服务器是集群的，所以连接属性上不能选择 sid，而应该选择「服务名」。

#### 解决办法：

- 将连接属性改成「服务名」，如图：
![新建/修改数据库连接](http://wx2.sinaimg.cn/mw690/a6e9cb00ly1finmzwhm4jj215o0na78c.jpg)
