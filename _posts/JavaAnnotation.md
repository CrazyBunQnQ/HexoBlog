---
title: Java 注解
date: 2021-06-01 22:22:22
img: "images/JavaAnnotation.jpg"
cover: fasle
coverImg: "images/JavaAnnotation.jpg"
toc: false
mathjax: false
categories: Java
tags:
- Java 基础
keywords: 注解
summary: 写代码的时候经常能见到各种注解，可能因为太常见，所以忽略了它的存在。今天点进去几个注解看了下源码注释, 了解下官方说明各个注解是干啥的, 结果发现每个注解类里面的方法都跳转不到实现类, 哎哟我的好奇心呐, 研究研究！
---

写代码的时候经常能见到各种注解，可能因为太常见，所以忽略了它的存在

今天点进去几个注解看了下源码注释, 了解下官方说明各个注解是干啥的, 结果发现每个注解类里面的方法都跳转不到实现类, 哎哟我的好奇心呐, 研究研究！

## 为什么会有注解

使用 Annotation 之前(甚至在使用之后), XML 被广泛的应用于描述元数据. 不知何时开始一些应用开发人员和架构师发现 XML 的维护越来越糟糕了. 他们希望使用一些和代码紧耦合的东西, 而不是像 XML 那样和代码是松耦合的(在某些情况下甚至是完全分离的)代码描述.

如果你上网搜索 `XML vs. Annotations`, 会看到许多关于这个问题的辩论. 最有趣的是 XML 配置其实就是为了分离代码和配置而引入的. 上述两种观点可能会让你很疑惑, 两者观点似乎构成了一种循环, 但各有利弊.

我们可以通过一个例子来理解这两者的区别:

- 假如你想为应用设置很多的常量或参数, 这种情况下, XML 是一个很好的选择, 因为它不会同特定的代码相连
- 如果你想把某个方法声明为服务, 那么使用 Annotation 会更好一些. 因为这种情况下需要注解和方法紧密耦合起来, 开发人员也必须认识到这点

另一个很重要的因素是 Annotation 定义了一种标准的描述元数据的方式.

**Annotation(注解)**就是 Java 提供了一种元程序中的元素关联任何信息和任何元数据(metadata)的途径和方法

Annotation 是一个接口, 程序可以通过反射来获取指定程序元素的 Annotation 对象，然后通过 Annotation 对象来获取注解里面的元数据

## 元数据(metadata)

## 注解的分类

- 根据注解参数的个数:
  1. 标记注解: 一个没有成员定义的 Annotation 类型被称为标记注解
  2. 单值注解: 只有一个值
  3. 完整注解: 拥有多个值
