---
title: struts2
date: 2017-5-18 14:19:04 
categories: Java
tags: 
- 框架
- struts2
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

4. 编写处理请求的 Action 类（分控制器）**继承 ActionSupport 类**
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
			type:响应类型，默认为转发 "dispatcher"，改为 "redirect" 则变为重定向跳转，
改为 redirectAction 则重定向到另一个 Action ...
			-->
			<result name="success">/main.jsp</result>
		</action>
	</package>	
</struts>
```


### 全局配置
<!--全局 result-->
<global-results>
	<result name="error" >/error.jsp</result>
</global-results>
<!--全局异常-->
<global-exception-mappings>
	<exception-mapping result="error" exception="java.lang"></exception-mapping>
</global-exception-mappings>



### 执行流程
url-发出请求-  action-方法-result-jsp

### 页面到 action 的传值和 action 到页面的传值

Action 中的属性与页面请求的参数名相同，并设置好 get 和 set 方法即可。

发送请求时会先获取请求参数值并调用 set 方法，再调用 action 的方法。

//底层请求参数 设置给 set 方法的形参，再给属性赋值
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
</package>
```

>默认值是"/"，但不建议用默认值

## struts2 访问 request response session
1. 不推荐
```Java
//获取原始类型的 request 和 response 对象一次请求 一次响应期间
HttpServletRequest request = ServletActionContext.getRequest();
HttpServletRequest response = ServletActionContext.getResponse();
//获取 session
HttpSession session = request.getSession();
//获取 Servlet 上下文，对于一个应用，它是唯一的
ServletContext application = ServletActionContext.getServletContext();
```


2. ActionContext
返回 Map 类型的 request response session 对象
```Java
Map<String, Object> request = (Map<String, Object>)ActionContext.getContext().get("request");
Map<String, Object> session = ActionContext.getContext.getSession();
Map<String, Object> application = (Map<String, Object>)ActionContext.getContext().getApplication();

requset.put("r", "requset");
session.put("s", "session");
application.put("a", "application");
```

3. 注入式(推荐)
以上两种访问方式都是侵入式编程
实现接口
Action ... implements RequestAware,SessionAware,ApplicationAware
实现接口方法后，参数就是 request session application 对象
```Java
private Map<String , Object> appliacation;
setApplication(Map<String, Object> application) {
	this.application = application;
}
```

推荐将获取 session 等对象封装到一个基类中，例如 BaseAction.java:
```Java
public class BaseAction extends ActionSupport implements RequestAware, SessionAware, ApplicationAware {

	protected Map<String, Object> appliacation;
	protected Map<String, Object> request;
	protected Map<String, Object> session;

	@Override
	public void setApplication(Map<String, Object> appliacation) {
		this.application = application;
	}

	@Override
	public void setApplication(Map<String, Object> request) {
		this.session = request;
	}

	@Override
	public void setApplication(Map<String, Object> session) {
		this.session = session;
	}
}
```

## result type
```XML
<result type="..."></result>
```
>result name 默认为 success
>配置文件可以使用 el 表达式

### dispatcher 
转发到页面
<result type="dispatcher">

### freemaker

### stream
流响应，服务器发送给浏览器的是 流格式的数据(byet 序列)，可以用来下载
```XML
<result name="success" type="stream">
	<param name="inputName">is</parm>
	<!--
	contentDisposition
	attachment:保存 另存 提示
	inline ： 直接在浏览器打开【默认】
	-->
	<param name="contentDisposition">attachment;filename=${filename}</param>
	<param name="bufferSize">5*1024</param><!--5K 缓冲区，默认 1024-->
	<param name="contentType">text/pl..</param>
</result>
```

```Java
class DownloadAction{
	private String filename;//下载文件名
	private InputStream is;//用来接收下载的文件内容	

	set...
	getFilename() {
		return urlencoder.encode(filename, "utf-8");
	}

	public String execute() {
		filename="1.png";
		//根据逻辑路径“download”获取实际发布到服务器上的文件物理路径
		String realPath = ServletActionContext.getServletContext().getRealPath("/download");
		String downPath = realPath + "/" + filename;
		//将要下载的文件内容 转换为 byte by byte
		is = new FileInputStream(new File(downPath));
		return "success";
	}
}
```

没有保存的下载（如验证码）：
```XML
<result type="stream">
	inputName>inputStream
	bufferSize>5*1024
</result>
```

```JAVA
Map<string, bufferedImage> map = ImageUtil.getImage();
String code = map.keySet().iterator().next();
BufferedImage img = map.get(code);
//将 image 对象 转换成 InputStream 格式 发送给浏览器
ByteArrayoutputStream baos = new ByteArrayOutputStream(inputStream);
JPEGCodec jp = JPEGCodec.createJPEGEncoder(baos);
jp.encode(image);
//转化流
inputStream = new ByteArrayInputStream(baos.toByteArray());
return SUCCESS;
```

### json
服务器发送给浏览器的是 json 数据
- **需要引入 struts-json-plugin.jar（中间件）**
- **需要改配置文件继承 json-default**

