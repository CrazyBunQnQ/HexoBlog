---
title: 过滤器和监听器
date: 2017-5-2 14:20:12 
categories: Java
tags: 
- Filter
---
<!--马杨成老师 小马哥 15210094480-->
Filter 可以将 Servlet 中共同的、通用的的代码，抽取出来，形成一个过滤器，然后将这个过滤器配置在需要
改善软件结构。

将 Servlet 上公共的逻辑代码写在过滤器中，通过配置 web.xml 的形式作用到 Servlet 上；
还可以根据 url 请求决定是否访问 servlet 对象。

<!--more-->
## Filter 过滤器
### Filter 配置与实现方法
```Java
//过滤的逻辑写在这里
//FilterChin:过滤器链
public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
	HttpServletRequest request = (HttpServletRequest)req;
	HttpServletResponse response = (HttpServletResponse)res;

	if (!charEncoding.equals(request.getCharacterEncoding())) {
		request.setCharacterEncoding(charEncoding);
	}
	response.setCharacterEncoding("text/html;charset=" + charEncoding);
	chain.doFilter(request, response);

	//调用后续的过滤器或者 Servlet
	chain.doFilter(request, response);
}

//获取配置中设置的过滤器参数
public void init(FilterConfig fConfig) {
	charEncoding = fConfig.getInitParameter("encoding");
	if (charEncoding == null) {
		LOGGER.warn("EncodingFilter 中的编码设置为空！！！设置为默认编码：utf-8");
		charEncoding = "utf-8";
	}
}
```

web.xml 配置过滤器
```XML
<filter>
	<filter-name>EncodingFilter</filter-name>
	<filter-class>com.crazybunqnq.filter.EncodingFilter</filter-class>
	<!--配置过滤器参数-->
	<init-param>
		<param-name>encoding</param-name>
		<param-value>utf-8</param-value>
	</init-param>
</filter>
<filter-mapping>
	<filter-name>EncodingFilter</filter-name>
	<!--配置过滤的路径，可以是页面路径也可以是 Servlet 路径-->
	<url-pattern>/*</url-pattern>
</filter-mapping>
```
>注意！
>过滤器之间按从上到下的顺序依次过滤;
>过滤器要放在 Servlet 配置之前。

### 过滤器的特点：
- 依赖容器（Tomcat 等服务器）；
- 底层通过反射实现的。

过滤器的作用：
- 简化重复逻辑代码；
- 容易维护；
- 代码简洁；
- 结构灵活；


## Listener 监听器
Listener 监听某一个动作发生，一旦发生，需要做一些处理。

Listener 有两大类型：
1. 监听 request session 等对象的创建或者销毁
2. 监听对象的事数据绑定：
request.setAttribute("key",value);
session.setAttribute("key",value);

### 监听 request、session 等对象的创建或者销毁
实例：监听当前服务器的访问人数。
思路：监听 session 对象的创建和销毁方法：
- sessionCreate();
- sessionDestory();

监听器代码：
```Java
public class CountLisenter implements HttpSessionListener{
	/**
	* 访问人数
	*/
	private long count = 0;
	//session 被创建时执行
	public void sessionCreated(HttpSessionEvent arg0) {
		count++;
		updateCount(arg0);
	}
	
	//session 被销毁时执行
	public void sessionDestroyed(HttpSessionEvent arg0) {
		count--;
		updateCount(arg0);
	}

	/**
	* 将 count 存入 application 对象
	*/
	private void updateCount(HttpSessionEvent event) {
		//获取 application 对象
		ServletContext application = event.getSession().getServletContext();
		//将当前服务器访问人数绑定到 对象上，再从 jsp 页面获取
		application.setAttribute("count", count);
	}
}
```

>监听 session： HttpSessionListener
>监听 request： ServletRequestListener
>监听 application： ServletContextListener
>等等，举一反三

配置 监听器（在过滤器之前）
```XML
<listener>
	<listener-class>com.crazybunqnq.listener.CountLisenter</listener-class>
</listener>
```

在 jsp 中通过 `${applicationScope.count}` 或 `${count}` 取出 count 值。

若想设置关闭浏览器的时候销毁 Session 对象，可以在 jsp 页面中设置 onbeforeunload="" 事件
onbeforeunload=""


### 监听器的特点：
- 符合某个动作后，自动调用执行监听器的方法。