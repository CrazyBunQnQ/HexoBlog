---
title: JSP 之 EL 表达式
date: 2017-4-28 9:11:29
categories: 
- Java 基础
- 未完成
tags: 
- JSP
- EL 表达式
---

**EL 简介：**
- EL (Expression Language) 是 JSP 内置的表达式语言，用于访问页面的上下文以及不同作用域的对象，取得对象属性的值，或执行简单的有运算或判断操作，EL 在得到某个数据时，会自动进行数据类型的转换。
- EL 表达式用于代替 JSP 表达式(<%=%>) 在页面中做输出操作。

<!--more-->

```JSP
${变量}
${对象.属性}
${requestScope.requestName}
${sessionScope.requestName}
```
等同于

```JSP
<%= 变量 %>
<%= 对象.属性 %>
<%= requestScope.requestName %>
<%= sessionScope.requestName %>
```
- EL 表达式仅仅用来读取数据，而不能对数据进行修改。
- 使用 EL 表达式输出数据时，如果有则输出数据，如果为 null 则什么也不输出。

<br/>
## EL 基本用法：
- EL 表达式总是放在 {} 中，而且前边有一个 $ 作为前缀。
- 获取域中


<br/>
## 页面上下文 (pageContext)
pageContext 的作用域是当前页面
pageContext.setAttribute("","");
String  a = (String)pageContext.getAttribute("name","a");
String  b = (String)pageContext.getAttribute("name","b");
使用 pageContext 检索域
String c = pageContext.findAttribute("name");//会得到最近的 c = b


pageContext：当前页面
request：一次请求中
session：一次会话中
application：服务器声明周期
作用范围依次递增
findAttribute方法会检索四个域，检索的顺序是
1. pageContext
2. request
3. session
4. application