- 根据注解使用方法和用途:
  1. [JDK 内置系统注解](#内置注解)
  2. [元注解](#元注解(meta-annotation))
  3. [自定义注解](#自定义注解)

## 内置注解

JavaSE 中内置三个标准注解, 定义在 `java.lang` 中

### @Override

限定重写父类方法, 若想要重写父类的一个方法时, 需要使用该注解告知编译器我们正在重写一个方法

如此一来, 当父类的方法被删除或修改了, 编译器会提示错误信息, 或者该方法不是重写也会提示错误

### @Deprecated

标记已过时, 当我们想要让编译器知道一个方法已经被弃用(deprecate)时, 应该使用这个注解

Java 推荐在 javadoc 中提供信息, 告知用户为什么这个方法被弃用了, 以及替代方法是什么

### @SuppressWarnings

抑制编译器警告, 该注解仅仅告知编译器, 忽略它们产生了特殊警告

如: 在 java 泛型中使用原始类型. 其保持性策略(retention policy)是 SOURCE, 在编译器中将被丢弃

## 元注解(meta-annotation)

元注解的作用就是负责注解其他注解

Java5.0 定义了 4 个标准的元注解类型, 它们被用来提供对其它注解类型作说明

这些类型和它们所支持的类在 `java.lang.annotation` 包中可以找到

这里定义了一个空的注解, 它能干什么呢? 我也不知道, 但他能用...

后面我们再给这个注解添加元注解

```java
@interface Simple{
    // 这里定义了一个空的注解, 它能干什么呢? 我也不知道, 但他能用...
}
```

### @Target

用于描述注解的使用范围(即: 被描述的注解可以用在什么地方)

表示支持注解的程序元素的种类, 如果 @Target 元注解不存在, 那么该注解就可以使用在任何程序元素之上

可以设置的值(ElementType):

1. `CONSTRUCTOR`: 用于描述构造器
2. `FIELD`: 用于描述域
3. `LOCAL_VARIABLE`: 用于描述局部变量
4. `METHOD`: 用于描述方法
5. `PACKAGE`: 用于描述包
6. `PARAMETER`: 用于描述参数
7. `TYPE`: 用于描述类、接口(包括注解类型) 或 enum 声明

此时在空注解中加入 `@Target(ElementType.METHOD)` 元注解使其只能作用在方法上:

```java
import java.lang.annotation.Target;

@Target(ElementType.METHOD) 
@interface Simple {
}
```

### @Retention

表示需要在什么级别保存该注释信息, 用于描述注解的生命周期(即: 被描述的注解在什么范围内有效), 表示注解类型保留时间的长短

可以设置的值(ElementType):
1. `SOURCE`: 在源文件中有效(即源文件保留)
2. `CLASS`: 在 class 文件中有效(即 class 保留)
3. `RUNTIME`: 在运行时有效(即运行时保留)

此时在上述注解中加入 `@Retention(RetentionPolicy.RUNTIME)` 元注解使其运行时有效

注解处理器可以通过反射, 获取到该注解的属性值, 从而去做一些运行时的逻辑处理

```java
import java.lang.annotation.Target;
import java.lang.annotation.Retention;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@interface Simple{
}
```

### @Documented

表示使用该注解的元素应被 javadoc 或类似工具文档化, 应用于类型声明, 类型声明的注解会影响客户端对注解元素的使用

如果一个类型声明添加了 Documented 注解, 那么它的注解会成为被注解元素的公共 API 的一部分, @Documented 是一个标记注解

```java
import java.lang.annotation.Target;
import java.lang.annotation.Retention;
import java.lang.annotation.Documented;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@interface Simple {
}
```

### @Inherited

表示一个注解类型会被自动继承

如果用户在类声明的时候查询注解类型, 同时类声明中也没有这个类型的注解, 那么注解类型会自动查询该类的父类

这个过程将会不停地重复, 直到该类型的注解被找到为止, 或是到达类结构的顶层(Object)

```java
import java.lang.annotation.Target;
import java.lang.annotation.Retention;
import java.lang.annotation.Documented;
import java.lang.annotation.Inherited;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@interface Simple {
}
```

## 自定义注解

使用 @interface 自定义注解, 注解类自动继承 `java.lang.annotation.Annotation` 接口, 由编译程序自动完成其他细节

在定义注解时, 不能继承其他的注解或接口

- `@interface` 用来声明一个注解
- 注解类里的每一个**方法实际上是声明了一个配置参数**
    - 方法的名称就是参数的名称
    - 返回值类型就是参数的类型
    - 可以通过 `default` 来声明参数的默认值

### 注解参数(即注解类中的方法)

1. 修饰符只能用 `public` 或默认(`default`)这两个访问权修饰, 默认为 `default` 类型
2. 注解参数只支持以下数据类型
    - 基本数据类型(int, float, boolean, byte, double, char, long, short)
    - String 类型
    - Class 类型
    - Enum 类型
    - Annotation 类型
    - 以上所有类型的数组
3. 命名: 对取名没有要求, 如果只有一个参数成员, 最好把参数名称设为 `value`, 后加小括号
4. 参数注解中的方法不能存在参数
5. 默认值: 可以包含默认值, 使用 `default` 来声明默认值

### 注解是如何工作的

当注解标注到某个类或者方法或者某个成员变量或者某个输入参数上的时候, 一定有一个对应的机制来对注解标注的类、方法、成员变量和参数进行某些处理

例如我们常用的 Spring 中的 `@Service` 注解, Spring 在启动 IOC 容器的时候会对每个类进行扫描

把所有标注 `@Component` 及其子注解如 `@Service` 的类进行 Bean 处理

再例如我们上面自定义的 `@Simple` 注解, 在 Spring 的拦截器 HandlerInterceptor 中实现 `@Simple` 注解的业务逻辑, 这里使用了反射机制

```java
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
	HandlerMethod hm = (HandlerMethod) handler;
	// 查看方法是否有 @Simple 注解
	AuthCheck ac = hm.getMethodAnnotation(Simple.class);
	if (ac != null) {
		// 有的话在这里进行业务逻辑操作
	}
	return true;
}
```

## 参考

- [Java注解-元数据、注解分类、内置注解和自定义注解](https://juejin.cn/post/6844903897908133902)
- [Java中的注解是怎样工作的](https://juejin.cn/post/6844903878765314062)