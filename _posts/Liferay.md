---
title: Liferay 学习笔记
date: 2018-06-26 22:22:22
categories: 触类旁通
tags:
- Liferay
- Portlet
---

新项目需要用 Liferay Portal 框架进行开发，之前没接触过，为了不反复查资料，遇到的东西还是记下来比较好...愁...

<!-- more -->

## 环境及注意事项

### 环境

- 安装了 Liferay 插件的 IDE
- Liferay SDK
- 扩展了了 Liferay 的 Tomcat
- JDK 7

<br>

### 注意事项

- 工作空间设置为 **utf-8** 编码
- Ant 编译时会在 SDK dist 目录下打个 war 包，然后复制到 Tomcat deploy 目录下，**部署成功后会将其删除**(判断部署成功的方法)
- 整个项目虽然显示在 Eclipse 中，但实际上并不在 Eclipse 空间中，而是在 Liferay SDK 所在目录里...**不在工作空间里...不在工作空间里...不在空间里...**

<br>

## 开发模式

- Portlet：Liferay 插件，结构与 Web 工程类似
- HOOK：重写 Liferay 框架中的默认方法或页面，避免修改源码
- EXT： 不推荐
- Layout：布局模板
- Theme：主题开发

<br>

## 配置文件

### WEB-INF

#### portlet.xml

每新建一个 portlet 都会自动添加一个 `<portlet>` 标签

```xml
<portlet>
    <!-- portlet id, 存入数据库中的 id -->
    <portlet-name>hello</portlet-name>
    <!-- 页面上的显示名称 -->
    <display-name>Hello</display-name>
    <!-- 后台 java 类 -->
    <portlet-class>com.baozi.demo.hello.HelloPortlet</portlet-class>
    <!-- 每个模式所对应的 jsp 文件 -->
    <init-param>
        <name>view-template</name>
        <value>/html/hello/view.jsp</value>
    </init-param>
    <init-param>
        <name>edit-template</name>
        <value>/html/hello/edit.jsp</value>
    </init-param>
    <init-param>
        <name>help-template</name>
        <value>/html/hello/help.jsp</value>
    </init-param>
    <init-param>
        <name>about-template</name>
        <value>/html/hello/about.jsp</value>
    </init-param>
    <expiration-cache>0</expiration-cache>
    <!-- 支持的模式：每个模式对应一个上面的 jsp 文件 -->
    <supports>
        <mime-type>text/html</mime-type>
        <!-- 显示模式 -->
        <portlet-mode>view</portlet-mode>
        <!-- 编辑模式 -->
        <portlet-mode>edit</portlet-mode>
        <!-- 帮助模式 -->
        <portlet-mode>help</portlet-mode>
        <!-- 显示模式 -->
        <portlet-mode>about</portlet-mode>
    </supports>
    <portlet-info>
        <title>Hello</title>
        <short-title>Hello</short-title>
        <keywords></keywords>
    </portlet-info>
    <security-role-ref>
        <role-name>administrator</role-name>
    </security-role-ref>
    <security-role-ref>
        <role-name>guest</role-name>
    </security-role-ref>
    <security-role-ref>
        <role-name>power-user</role-name>
    </security-role-ref>
    <security-role-ref>
        <role-name>user</role-name>
    </security-role-ref>
</portlet>
```

>这个东西貌似也可以在你创建的 Portlet.java 文件中用注解的方式表示, 有空试试~
>
>```java
>@Component(
>	immediate = true,
>	property = {
>		"com.liferay.portlet.display-category=category.sample",
>		"com.liferay.portlet.instanceable=true",
>		"javax.portlet.display-name=HelloPortlet Portlet",
>		"javax.portlet.init-param.template-path=/",
>		//"javax.portlet.init-param.name=view-template",
>		"javax.portlet.init-param.view-template=/html/hello/view.jsp",
>		"javax.portlet.name=" + HelloPortletKeys.Hello,
>		"javax.portlet.resource-bundle=content.Language",
>		"javax.portlet.security-role-ref=power-user,user"
>	},
>	service = Portlet.class
>)
>public class HelloPortlet extends MVCPortlet {
>}
>```

<br>

#### liferay-portlet.xml

##### 基本配置
```xml
<role-mapper>
    <role-name>administrator</role-name>
    <role-link>Administrator</role-link>
</role-mapper>
<role-mapper>
    <role-name>guest</role-name>
    <role-link>Guest</role-link>
</role-mapper>
<role-mapper>
    <role-name>power-user</role-name>
    <role-link>Power User</role-link>
</role-mapper>
<role-mapper>
    <role-name>user</role-name>
    <role-link>User</role-link>
</role-mapper>
```

<br>

##### portlet 配置

同样每创建一个 portlet 也会在此文件里添加一些该 portlet 的相关配置
    
