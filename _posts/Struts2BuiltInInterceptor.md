---
title: Struts2 内建拦截器简介
date: 2017-06-08 09:24:00
categories: 触类旁通
tags: 
- Struts 2
- 拦截器
---

Struts 2 中有很多内置拦截器，本文将简单的
非常简单的...）介绍各个内置拦截器的作用。

<!--more-->
## alias
**别名拦截器：**允许参数在跨越多个请求时使用不同别名，该拦截器可将多个 Action 采用不同名字链接起来，然后用于处理同一信息。

## autowiring
**自动装配拦截器：**主要用于当 Struts 2 和 Spring 整合时，Struts 2 可以使用自动装配的方式来访问 Spring 容器中的 Bean。

## chain
**链拦截器：**构建一个 Action 链，使当前 Action 可以访问前一个 Action 的请求信息，一般和 `<result type="chain" .../>` 一起使用。

## checkbox
**多选框拦截器：**将没有选中的 checkbox 项设置为 false，协助管理多选框。在 HTTP 请求里，那些没有被选中的项通常没有任何值。

## conversionError
**转换器错误拦截器：**这是一个负责处理类型转换错误的拦截器，它负责将类型转换错误从 ActionContext 中取出，并转换成 Action 的 FieldError 错误。

## createSession
**创建 Session 拦截器：**该拦截器负责创建一个 HttpSession 对象，主要用于那些需要有 HttpSession 对象才能正常工作的拦截器中。

## clearSession
**清除 Session 拦截器：**负责销毁 HttpSession 对象。

## debugging
**调试拦截器：**当使用 Struts 2 的开发模式时，这个拦截器会提供更多的调试信息。

## execAndWait
**执行和等待拦截器：**后台执行 Action 时，给用户显示一个过渡性的等待页面。

## externalRef
**扩展拦截器：**负责扩展引用。

## exception
**异常拦截器：**将 Action 抛出的异常映射到结果，这样就通过重定向自动处理异常。

## fileUpload
**文件上传拦截器：**这个拦截器主要用于文件上传，它负责解析表单中文件域的内容。

## i18n
**国际化拦截器：**主要负责把用户所选的语言、区域放入用户 Session 中。

## logger
**日志拦截器：**主要是输出 Action 的名字，提供简单的日志输出。

## modelDriven
**模型驱动拦截器：**这是一个用于模型驱动的拦截器，当某个 Action 类实现了 ModelDriven 接口时，它负责把 getModel() 方法的结果堆入 ValueStack 中。

## scopedModelDriven
**作用域模型驱动拦截器：**如果一个 Action 实现了一个 ScopedModelDriven 接口，该拦截器负责从指定生存范围中找出指定的 Model，并将通过 setModel 方法将该 Model 传给 Action 实例。

## params
**参数过滤拦截器：**这是一个最基本的拦截器，它负责解析 HTTP 请求中的参数，并将参数值设置成 Action 对应的属性值。

## prepare
**预备拦截器：**如果 action 实现了 Preparable 接口，将会调用该拦截器的 prepare() 方法。

## staticParams
**静态参数拦截器：**这个拦截器负责将 xml 中 `<action>` 标签下 `<param>` 标签中的参数传入 action。

## scope
**作用域拦截器：**这是范围转换拦截器，它可以将 Action 状态信息保存到 HttpSession 范围，或者保存到 ServletContext 范围内。

## servletConfig
**Servlet 配置拦截器：**如果某个 Action 需要直接访问 Servlet API，就是通过这个拦截器实现的，它提供访问 HttpServletRequest 和 HttpServletResponse 的方法，以map方式访问。

## roles
**角色拦截器：**这是一个 JAAS（Java Authentication and Authorization Service，Java授权和认证服务）拦截器，只有当浏览者取得合适的授权后，才可以调用被该拦截器拦截的 Action。

## timer
**计时拦截器：**这个拦截器负责输出 Action 的执行时间，在分析该 Action 的性能瓶颈时比较有用。

## token
**令牌拦截器：**这个拦截器主要用于阻止重复提交，它检查传到 Action 中的 token，从而防止多次提交。

## tokenSession
**令牌会话拦截器：**这个拦截器的作用与前一个基本类似，只是它把非法提交的数据保存在 HttpSession 中，不跳转到错误页面，再次生成与第一次相同的响应页面。

## validation
**验证拦截器：**通过执行在 xxxAction-validation.xml 中定义的校验器，从而完成数据校验。

## workflow
**工作流拦截器：**这个拦截器负责调用 Action 类中的 validate 方法，如果校验失败，则不执行业务方法，而是返回 input 的逻辑视图。

## jsonValidation
**json 拦截器：**验证失败时，可以将 fieldError 和 actionErrors 信息序列化成 json，返回给客户端。

## profiling
**概要拦截器：**允许 Action 记录简单的概要信息。

## actionMappingParams
**Action 映射拦截器：**Parameters set by the action mapping are not set/not available through ParameterAware.

## annotationWorkflow
**注解工作流拦截器：**利用注解替代 XML 配置，使用 annotationWorkflow 拦截器可以使用 @After、@Before、@BeforeResult 等注解，执行流程为 before-execute-beforeResult-after 顺序。

## store
**消息存储拦截器：**在会话中为 Action 存储和检索消息、字段错误以及 Action 错误，该拦截器要求 Action 实现 ValidationAware 接口。