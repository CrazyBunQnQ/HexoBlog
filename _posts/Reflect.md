---
title: 反射、debug、Junit 和 properties（待完善）
date: 2017-03-31 22:22:22
categories: Java 基础
tags:
- 反射
- 调试
- 测试类
- 配置文件
---

反射、debug、Junit 和 properties 是 Java 中比较零散的几个常用技巧。

<!--more-->

## 反射
### class 类
在Java 中，每一个class 都有一个相应的 Class 对象，也就是说，当我们编写玩一个类，编译完成后，产生的 .class 文件中就会产生一个 class 对象，用于表示这个类的信息。

Class 类是反射源头。Class类的构造器被私有化，无法被访问，但是可以通过下面三种方式实例化 Class 类：

1. 通过 `Class.forName("完整包名.类名")` 方法
2. 通过 `类.Class`
3. 通过 `对象.getClass()`


实际开发中 包名.类名--->
通过 new 关键字创建对象--->
操作这个对象，获取类里面的方法或属性

反射 Class 类---->
实例化 Class 对象--->
包名.类名

在正常情况下，必须知道一个类的完整路径后才可以实例化对象，但是在 Java 中允许通过一个对象找到其所在的类的信息，那么我们说这就是 Class 类的功能。

Class 本身就是一个类的本身，通过 CLass 可以完整的得到一个类中完整的结构，包括此类的方法，属性，构造器。


#### 通过 Class 实例化对象：
实际开发中往往需要通过用户指定 包名.类名 创建对象，这样做的好处是做到代码解耦，方便团队开发。Spring 的底层就是通过反射机制创建对象。

### Class 类常用方法：
#### newInstance()
创建此 Class 对象所表示的类的一个实例对象,前提是**该类必须存在无参构造器**，这也是为何习惯将每一个自定义的类都添加无参构造器的原因。

```java
Class<Person> c = null;//不知道类型就写 ?
try {
	c = (Class<Person>)Class.forName();//需要强转
	Person p = c.newInstance();
} catch (...) {
	...
}
```

#### public Constructor<?>[] getConstructors()
**throws SecurityException**
该方法返回一个包含某些 Constructor 对象的数组，这些对象反映此 Class 对象所表示的类的所有公共构造方法。如果该类没有公共构造方法，或者该类是一个数组类，或者该类反映一个基本类型或 void，则返回一个长度为 0 的数组。 注意，此方法返回 Constructor<T> 对象的数组（即取自此类构造方法的数组）时，此方法的返回类型是 Constructor<?>[]，不是 预期的 Constructor<T>[]。此少量信息的返回类型是必需的，因为从此方法返回之后，该数组可能被修改以保存不同类的 Constructor 对象，而这将违反 Constructor<T>[] 的类型保证。 

**返回：**
表示此类公共构造方法的 Constructor 对象数组 

#### public Class<?>[] getInterfaces()
确定此对象所表示的类或接口实现的接口。 
如果此对象表示一个类，则返回值是一个数组，它包含了表示该类所实现的所有接口的对象。数组中接口对象顺序与此对象所表示的类的声明的 implements 子句中接口名顺序一致。例如，给定声明： 

 class Shimmer implements FloorWax, DessertTopping { ... }
设 s 的值为 Shimmer 的一个实例；表达式： 
 s.getClass().getInterfaces()[0]
 的值为表示 FloorWax 接口的 Class 对象； 
 s.getClass().getInterfaces()[1]
 的值为表示 DessertTopping 接口的 Class 对象。 
如果此对象表示一个接口，则该数组包含表示该接口扩展的所有接口的对象。数组中接口对象顺序与此对象所表示的接口的声明的 extends 子句中接口名顺序一致。 

如果此对象表示一个不实现任何接口的类或接口，则此方法返回一个长度为 0 的数组。 

如果此对象表示一个基本类型或 void，则此方法返回一个长度为 0 的数组。 


**返回：**
**该类所实现的接口的一个数组。**


