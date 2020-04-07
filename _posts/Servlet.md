---
title: 初识 Servlet
date: 2017-4-21 10:44:22
categories: Java
tags:
- Servlet
---

## Servlet 生命周期
1. 初始化阶段
第一次访问 Servlet 时，调用 init() 方法
之后再次访问该 Servlet 时，会使用已经创建好的 servlet 为用户服务
Servlet 是一个多线程的。
2. 服务阶段(响应客户请求)
会调用 service() 方法
3. 终止阶段
服务器关闭的时候会调用 destroy() 方法

<!--more--> 

<br/>
## Servlet 相关对象的创建
### request (客户端请求对象)
```Java
request.getParameter("safsd");//获取指定参数的值
request.getParameterValues("safsdf");//获取指定参数的数组
request.getContextPath();//获取项目根路径
Enumeration request.getHeaderNames();//获取请求头列表
request.getHeader("User-Agent");//获取指定请求头内容
request.getMethod();//获取请求方式
request.getRequestURL();//获取请求的路径
request.getResquestURI();//获取请求的资源在服务器中的位置（相对位置 ）
request.getRemoteHost();//获取客户端的 IP 地址
```


<br/>
### response (浏览器的响应对象)
```Java
response.setContentType("text/html;charset=utf-9");//设置服务器的响应
PrintWriter out = response.getWriter();//获取服务器的输出字符流
OutputStream os = response.getOutputStream();//输出字节流流
response.sendRedirect(request.getContextPath() + "/xxxx");//请求重定向
```
>只能获取一个输出流

<br/>
### ServletConfig (servlet 配置信息对象)
init(ServletConfig config) 时可以获取 web.xml 内 <servlet> 标签下配置的 <init-param> 属性
```Java
String charset = config.getInitParameter("charset");
String name = config.getInitParameter("name");
config.getInitParameterNames();//获取所有的初始化参数的 name
```

```XML
<servlet>
	...
	<init-param>
		<param-name>chaarset</param-name>
		<param-value>utf-8</param-value>
	</init-param>
	<init-param>
		<param-name>name</param-name>
		<param-value>value</param-value>
	</init-param>
</servlet>
```

<br/>
### ServletContext (代表当前的 web 应用)
该对象会在服务器启动的时候创建，在服务器关闭的时候销毁。
获取 ServletContext 对象方法：
1. 通过 `this.getServletContext()` 方法
```Java
ServletContext application = this.getServletContext();
```

2. 通过 `request.getSesson()` 方法
```Java
ServletContext application = request.getSesson()
```

ServletContext 对象的用途：
```Java
application.getContextPath();//获取当前 web 应用路径
application.getInitParameter("contextname");//获取 web 初始化参数(该参数配置在 web.xml 文件的根标签中) 
```

```XML
<context-param>
	<param-name>contextname</param-name>
	<param-value>contextvalue</param-value>
</context-param>
```

<br/>
## 创建 Servlet 文件

<br/>
## 使用一个 Servlet 完成 CRUD

<br/>
## ※ 重定向的概念 ※

```Java
response.sendRedirect("重定向地址");
response.sendRedirect(request.getContextPath() + "/xxxx");//请求重定向
```
1. 会创建两组 request 和 response 对象
2. 会导致浏览器的地址栏刷新
3. 可以多次重定向但是不能形成死循环
4. 重定向前不能关闭 response 的输出流（服务器会自动关闭流）

<br/>
## 服务器响应状态码
302 重定向
200 ok
404 找不到资源
500 服务器内部错误
304 表示从缓存中取数据

<br/>
### 配置错误页面
在 web.xml 中配置错误处理页面
```XML
<error-page>
	<error-code>404</error-code>
	<location>/404.html</location>
</error-page>
<error-page>
	<error-code>500</error-code>
	<location>/500.html</location>
</error-page>
```