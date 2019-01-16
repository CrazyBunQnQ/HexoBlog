---
title: Hash Code 散列码
date: 2017-03-18 22:22:22
categories: Java 基础
tags: 
- 散列码
- hash code
---

**散列码（hash code）散列码是由对象的实例域产生的一个整数**。更准确的说,**具有不同数据域的对象将产生不同的散列码。**散列码是没有规律的。如果 x 和 y 是两个不同的对象，x.hashCode() 与 y.hashCode() 基本上不会相同。

<!-- more -->

## hashCode() 方法
hashCode() 方法就是获取该对象散列码的方法，hashCode() 方法定义在 Object 类中，因此每个对象都有一个默认的散列码，其值为对象的存储地址。
但是很多类都需要重写获取散列码的方法，例如：String 类中使用下面的算法计算散列码（**散列函数**）：

```java
	int hash;//默认为 0
	public int hashCode() {
        int h = hash;
        if (h == 0 && value.length > 0) {//这里计算 hash code
            char val[] = value;
            for (int i = 0; i < value.length; i++) {
                h = 31 * h + val[i];
            }
            hash = h;
        }
        return h;
    }
```

>计算字符串散列码的公式为：
>$ h = val[0]·31^(L-1) + ... + val[L-3]·31^2 + val[L-2]·31^1 + val[L-1]·31^0 $
>举个例子，获取 “call” 的散列码：
>字符 c 对应的 unicode 为 99，a 对应的 unicode 为 97，l 对应的 unicode 为 108，所以字符串 “call” 的哈希值为
>$ 3045982 = 99 · 31^3 + 97 · 31^2 + 108 · 31^1 + 108 · 31 = 108 + 31 · (108 + 31 · (97 + 31 · 99)) $

由于 hashCode 方法定义在 Object 类中，因此每个对象都有一个默认的散列码，其值为对象的存储地址。通过下面这段代码对比一下 String 和 StringBuilder 的散列码：

```java
	String s = "Ok";
	StringBuilder sb = new StringBuilder(s);
	System.out.println(s.hashCode() + " " + sb.hashCode());//输出 2556 366712642
	String t = new String("Ok");
	StringBuilder tb = new StringBuilder(t);
	System.out.println(t.hashCode() + " " + tb.hashCode());//输出 2556 1829164700
```

|对象|散列码|
|:--:|:--:|
|s|2556|
|sb|366712642|
|t|2556|
|tb|1829164700|

可以看到，字符串 s 与 t 拥有相同的散列码，这是因为字符串的散列码是由内容计算的，而 StringBuilder 类的 sb 和 tb 却有着不同的散列码，这是因为在 StringBuilder 类中没有定义 hashCode 方法，所以它的散列码是由 Object 类默认的 hashCode 方法导出的对象存储地址。

**equals 与 hashCode 的定义必须一致：如果 x.queals(y) 返回 true，那么 x.hashCode 就必须与 y.hashCode() 具有相同的值。**

equals()相等的两个对象，hashcode()一定相等； 
equals（）不相等的两个对象，hashcode()可能相等，也可能不等。

反过来：hashcode()不等，一定能推出equals()也不等；hashcode()相等，equals()可能相等，也可能不等。