```xml
<portlet>
    <!-- 与 portlet.xml 中的 name 关联 -->
    <portlet-name>hello</portlet-name>
    <!-- 页面标题前面显示的图标 -->
    <icon>/icon.png</icon>
    <!-- 是否可以实例多次，默认 false 只能添加一次 -->
    <instanceable>true</instanceable>
    <!-- jsp 表单中是否需要填写 namespace，默认 true 必须填写 -->
    <requires-namespaced-parameters>false</requires-namespaced-parameters>
    <!-- 引入的 css 文件 -->
    <header-portlet-css>/css/main.css</header-portlet-css>
    <!-- 引入的 js 文件 -->
    <footer-portlet-javascript>/js/main.js</footer-portlet-javascript>
    <css-class-wrapper>hello-portlet</css-class-wrapper>
</portlet>
```

<br>

#### liferay-desplay.xml

用来设置每个 portlet 的分类，根据 portlet id

```xml
<!-- 类别名称 -->
<category name="category.sample">
    <!-- 对应 portlet.xml 中的 portlet-name 属性-->
    <portlet id="LiferayTest" />
    <!-- 这种写法也可以 -->
    <portlet id="portletName"></portlet>
</category>
<!-- 当然也可以自定义分类, 若要显示中文可通过国际化配置 -->
<category name="baozi">
    <portlet id="hello"/>
</category>
```

<br>

## 常用 API

### MVCPortlet

#### doView

```java
@Override
public void doView(RenderRequest renderRequest,
        RenderResponse renderResponse) throws IOException, PortletException {
    //从前台接收数据
    String userName = renderRequest.getParameter("uName");
    //向前台传数据
    renderRequest.setAttribute("data", "后台传回来的数据");
    super.doView(renderRequest, renderResponse);
}
```

该方法会在页面显示该 portlet 时执行

>页面中的 portlet 显示 “此 portlet 已被卸载。请重新部署或将其从页面删除” 时，一般是因为控件还未部署完成，部署完成后刷新页面即可

<br>

#### 自定义Action方法

```java
public void update(ActionRequest request, ActionResponse response) {
    // 接收参数
    String userName = request.getParameter("uName");
    // 重定向
    try{
        // response.sendRedirect("/html/hello/edit.jsp");
    } catch (Exception e) {
        ...
    }
}
```

也可以通过注解调用该方法，效果与上面相同

```java
@ProcessAction(name="update)
public void updateMethod(ActionRequest request, ActionResponse response) {
    String userName = request.getParameter("uName");
}
```

<br>

#### processAction

