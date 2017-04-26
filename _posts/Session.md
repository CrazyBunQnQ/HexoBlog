---
title: Session & Cookie
date: 2017-4-25 9:46:04 


---

浏览器和服务器通信的过程中会产生一些数据，Session 技术可以解决这些数据的保存问题。
会话技术有两种：
- Cookie - 浏览器端的数据存储，将数据保存在浏览器端
- Session - 服务器端的数据存储，将数据保存在服务器端
<!--more-->

## 使用 Cookie 技术保存数据
保存数据，服务器向浏览器写入 Cookie，Cookie 可包含需要保存的数据

服务端存储 Cookie：（需要在跳转页面之前）
```Java
Cookie 缓存名1 = new Cookie("键1", 值1);
缓存名1.setMaxAge(int 类型秒数);//设置缓存有效期（单位秒）
缓存名1.setPath(request.getContexxtPath());//设置缓存路径
Cookie 缓存名2 = new Cookie("键2", 值2);
缓存名2.setMaxAge(int 类型秒数);//设置缓存有效期（单位秒）
缓存名2.setPath(request.getContexxtPath());//设置缓存路径
response.addCookie(缓存名1);
response.addCookie(缓存名2);
```
>setMaxAge(0) 表示强制删除缓存

浏览器取出 Cookie：
```JSP
String 键1 = "";
String 键2 = "";
Cookie[] cookies = request.getCookies();//数组！
if (cookies != null) {//要判断是否为空！
	for (Cookie cookie : cookies) {
		String cookieName = cookie.getName();
		if (cookieName.equals("键1")) {
			键1 = cookie.getValue();
		} else if (cookieName.equals("键2")) {
			键2 = cookie.getValue();
		}
	}
}

<!-- 页面显示调用 -->
<input type="text" value = "<%= 键1 %>" .../>
<input type="text" value = "<%= 键2 %>" .../>
```


## Session
服务器端保存数据的技术

保存 Session 数据
```Java
HttpSession session = request.getSession();
session.setAttribute("键", 值);//可以是对象
```

JSP 取出 Session 数据
```JSP
session.getAttribute("键");
```

清除 Session 数据
session.invalide();


>Servlet 对象：浏览器第一次访问 servlet 服务程序时创建（init()），服务器停止时销毁。
>ServletConfig 对象：Servlet 对象初始化的时候创建（init()）
>request 和 response 对象：每一次请求都会创建一组request 和 response，一次请求结束时销毁。
>ServletContext 对象：服务器启动时创建，服务器停止时销毁
>Session 对象：保存服务器和浏览器通信数据的技术，当浏览器第一次访问 `request.getSession()` 时会为每一个用户创建一个独有的 Session 对象。session 对象默认会在无人调用 30 分钟后自动销毁。也可通过 `session.invalide();` 配置 web.xml 文件设置销毁设置：
```XML
<session-config>
	<!-- 单位为分钟 -->
	<session-timeout>20</session-timeout>
</session-config>
```
**注意：**
- **正常**关闭服务器的话是不会销毁 session对象的，session 持久化到硬盘上，同样也是默认在 30 分钟后销毁。
- **非正常**关闭服务器的话会直接销毁 session 对象

request.getSession();会判断当前服务器有没有为该用户创建 session 对象，如果有 session 对象或拿到已经创建好的 session 对象，则为用户服务，如果没有，就创建
如果已经为用户创建了 session 那么会写给浏览器一个 cookie对象（JSESSIONID）
当浏览器再次访问服务器的时候，会携带 cookie 对象（JESSIONID）
浏览器会话时间结束：关闭浏览器

## 域对象
- 域对象是个容器，request、session 和 application
- 域对象有作用范围：
	- request：一次请求中（每次请求都有 request 对象）
	- session：一次会话中（每个用户都有一个 session 对象）
	- application：服务器的生命周期中（并且所有用户共享）

>getAttribute() 和 getParamater() 不要搞混了哟：
>request.getAttribute() 是从 request 容器中获取，返回对象，必然会有转发
>request.getParameter() 获取页面中的参数，返回字符串

避免从缓存中取数据的方法：在请求地址后面加上一个当前时间的参数：
```JavaScript
img.src = "<% lujing %>/img?time = " + new Date().getTime();
```