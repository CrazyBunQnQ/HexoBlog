---
title: Resource And Autowired 注解的区别
date: 2021-03-06 22:22:22
img: "/images/Spring.png"
cover: false
coverImg: "/images/Spring.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: Java
tags:
- 框架
- Spring
- 注解
keywords: Autowired
summary: 今天项目上线后出现一个生产问题, `@Resource` 注解注入 `systemTaskService` 对象失败, 导致对象空指针了, 但是本次修改内容修改了很多地方, 都使用 `@Resource` 注解引用了该对象, 然而只有这一处注入失败, 其他位置都正常...
---

今天项目上线后出现一个生产问题, `@Resource` 注解注入 `systemTaskService` 对象失败, 导致对象空指针了

但是本次修改内容修改了很多地方, 都使用 `@Resource` 注解引用了该对象, 然而只有这一处注入失败, 其他位置都正常...

这就很奇怪了，修改内容都一样，所以只测了几个地方没有问题就认为可以了，坑啊...这是为啥呢?

好奇的我就复习了一下 `@Resource` 和 `@Autowired` 的区别

## 共同点

`@Resource` 和 `@Autowired` 都可以作为注入属性的修饰

在接口仅有单一实现类时, 两个注解的修饰效果相同, 可以互相替换, 不影响使用

### 示例 1

```java
package com.example.annotation.service;
 
/**
 * service接口定义
 * @author Administrator
 */
public interface Human {

    /**
     * 跑马拉松
     * @return
     */
    String runMarathon();
}
```
 
```java
package com.example.annotation.service.impl;
 
import com.example.annotation.service.Human;
import org.springframework.stereotype.Service;
 
/**
 * service接口第一实现类
 * @author Administrator
 */
@Service
public class Man implements Human {

    public String runMarathon() {
        return "A man run marathon";
    }
}
```

```java
package com.example.annotation.controller;
 
import javax.annotation.Resource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.annotation.service.Human;
 
/**
 * controller层实现类
 * @author Administrator
 */
@RestController
@RequestMapping("/an")
public class HumanController {
 
    @Resource
    private Human human;

    @RequestMapping("/run")
    public String runMarathon() {
        return human.runMarathon();
    }
}
```

至此，代码整理完成，启动后输出 `A man run marathon`

将 `HumanController.java` 类中的注解替换为 `@Autowired`, 再次启动, 仍然输出 `A man run marathon`

**在接口仅有单一实现类时, 两个注解的修饰效果相同, 可以互相替换, 不影响使用**


## 不同点

### `@Resource` 是 Java 自己的注解

`@Resource` 有两个属性是比较重要的，分是 `name` 和 `type`

Spring 将 `@Resource` 注解的 `name` 属性解析为 `bean` 的名字, 而 `type` 属性则解析为 `bean` 的类型:

- 如果使用 `name` 属性, 则使用 `byName` 的自动注入策略
- 如果使用 `type` 属性, 则使用 `byType` 自动注入策略
- 如果既不指定 `name` 也不指定 `type` 属性, 这时将通过反射机制使用 `byName` 自动注入策略

### 示例 2

再次修改[示例 1](#示例1) 的代码, 增加一个实现类 `Woman.java`, `HumanController.java` 注解仍然使用 `@Resource`

```java
package com.example.annotation.service.impl;
 
import com.example.annotation.service.Human;
import org.springframework.stereotype.Service;
 
/**
 * service接口第二实现类
 * @author Administrator
 */
@Service
public class Woman implements Human {
 
    public String runMarathon() {
        return "An woman run marathon";
    }
}
```

此时启动项目, 控制台会报错, 报错信息太多, 截取关键信息 `expected single matching bean but found 2: man,woman`:

```log
2021-03-06 21:22:22.222  WARN 2222 --- [  restartedMain] ConfigServletWebServerApplicationContext : Exception encountered during context initialization - cancelling refresh attempt: org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'humanController': Injection of resource dependencies failed; nested exception is org.springframework.beans.factory.NoUniqueBeanDefinitionException: No qualifying bean of type 'com.example.annotation.service.Human' available: expected single matching bean but found 2: man,woman
```

期望的单一结果被匹配到两个结果 `man` 和 `woman`

在接口有多个实现类时, 就需要额外的处理才能正常使用

需要指定 `@Resource` 注解的 `name` 属性或使用 `@Qualifier` 来确定用哪一个实现类

`HumanController.java` 代码修改为下面任意一种代码, 指定 `Human` 接口的实现类是 `Woman.java`

```java
@Resource(name="woman")
private Human human;
```

或

```java
@Resource
@Qualifier("woman")
private Human human;
```

再次启动程序, 输出内容为 `An woman run marathon`

### `@Autowired` 是 Spring 的注解

`@Autowired` 是 Spring 2.5 版本引入的, `Autowired` 只根据 `type` 进行注入, 不会去匹配 `name`

如果涉及到 `type` 无法辨别注入对象时, 那需要依赖 `@Qualifier` 或 `@Primary` 注解一起来修饰

### 示例 3

将[示例 2](#示例2) 中的注解替换为 `@Autowired`:

```java
@Autowired
private Human human;
```

再次启动时报错:

```log
Description:
/source/_posts/ResourceAndAutowired.md
Field human in com.example.annotation.controller.HumanController required a single bean, but 2 were found:
    - man: defined in file [/Users/baojunjie/CrazyProjects/Annotation/target/classes/com/example/annotation/service/impl/Man.class]
    - woman: defined in file [/Users/baojunjie/CrazyProjects/Annotation/target/classes/com/example/annotation/service/impl/Woman.class]
 
Action:
Consider marking one of the beans as @Primary, updating the consumer to accept multiple beans, or using @Qualifier to identify the bean that should be consumed
```

报错信息很明显, `HumanController.java` 需要一个 `bean` 实现, 但是找到了两个: `man` 和 `woman`

两种解决方案: 

- 使用 `@Primary` 注解, 在有多个实现 `bean` 时告诉 Spring 首先用 `@Primary` 修饰的那个
- 使用 `@Qualifier` 来标注需要注入的类

其中 `@Qualifier` 修改方式与[示例 2](#示例2) 相同, 依然是修改 `HumanController.java` 中间注入的 `Human` 上面

`@Primary` 是修饰实现类的

告诉 `Spring`, 如果有多个实现类时, 优先注入被 `@Primary` 注解修饰的那个

这里, 我们希望注入 `Man.java`, 那么修改 `Man.java` 为:

```java
package com.example.annotation.service.impl;
 
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;
import com.example.annotation.service.Human;
 
/**
 * service接口第一实现类
 * @author Administrator
 */
@Service
@Primary
public class Man implements Human {
 
    public String runMarathon() {
        return "A man run marathon";
    }
}
```

再次启动应用, 就能看到正确的输出了 `A man run marathon`

### 然而

然而, 重新看了它俩的区别后，还是没能解答我这个问题到底为什么...

![](http://wx1.sinaimg.cn/large/a6e9cb00ly1gocq7wegazj21400u0n38.jpg)

![](http://wx3.sinaimg.cn/large/a6e9cb00ly1gocq8fq6ncj21hc0u0apm.jpg)