<result type="json" class="org.apache.struts2.json.JSONResult">
1.如果这里什么都不写，会将 action 中所有的属性，转换成 json 格式 发送给浏览器
2.通过 incluDEProperties 将制定的属性以 json 格式发送给浏览器
3.如果返回的是 list，则需要加上.*
	<param name="includeProperties">flag,sfdf</param><!--要返回的数据-->
</result>

### jfreechart 、highchart
图表响应，需要导入 jfreechart 或 highchart 包
>工厂设计模式
>(20 多种涉及模式)

### chain
转发到 Action

### redirect
重定向到 jsp 页面
>jsp 无法渠道 action 属性的值

### redirectAction
重定向到另外一个 Action 类

### chain 与 redirectAction 区别
- chain 两个 Action 可以共享值
- redirectAction 两个 Action 无法共享值

示例：
```Java
private String name;

setName()

getName

public String excute() {
sysout( "action1 name" + name);
return SUCCESS;
}



private String name;

setName()

getName

public String excute() {
sysout( "action2 name" + name);
return SUCCESS;
}

```

chain01.jsp:
```JSP
form action chain01.action
name="name"
submit
/form
```

struts.xml:
```XML
action name= chain01
result type = chain
chain02

action name=chain02
result type dispatcher
index.jsp
```

访问 chain01.jsp
action01 获取值
chain 转发到 action02
action02 也能获取 chain01.jsp 提交的值

若使用 重定向 则 action02 拿不到 chain01.jsp 提交的值


>跨包调用 action
```XML
<result>
	<param name="namespace">/aaa</param>
	<param name="actionName">/chain02</param>
</result>
```


Two to two,too two to two.Two two,too two to two,too1. 决定是否可以访问 action 对象
将 action 的共同逻辑编写在拦截器中

## 拦截器 Interceptor
拦截 action 对象，其你去过来不立即走 action 二十先走 拦截器
1. 决定是否可以访问 action 对象
2. 将 action 的共同逻辑编写在拦截器中
3.


### 自定义拦截器
1. 定义拦截器，实现 Interceptor 或 继承 MethodFilterInterceptor 或 AbstractInterceptor
```Java
//public  class TimeInterceptor implements Interceptor {
//public class TimeInterceptor extends MethodFilterInterceptor {
public  class TimeInterceptor extends AbstractInterceptor {
	//ActionInvocation 是 action 对象的执行者
	@Override
	public String interept(ActionInvocation invocation) thorws ... {
		long start = System.currentTimeMillis();
		String result = invocation.invoke();//调用后续的拦截器或者 action 对象
		long end = System.currentTimeMillis();
		long time = end - start;
		String className = invocation.getAction().getClass().getSimpleName();
		//代理模式
		String methodName = invocation.getProxy().getMethod();
		String msg = "在" + className + "类的" + methodName + "方法上花费了" + tiom "毫秒"；
		log.info(msg);
		FileWriter fw = new FileWriter(new File("D:\\2a.txt"), true);
		fw.write(msg)
		return result;
	}
}
```

2. 在 struts.xml 中声明拦截器（多个包则每个包都需要声明）
```XML
<package>
	<interceptor name="timeInterceptor" class="..."></interceptor>
	<!--
	1. 如果一个没有配置任何的拦截器 struts 会默认提供一个 defaultStack （默认拦截器栈）
	2. 一旦配置了一个拦截器，则不再提供 defaultStack 拦截器
	3. defaultStack 是个很重要的拦截器，所以若手动配置了其他拦截器一定要加上这个默认拦截器-->
	<interceptor name="defaultStack"></interceptor>
	<!--若配置了 default 则所有 action 都会用默认的拦截器，action 中不再需要配置-->
	<default-interceptor-ref name="timeInterceptor"></default-interceptor-ref>
	<action ...>
		<interceptor-ref name="timeInterceptor"></interceptor-ref>
		...
	</action>
</package>
```

1. 如果一个没有配置任何的拦截器 struts 会默认提供一个 defaultStack （默认拦截器栈）
2. 一旦配置了一个拦截器，则不再提供 defaultStack 拦截器
3. defaultStack 是个很重要的拦截器，所以若手动配置了其他拦截器一定要加上这个默认拦截器

定义拦截器栈
参考 defaultStack

<br/>
### 内置拦截器
fileUpload 上传拦截器
```XML
<interceptor-ref name="fileUpload">
	<param name="maximumSize">1024</param><!-- 最大大小（字节） -->
	<param name="allowedTypes">image/jpeg, image/png,image/gif</param><!-- 允许类型 -->
	<!-- <param name="allowedExtensions">.jpg, .png,.gif</param>允许的后缀类型 -->
</interceptor-ref>
```

token/tokenSession:组织表单重复提交

### 国际化


图片服务器分离技术

虚拟目录


## ognl 表达式
对象图导航语言，提供一个对象，获取这个对象属性值，或者对属性参与加工。
- 表达式没有 # 号，就去 root 区查找对应的值
- 表达式有 # 号，就去 context 区查找对应的值

ognl 表达式要结合 struts 标签使用