#### public Class<? super T> getSuperclass()
该方法返回表示此 Class 所表示的实体（类、接口、基本类型或 void）的超类的 Class。如果此 Class 表示 Object 类、一个接口、一个基本类型或 void，则返回 null。如果此对象表示一个数组类，则返回表示该 Object 类的 Class 对象。 

**返回：**
**此对象所表示的类的超类。**


**通过反射获取一个类的全部方法**

#### public Method[] getMethods()
**throws SecurityException** 返回一个包含某些 Method 对象的数组，这些对象反映此 Class 对象所表示的类或接口（包括那些由该类或接口声明的以及从超类和超接口继承的那些的类或接口）的公共 member 方法。数组类返回从 Object 类继承的所有（公共）member 方法。返回数组中的元素没有排序，也没有任何特定的顺序。如果此 Class 对象表示没有公共成员方法的类或接口，或者表示一个基本类型或 void，则此方法返回长度为 0 的数组。 
类初始化方法 <clinit> 不包含在返回的数组中。如果类声明了带有相同参数类型的多个公共成员方法，则它们都会包含在返回的数组中。 

请参阅 Java Language Specification 的第 8.2 和 8.4 节。 


**返回：**
表示此类中公共方法的 Method 对象的数组 


#### public Field[] getFields()
**throws SecurityException**
返回一个包含某些 Field 对象的数组，这些对象反映此 Class 对象所表示的类或接口的所有可访问公共字段。返回数组中的元素没有排序，也没有任何特定的顺序。如果类或接口没有可访问的公共字段，或者表示一个数组类、一个基本类型或 void，则此方法返回长度为 0 的数组。 
特别地，如果该 Class 对象表示一个类，则此方法返回该类及其所有超类的**公共字段**。如果该 Class 对象表示一个接口，则此方法返回该接口及其所有超接口的公共字段。 

该方法不反映数组类的隐式长度字段。用户代码应使用 Array 类的方法来操作数组。 

请参阅 Java Language Specification 的第 8.2 和 8.3 节。 


**返回：**
表示公共字段的 Field 对象的数组 


#### public Field[] getDeclaredFields()
**throws SecurityException**
返回 Field 对象的一个数组，这些对象反映此 Class 对象所表示的类或接口所声明的所有字段。包括公共、保护、默认（包）访问和私有字段，但不包括继承的字段。返回数组中的元素没有排序，也没有任何特定的顺序。如果该类或接口不声明任何字段，或者此 Class 对象表示一个基本类型、一个数组类或 void，则此方法返回一个长度为 0 的数组。 
请参阅 Java Language Specification 的第 8.2 和 8.3 节。 


**返回：**
表示此类所有已声明字段的 Field 对象的数组 

<br/>
## debug 调试
**debug 调试步骤：**
1. 设置断点
2. DEBUG 模式运行程序
3. 观察试图，分析代码执行过程中变量的结果

### 快捷键
- F5 进入：单步执行程序，遇到方法跳入
- F6 跳过：单步执行程序，遇到方法跳过
- F7 跳出：单步执行程序，跳出当前方法
- F8 继续：正常执行程序，遇到断点暂停

<br/>
## Junit 创建测试类
**创建测试类的步骤：**
1. 导入 Junit 测试包
2. 新建一个目录存放测试代码
3. 测试类使用Test作为类的后缀
4. 测试方法使用test作为前缀/后缀
5. 测试方法上面必须有 @Test 修饰
6. 测试方法必须是 public void 修饰，不带任何参数

## 解析 properties 文件
步骤：
1. 创建一个 Properties 对象
2. 使用对象的load()方法进行加载 properties 文件
3. 使用 getProperty(String key) 获取 value 值

>默认 ISO8859-1 编码读写，可以改编写字符集，但不能修改读的字符集

```java
pr.load(类.class.getClassLoder().getResourceAsStream("文件名")
pr.getProperty(...)
```