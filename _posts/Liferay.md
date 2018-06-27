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

### 注意事项

- 工作空间设置为 **utf-8** 编码
- Ant 编译时会在 SDK dist 目录下打个 war 包，然后复制到 Tomcat deploy 目录下，**部署成功后会将其删除**(判断部署成功的方法)
- 整个项目虽然显示在 Eclipse 中，但实际上并不在 Eclipse 空间中，而是在 Liferay SDK 所在目录里...**不在工作空间里...不在工作空间里...不在空间里...**

## 开发模式

- Portlet：Liferay 插件，结构与 Web 工程类似
- HOOK：重写 Liferay 框架中的默认方法或页面，避免修改源码
- EXT： 不推荐
- Layout：布局模板
- Theme：主题开发

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
    <!-- 所用的 jsp 文件 -->
    <init-param>
        <name>view-template</name>
        <value>/html/hello/view.jsp</value>
    </init-param>
    <expiration-cache>0</expiration-cache>
    <supports>
        <mime-type>text/html</mime-type>
        <portlet-mode>view</portlet-mode>
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

#### liferay-portlet.xml

- 基本配置
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

- portlet 配置：同样每创建一个 portlet 也会在此文件里添加一些该 portlet 的相关配置
    ```xml
    <portlet>
        <!-- 与 portlet.xml 中的 name 关联 -->
        <portlet-name>hello</portlet-name>
        <!-- 页面标题前面显示的图标 -->
        <icon>/icon.png</icon>
        <!-- 是否可以创建多次，默认 false 只能添加一次 -->
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

#### 自定义Action方法

```java
public void update(ActionRequest request, ActionResponse response) {
    String userName = request.getParameter("uName");
}
```

也可以通过注解调用该方法，效果与上面相同

```java
@ProcessAction(name="update)
public void updateMethod(ActionRequest request, ActionResponse response) {
    String userName = request.getParameter("uName");
}
```

### view.jsp

在 portlet.xml 中指定了每个 portlet 对应的 jsp 文件，这里不再赘述，只介 API 用法和一些语法

#### 显示数据

通过 java 代码 `(String)renderRequest.getAttribute("data");` 或 EL 表达式 `${data}`获取后台传回来的属性值

```jsp
<!-- EL 表达式获取数据 -->
这是${data}.
<!-- java 代码获取数据 -->
<% String data = (String)renderRequest.getAttribute("data"); %>
<!-- 显示数据 -->
<%=data %>
```

#### 提交表单

使用 Liferay 的 action 需要先引用标签 `actionURL` 或 `renderURL`，**只能使用一个**

- actionURL：提交到指定方法中, 例如在后台自定义 [`update`](#自定义Action方法) 方法，则 name 属性为 update
    ```html
    <portlet:actionURL var="updateForm" name="update"></portlet:actionURL>
    <form action="<%updateURL>" method="post">
        用户名：<input type="text" name="uName">
        <input type="submit">
    </form>
    ```
- renderURL：提交到 [`doView`](#doView) 方法
    ```html
    <!-- 引用 renderURL 标签-->
    <portlet:renderURL var="updateURL"></portlet:renderURL>
    <form action="<%updateURL>" method="post">
        <!--  -->
        用户名：<input type="text" name="<portlet:namespace/>uName">
        <input type="submit">
    </form>
    ```

><font color="#FF6655">注意 name 属性需要添加 namespace 属性</font>，否则后台取不到值
>liferay-portlet.xml 配置 requires-namespaced-parameters 属性为 false，则不需要添加 namespace 属性
>namespace 作用：避免多个相同的 portlet 表单冲突，因为 portlet 可以设置为一个页面显示多个，它会为每个 name 生成一个唯一编码