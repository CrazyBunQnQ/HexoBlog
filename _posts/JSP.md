---
title: 初识 JSP
date: 2017-4-24 9:13:42 
categories: 
- Java 基础
- 待完善
tags: 
- JSP
---

JSP (Java Server Page) 和 Servlet 都是用来解决动态 web 资源的技术。

<!--more-->

## 原理
JSP 页面可以嵌入 Java 脚本，JSP 从本质上讲就是一个 Servlet，访问 JSP 页面本质上就是访问 JSP 对应的 Servlet 程序。
work/Catalina/localhost/项目名/org/apache/jsp/网页名
找到 JSP 对应的 servlet 的 class 文件，该类继承了 HttpJspBase（继承了 HttpServlet）

## JSP 语法
- JSP 模板元素
就是 JSP 页面中的 HTML 代码，定义了网页的基本骨架
- JSP 脚本片段
`<% 脚本代码 %>`
- JSP 表达式
```JSP
<%=变量名%>
```
>**脚本表达式后面不能加分号！脚本片段中每行代码需要加分号！**
- 脚本声明(不常用)，对应 Java 类中
```JSP
<%!
	Java 代码
	private String name;
	static {
		
	}
	public static void main(String[] args) {
		
	}
	public void run() {
		
	}
%>
```
- JSP 注释
```JSP
<%-- 注释内容 --%>
```
>此注释在网页源码中看不到
- JSP 指令
`<%@ 指令类型 属性 %>
	- page 指令：让 JSP 页面选择开发语言
```JSP
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util*, java...."%>
```
language:让 JSP 页面选择开发的语言
import: 导入 jar 包，jsp 自带的包（servlet.* servlet.http.* servlet.jsp.* java.lang），可以在同一个 import 属性下(用逗号隔开)，也可以分多行写
pageEncoding: 设置页面的编码
contentType：设置服务器响应编码
isThreadSafe： 设置线程是否安全（默认为 true 线程安全）
buffer：设置 out 缓存（默认 8 kb）， out 对象输出到浏览器两种情况
	1.等文档加载完毕 
	2.缓冲区已满

	- include 指令：
想 jsp 页面中天健一个片段文件 .jspf
```JSP
<%@ include file="xxx.jspf "%>
```
jspf 片段页面
	- taglib 指令：
标签库 jstl
```JSP
<%@ taglib %>
```
- JSP 内置对象
	- request
	- response
	- out
	- session
	- pageContext
	- ServletContext application
	- ServletConfig config
	- page
	- Throwable exception(只有当页面设置了 isErrorPage="true" 时才出现)

## 转发原理
- 只有一次请求
- 转发不会引起地址栏刷新
- 转发可以携带数据，通过 `request.setAttribute();`
- 转发也不能形成回路

>重定向不可以携带数据
>转发和重定向不可同时使用

## 使用 Servlet + JSP 完成 web 开发


>MVC(Model View Controller) 设计模式
Servlet 负责逻辑控制，数据获取
JSP 负责数据接收，页面的显式
model 对数据进行 CRUD （Dao + entity）)