如果 [`<portlet:actionURL>`](#actionURL) 没有 name 属性则会进入这个方法

```java
@Override
public void doView(RenderRequest renderRequest,
		RenderResponse renderResponse) throws IOException, PortletException {
	// TODO Auto-generated method stub
	super.doView(renderRequest, renderResponse);
}                                                               ```

<br>

### ParamUtil

#### getString()

该方法可以自动判空：若为空则赋值为默认值，省略默认值则为空字符串

```java
String userName = ParamUtil.getString(renderRequest, "uName");
// 或
String userName = ParamUtil.getString(renderRequest, "uName", "baozi");
```

>同样的还有 `getInteger()`、`getBoolean()`、`getDate()` 等等
>但是注意，Integer 类型会进行类型转换，若<font color="#FF6633">转换失败</font>则赋值为默认值

<br>

### PortalUtil

该类可以去到很多方法

```java
/*============================对象获取=======================*/
try {
    //获取用户
    User user = PortalUtil.getUser(renderRequest);
    //获取公司getCompany
} catch (PortalException | SystemException e) {
    e.printStackTrace();
}

/*============================值获取===========================*/
//获取用户id
long userId = PortalUtil.getUserId(httpServletRequest);
long userId = PortalUtil.getUserId(portletRequest);
//getScopeGroupId
//getCompanyId
//获取当前端口getPortalPort
//获取当前地址getPortalUrl(renderRequest)
```

<br>

### ThemeDisplay

该对象可以获取各种显示相关的信息

获取方式：

```java
//获取 ThemeDisplay
ThemeDisplay themeDisplay = (ThemeDisplay)renderRequest.getAttribute(WebKes.THTME_DISPLAY);
```

<br>

## 页面显示

在 portlet.xml 中指定了每个 portlet 对应的 jsp 文件，这里不再赘述

### 引用 portlet 对象

首先要在 jsp 页面中引入 [portlet 内置对象](#defineObjects)否则无法调用 portlet 的 java 对象：

```jsp
<portlet:defineObjects />
```

<br>

### 引用 js 和 css

因为 liferay 开发实际是在写代码片段，所以必须要写全路径 `<%= renderRequest.getContextPath()%>`

```jsp
<script type="text/javascript" src="<%= renderRequest.getContextPath()%>/js/jquery.js">
```

>相对路径是绝对无法取到的

<br>

### 显示数据

通过 java 代码 `(String)renderRequest.getAttribute("data");` 或 EL 表达式 `${data}`获取后台传回来的属性值

```jsp
<!-- EL 表达式获取数据 -->
这是${data}.
<!-- java 代码获取数据 -->
<% String data = (String)renderRequest.getAttribute("data"); %>
<!-- 显示数据 -->
<%=data %>
```

<br>

### 提交表单

使用 Liferay 提交表单需要先引用标签 `actionURL` 或 `renderURL`

1. actionURL：提交到指定方法中, 例如在后台自定义 [`update`](#自定义Action方法) 方法，则 name 属性为 update

    ```html
    <portlet:actionURL var="updateForm" name="update"></portlet:actionURL>
    <!-- 也可以在 action 中添加额外参数 -->
    <form action="<%updateURL%>&otherParm=other" method="post">
        用户名：<input type="text" name="uName">
        <input type="submit">
    </form>
    ```
1. renderURL：提交到 [`doView`](#doView) 方法

    ```html
    <!-- 引用 renderURL 标签-->
    <portlet:renderURL var="updateURL"/>
    <form action="<%updateURL%>" method="post">
        <!--  -->
        用户名：<input type="text" name="<portlet:namespace/>uName">
        <input type="submit">
    </form>
    ```

>[<font color="#FF6655">注意 name 属性需要添加 namespace 属性</font>](#namespace)，否则后台取不到值
>配置 [`<requires-namespaced-parameters>`](#liferay-portlet.xml) 属性为 false，则不需要添加 namespace 属性

<br>

## Portlet标签

### defineObjects

引入该标签后可以调用 Portlet 中的默认对象

```jsp
<portlet:defineObjects>
```

- renderRequest
- actionRequest
- ...

<br>

### 请求类标签

#### renderURL

用于提交表单，类似 Get 请求

```jsp
<portlet:renderURL var="updateURL">
    <!-- 添加值为 "sss" 的参数 updateParm -->
    <portlet:param name="updateParm" value="sss"/>
    <!-- 跳转页面 -->
    <portlet:param name="jspPage" value="/html/hello/edit.jsp"/>
</portlet:renderURL>
```

>示例可以参考 [liferay 提交表单](#提交表单)

<br>

#### actionURL

用于提交表单，类似 Post 请求

```jsp
<portlet:actionURL var="updateForm" name="update">
    <!-- 添加值为 "sss" 的参数 updateParm -->
    <portlet:param name="updateParm" value="sss"/>
</portlet:actionURL>
```

>示例可以参考 [liferay 提交表单](#提交表单)

<br>

#### resourceURL

用于资源传输类请求

```jsp
<portlet:resourceURL>
    <!-- 添加值为 "sss" 的参数 updateParm -->
    <portlet:param name="updateParm" value="sss"/>
<portlet:resourceURL>
```

<br>

### param

该标签无法单独使用，需要配合[请求类标签](#请求类标签)使用

```jsp
<portlet:param name="" value=""/>
```

<br>

### namespace

```jsp
<portlet:namespace/>
```

避免多个相同的 portlet 表单冲突，因为 portlet 可以设置为一个页面显示多个，它会为每个 name 生成一个唯一编码，该编码还可以用到各种地方：

```javascript
<script>
    function <portlet:namespace/>save() {
        ...
    }
</script>
```
```jsp
<button onclick="<portlet:namespace/>save()"/>
```

><font color="#FF6633">如果设置了 [`<instanceable>true</instanceable>`](#liferay-portlet.xml) 属性请不要设置 [`<requires-namespaced-parameters>`](#liferay-portlet.xml) 为 false</font>, 避免实例化多个 portlet 之后无法取到值

<br>

### iferay-theme:defineObjects

```jsp
<liferay-theme:defineObjects>
```

<br>

### ~~property~~

`<portlet:property>` 标签虽然在 portlet 里有定义但是在 liferay 中没有用到

<br>

## 地址参数解析

- p_p_id: portlet id
    - 如果该 portlet 允许实例化多次(`<instanceable>`)则结尾会有实例化 id
- p_p_lifecycle: 请求类型
    - 0: RenderRequest, 相当于 Get
    - 1: ActionRequest, 相当于 Post
- p_p_state: 状态
    - normal: 正常
    - maximized: 最大化
    - minimized: 最小化
    - pop_up: 不显示头尾模式，用于弹窗
    - EXCLUSIVE: 

<br>

## Portlet之间的通信



<br>

### PortletSession

<br>

### Portlet URL 调用

<br>

### Public render parameters

<br>

### Portlet events

<br>

### 通过 URL 传参