---
title: Java 异常和异常处理
date: 2017-03-21 22:22:22
categories:
- Java 基础
- 未完成
tags: 
- Exception
- Error
---

Java 定义了 Throwable 类，Exception 和 Error 是它的两个子类
- Exception：表示程序可以处理的异常，可以捕获，遇到这类异常应该尽可能地处理异常，而不应该随意终止程序。
- Error：一般指的是虚拟机相关的问题，如系统崩溃、虚拟机错误、内存空间不足等，对于这类错误导致程序中断，紧靠程序自身是无法恢复及维护的。

<!--more-->

<br/>
## 可检测异常和非检测异常
Java 异常分为：可检测异常和非检测异常

### 可检测异常：通过编译器验证，编译器会强制执行处理，不捕获这个异常，编译器就不能通过，不允许编译。
通常方法上通过 throws 关键字抛出的异常。

### 非检测异常：
不遵循或者声明规则，不一定需要采取任何适当的操作，编译器不会检测是否解决了这样一个异常。
继承自 RuntimeException 类属于非检测异常，不需要声明。

常见的 RuntimeException
- NullPointerException 空指针异常
- ArrayIndexOutOfBoundsException 数组下标越界异常
- ClassCastException 类造型异常
- NumberFormatException 数字转换异常
- StringIndexOutOfBoundsException 字符串下标越界异常
- ...


<br/>
## 异常处理机制：
当程序中抛出一个异常后，程序从导致异常代码出**跳出**，检测寻找 try 关键字，匹配处理该异常的 catch 块。如果找到则执行 catch 语句块中的代码，然后继续往下执行，直到所有的 finally 块执行结束，程序被终止。
如果没有找到该类异常的 catch 块，在所有 finally 块执行结束，程序被终止。

### finally
finally 语句块为异常提供了一个统一的出口。
无论在 try 所指定的程序块中是否抛出异常， finally 都要被执行，通常这 finally 语句中进行资源释放，关闭连接，删除临时文件等


### try/catch
try{}语句块指定一段代码，执行过程中，该代码块可能发生一种或多种类型的异常，它后面的 catch(){}语句块分别对这些异常进行相应的处理。其中 catch()里面是异常类型，{}里面是对异常处理的代码，如果没有异常产生，所有的 catch 块都不执行。

### catch
catch 可以有多个，用于处理可能产生不同类型异常的代码块
catch 捕获的类型应遵循【先子后父】原则：子类异常在前，父类异常灾后，按照顺序依次捕获，否则编译不通过
```Java
try (//指定一段代码，执行过程中可能会发生一种或多种类型的异常
	要执行的代码
) catch (A 类的子类异常 e){//分别对这些异常进行处理
	处理第一个异常的代码
} catch (A 类的另一个子类异常 e){
	处理第二个异常的代码
} catch (A 类异常 e){
	处理第三个异常的代码
} finally {//finally 代码块可以省略
	有没有异常都执行这里
}
```

>代码示例：
```Java
System.out.println("开始");
try {
	String str;//用这个 str 作为模拟
	str = null;
	//str = "";
	//str = "a";
	//str = "abcdefg";
	//str = "1234567";
	System.out.println(str.length());
	System.out.println(str.charAt(5));
	System.out.println(Integer.parseInt(str));
	System.out.println("try 块执行结束...");
} catch(NullPointerException e) {
	System.out.println("str 为 null");
} catch(StringIndexOutOfBoundsException e) {
	System.out.println("字符串数组下标越界");
//} catch(NumberFormatException e) {
//	System.out.println("类型转换出错");
} catch (Exception e) {//放在最后
	System.out.println("貌似出现了未知异常:");
	e.printStackTrace();
} finally {
	System.out.println("有没有异常都有我");
}
System.out.println("程序结束");
```


### 常用方法
- printStackTrace()：输出发生异常时堆栈信息
- getMessage()：获取发生异常时事件信息。

<br/>
## 自定义异常：
Java 异常机制可以保证程序的健壮性和安全性。虽然 Java 提供了很多直接处理异常的类，但有时候需要更明确的捕获和处理异常，以呈现更好地用户体验，需要开发者自定义异常。
1. 自定义异常，需要继承 Exception 类。
```Java
class 【自定义类名称】 extends Exception()
```
2. 定义好自己的异常类后，使用工具生成构造器。

### throw**s** 关键字：
在某种特殊的情况下，程序员主动抛出某种特定的异常类型时，让上一层异常处理来捕获，可以使用 throws 关键字。

throws 是指 抛出一个具体的异常类型。
不能在 main 方法中抛异常！


### throw 关键字：
程序中会有很多方法，这些方法可能会因为某些错误而引发异常，但是你又不想进行处理，而希望通过调用者来进行统一的处理，这个时候可以用 throw 关键字声明这个**方法**会抛出异常。

throw 是用来声明一个方法可能会抛出某些异常。

```Jaava
方法名(参数...) throw
```