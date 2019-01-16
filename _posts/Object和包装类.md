---
title: Object 和包装类
date: 2017-03-15 23:33:33
description: "Java 中，有一个神通广大的超类，它就是 Object，Object 位于 java.lang 包下面，所有类的父类都集成自 Object。所以 Object 类型的引用变量可以指向任何类型。"
categories: Java 基础
tags: 
- Object
- 超类
- 包装类
---

## Object: ##
Java 中，有一个神通广大的超类，它就是 Object，Object 位于 java.lang 包下面，所有类的父类都集成自 Object。所以 Object 类型的引用变量可以指向任何类型。
**Object 有两个核心方法：toString 方法和 equals 方法**

### toString 方法： ###
**toString 方法返回值为 String 类型，用于返回对象值，即内存中的位置。**
Object 类中的 toString 方法返回的字符串为：类名@散列码
>Java 中很多地方默认调用对象的 toString()，如果不重写 toString() 方法，将会使用父类的 toString() 方法。所以强烈建议为自定义的类，重写 toString()方法

**重写 toString():**
对于重写的 toString() 方法所返回字符串格式，没有统一的要求，原则上返回字符串应当包含当前类的属性。
>推荐使用 JSON 格式~

</br>
### equals 方法： ###
**equals(Object object)方法返回类型为 boolean 类型，用于判断一个对象是否等于另一个对象**
**Object 类中的该方法采用 == 进行判断两个对象是否相同**（存储地址相同），而在实际开发中一般需要重写 equals 方法，通过比较对象的属性来判断对象像不像。使得 equals 更有意义。（不重写则等同于 ==）

**重写 equals 的方法需要具有以下特性：**
- **自反性**：对于任何非空引用 x，x.equals(x) 应当返回 true。
- **对称性**：对于任何引用 x 和 y，当且仅当 y.equals(x) 返回 true，x.equals(y) 也应该返回 true。
- **传递性**：对于任何引用 x、y 和 z，如果 x.euqals(y) 返回 true，y.equals(z) 返回 true，则 x.equals(z) 也应该返回 true。
- **一致性**：如果 x 和 y 引用的对象没有发生变化，反复调用 x.equals(y) 应该返回同样的结果。
- 对于任意**非空**引用 x，x.equals(null) 应该返回 false。

**重写 equals 的步骤：**
- 检测 obj 是否为 null，如果为 null，返回 false。
- 检测 this 与 obj 是否引用同一个对象（任何对象与 自己 比较返回 true）。
- 比较 this 与 obj 是否同属一个类。如果 equals 方法在每个子类中有所改变，就是用 getClass 检测；如果所有的子类都有一样的 equals 方法，就用 instanceof 检测。
- 如果使用 instanceof 检测，将 obj 转换为相应的类类型变量
- 根据需求比较像不像。使用 == 比较基本类型，使用 equals 比较对象域。

代码示例：

```java
	public boolean equals(Object obj){
		if(obj = null) {//判断是否为空
			return false;
		}
		if (obj==this) {//判断是否是自己
			return true;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		if (obj instanceof Person) {//假如这是 Person 类的 equals 方法
			Person p =(Person)obj;
			return p.name == this.name && p.age == this.age && p.sex == this.sex;//这里根据实际需求来写
		}
		return false;
	}
```

</br>
### hashCode 方法
hashCode() 方法又叫[散列函数](/2017/03/19/HashCode 散列码/#散列函数)，**若重写 equals 方法则必须重写 hashCode 方法。**

</br>
### == 和 equals 区别 ###
**==**
- 是运算符
- 用于比较变量的值，可以任何类型，若是引用类型则比较两个对象存储的地址是否相同。**

**equals**
- 是 Object 方法，重写之前与 == 效果完全一样
- 重写之后也是个方法...用于比较两个对象的内容是否一致（根据你的需求判断两个对象像不像）

>重要的事情要多强调~ **Object 默认的 equals 方法等同于 ==**

</br>
## 包装类 ##
所有基本数据类型都有一个与之对应的类，称为包装类。包装类是 final 修饰的，位于 java.lang 包下。**包装类的默认值是 null** 

### 8 个[基本数据类型](/2017/02/20/数据类型与类型转换/)的包装类： ###

|基本数据类型|包装类|父类|
|:---:|:---:|:---:|
|int|java.lang.Integer|java.lang.Number|
|lang|java.lang.Long|java.lang.Number|
|double|java.lang.Double|java.lang.Number|
|short|java.lang.Short|java.lang.Number|
|float|java.lang.Float|java.lang.Number|
|byte|java.lang.Byte|java.lang.Number|
|char|java.lang.Character|java.lang.Object|
|boolean|java.lang.Boolean|java.lang.Object|

</br>
### 包装类中的常量： ###

|常量名|描述|
|:--:|:--:|
|MAX_VALUE|表示包装类的基本类型取值范围最大值|
|MIN_VALUE|表示包装类的基本类型取值范围最小值|

>char 和 boolean 中没有这两个常量

</br>
### 基本类型转换为包装类： ###

- 通过 new 关键字进行转换，如： `new Integer(21)`
- 通过包装类提供的静态方法 valueOf 方法，如： `Integer.valueOf(21)`

</br>
### 包装类转基本类型 ###

- 调用 XXXValue(XXX)，返回基本类型。如 `IntegerValue(new Integer(123))`

</br>
### 字符串转换基本类型： ###

通过包装类中的静态方法 parseXXX(String str)，将给定的字符串解析为对应的基本类型，**前提是该字符串能正确的描述基本类型可以保存的值**，若不能，则报错：java.lang.NumberFormatException

```java
	String str = "123";
	int i = Integer.parseInt(str);//i = 123
	double d = Double.parseDouble(str);//d = 123.0
	str = "123abc";
	int i = Integer.parseInt(str);//报错：java.lang.NumberFormatException
```

</br>
### 自动拆装箱： ###
JDK 5.0 (JDK 5.0 之后的版本号改为 JDK 1.6，每一个大版本增加 0.1 )之后加入了自动拆装箱功能，自动拆装箱是依靠 JDK 5.0 的编译器在编译的时候预处理的。

自动拆箱：

```java
	int i = Integer.valueOf(123);//JDK 5.0 之后这样写不会报错
	//实际上编译器在生成字节码文件时会替换成如下代码
	int a = Integer.valueOf(123).intValue();
```

自动装箱：

```java
	Integer a = 100;//JDK 5.0 之后可以直接这样写
	//编译器会在生成字节码文件时替换为如下代码
	Integer a = Integer.valueOf(100);
```

>由于**包装类的默认值是 null** ，意味着包装类可以存储 null 值。
>所以在特定情况下更适合使用包装类，例如在数据库中数字类型数据有可能是空的，这时若使用 int 类型存储 null 值就会报错了。