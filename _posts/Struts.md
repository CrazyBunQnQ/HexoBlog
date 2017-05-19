---
title: struts2
date: 2017-5-18 14:19:04 
categories: 
- 框架
- Java 基础
tags: 
- struts2
- 框架
---

Struts2 前身是 weborek 框架，优点是封装、重用、代码简洁、编码速度快、准确度高。

<!--more-->

## Struts2
Struts2 是个 Web MVC 框架

### MVC：
- Controller 控制层
	- DispatcherServlet 总控制器（继承 HttpServlet），分发请求。
	- XXXController 分控制器，接受请求数据、调用业务模型、页面跳转（转发重定向）。
- Model 业务模型层
	- Service 业务逻辑，处理棘突业务逻辑的。
	- DAO（数据持久层）
- View 视图层
	- 呈现数据，用户交互

View → 发出请求 → 总控制器 → 分发请求 → 分控制器 → 接收数据 ←→ 调用 Service ←→ 调用 DAO （CRUD）→ DB
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↓
									页面跳转

## **Struts2 入门开发**
首先要[下载 struets2 资源包]()（jar 包、源码、示例代码）
1. 创建 web 项目
2. 引入 jar 包
	1. commons-fileupload 上传
	2. commons-io 下载
	3. commons-lang 
	4. freemarker 模板
	5. javassist 改变字节码
	6. ognl 一种表达式
	7. struts2-core 核心包
	8. xwork-core webwork 核心包
3. 配置 Struts2 的总控制器
```XML
<filter>
	<filter-name>StrutsFilter</filter-name>
	<filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
</filter
<filter-mapping>
	<filter-name>StrutsFilter</filter-name>
<!-- 默认后缀名为 .action 或者无后缀 -->
	<url-pattern>/*<url-pattern>
</filter-mapping>
```

4. 编写处理请求的 Action 类（分控制器）**继承 ActionSupport类**
**方法一定是无参的，并且返回 String 类型** 返回的字符串和页面是一一对应的.

5. 在类路径创建一个 **struts.xml** 文件
配置请求 url 地址和 Action 的对应关系
```XML
配置文件头从 struts2-core 包中拷贝 struts-default.xml 过来即可
<struts>
	<!-- 配置包
	name:包名
	extends:继承
	 -->
	<package name="com.crazybunqnq.action" extends="struts-default" namespace="/">
		<!-- 配置 url 请求和哪个 Action 对应
		name:配置的请求 url
		class:action 类的全路径
		method:方法名，默认为 execute
		-->
		<action name="login" class="com.crazybunqnq.LoginAction" method="doLogin">
			<!-- 配置 Action 类返回的结果对应的页面
			name:方法返回的字符串
			type:响应类型，默认为转发"dispatcher"，改为 "redirect" 则变为重定向跳转，
改为 redirectAction 则重定向到另一个 Action ...
			-->
			<result name="success">/main.jsp</result>
		</action>
	</package>	
</struts>
```

### 执行流程
url-发出请求-  action-方法-result-jsp

### 页面到 action 的传值和 action 到页面的传值

Action 中的属性与页面请求的参数名相同，并设置好 get 和 set 方法即可。

发送请求时会先获取请求参数值并调用set方法，再调用 action 的方法。

//底层请求参数 设置给set方法的形参，再给属性赋值
```
http://...../login?name=xxx&age=5&interest=eat&interest=play
```
```Java
private String name;
private int age
private String[] interest;
private User user;

public void setName(String name) {
	this.name = name;
}

public void setAge(int age){
	this.age = age;
}
```
el 表达式 一次从 pageContext request action session application 中取值


表单中若要传递对象，则需要这样写：
```HTML
<input name="user.username"/>
```


## namespace 命名空间

分门别类,区分不同包的同名请求，当多个 package 的 action 冲突的时候，可以根据 namespace 区分
```
<package name="com.crazybunqnq.action" extends="struts-default" namespace="/emp">
```

>默认值是"/"，但不建议用默认值