---
title: 深入了解 String
date: 2017-03-14 22:22:22
categories: Java基础
tags: 
- String
- 字符串
- StringBuilder
- StringBuffer
---

String 类型几乎是除了 8 种[基本数据类型](/2017/02/20/数据类型与类型转换/)外最常用的数据类型，深入的了解 String 类型可以更好地帮助我们写代码。

<!-- more -->

## String 的概念 ##

Java 字符串就是 Unicode 字符序列。在标准 Java 类库中提供了一个预定义类，就是 java.lang.String ，**每个用双引号括起来的字符串都是 String 类的一个实例**。

>java.lang 包中的类，可以不用导入，直接使用

- java.lang.String 类使用了 final 修饰，所以** String 类不能被继承**。
- **String 类的底层实际上就是字符数组，以及对字符数组的一系列操作。**
- 字符串无论是中文还是英文，每个字符对应都是两个字节的定长编码。

### 字符串的拼接

- Java 允许使用 + 号链接（拼接）两个字符串。
- 当将一个字符串与一个非字符串的值进行拼接时，后者将被转换成字符串

>任何一个 Java 对象都可以转换成字符串

### 空串与 null

- **空串 "" 是长度为 0 的字符串。**也叫空字符串。
空串是一个 Java 对象，有自己的长度（0）和内容（空）

	String str = "";
	System.out.println(str.length());//输出为 0

判断字符串是否为空的两个方法：

	if (str.length() == 0)
	//或
	if (str.equals(""))

- null 表示没有任何对象与该变量关联（**String 类型是引用类型，不是基本类型**）

判断一个字符串是否为 null：

	if (str == null)

其实更常见的是检查一个字符串既不是 null 也不为空：

	if (str !== null && str.length() != 0)

>如果 str 为 null 时，调用 str.length()会报空指针异常
>所以**这里一定要先检查是否为 null**
>因为 && 和 || 运算符是“短路”运算，前面的表达式已经能够出结果了，则不会再计算后面的表达式
>所以这里即使 str 为空，也就不会报空指针异常

## String 常量池：
String 类没有提供用于修改字符串的方法，所以在 Java 文档中将 **String 类对象称为 `不可变字符串` ，字符串一旦创建，永远无法改变，但字符串的引用可以重新赋值。重新赋值意味着一旦改变则一定创建一个新的对象。**
这样会大大降低修改字符串的效率，但是不可变字符串有个优点：**编译器可以让字符串 `共享` 在 `常量池` 中**。

>当使用字面量创建字符对象时，JVM 会重用之前创建过的对象。
>每当使用字面量创建对象时，JVM 会首先查看常量池中是否含有该字符串存在;
>若有则直接使用（不用创建对象），否则创建对象并缓存到常量池中供下次使用。
>当使用 “+” 拼接全部为字面量的字符串进行赋值时，JVM 会自动优化，它会直接用拼接结果去常量池中查找是否创建过该对象。

**Java 建议使用字面量创建对象字符，以减少内存开销**，String 代码示例：

	String s1 = "abc";//常量池暂时没有 "abc"，所以这里会创建一个新对象
	String s2 = "abc";//首先去常量池查找，所以不会创建新对象
	String s3 = new String("abc");//创建了新对象，使用new关键字不会缓存到常量池当中
	System.out.println("s1 == s2 ? " + s1 == s2);//输出 true，因为引用同样的地址
	System.out.println("s1 == s3 ? " + s1 == s3);//输出 false，因为地址不同
	s1 = s1 + "";//只要改变，一定创建新对象
	System.out.println("s1 == s2 ? " + s1 == s2);//输出 false，因为又创建了新对象
	System.out.println("s1 == s3 ? " + s1 == s3);//输出 false
	String s4 = "a" + "bc";//JVM 会将代码优化：JVM 看到的是"abc",该字符串常量池已存在，所以直接使用即可
	System.out.println("s1 == s4 ? " + s1 == s4);//输出 true
	String s5 = "a";
	String s6 = s5 + "bc";//这里 JVM 则不会优化，所以不会使用常量池中的"abc"
	System.out.println("s2 == s6 ? " + s2 == s6);//输出 false

## String 常用方法 ##
String 类中提供了很多方法，这里只介绍几个最常用的方法，更多的方法使用请查看 Java API 文档。

### equals 方法 ###
由于字符串是引用类型，所以用 “==” 判断的是该引用类型的内存地址是否相等，若想要检测两个字符串的值是否相等时，则使用 equals 方法：

	strA.equals(strB);//判断 strA 的值是否等于 strB 的值

>strA 与 strB 可以使字符串变量，也可以是字符串常量。
>判断字符串的值是否相等建议不要使用 “==”，除非确实要查看存放地址是否相同。

### length 方法
String 在内存中采用 Unicode 编码，每个字符占用 2 个字节，任何一个字符（无论是中文还是英文）都算一个长度。可以使用 length 方法查看字符串的长度。

	字符串类型变量.length();//返回 int 类型
	String str1 ="一二三四五";
	System.out.println(str1.length());//输出5
	String str2 = "hello";
	System.out.println(str1.length());//输出5

### indexOf 方法 ###
indexOf 方法用来查找字符串位置，未找到则返回 -1。

	int indexOf(String str);//在字符串中检测给定字符串str，第一次出现的位置。
	int indexOf(String str, int fromIndex);//在字符串中的第 fromIndex 位置（包含）开始检索给定字符串 str 的位置。
	int lastIndexOf(String str);//返回 str 出现在字符串中最后一次的位置。

例如：

	String str = "1234567654321";
	int index = str.indexOf("1");//index = 0,因为字符串底层是数组，数组下标从 0 开始
	index = str.indexOf("0");//index = -1，因为没找到
	index = str.indexOf("1",2);//index = 12
	index = str.lastIndexOf("1");//index = 12
	
### substring 方法
substring 方法可以从一个较大的字符串中提取一个子串。

	String substring(int beginIndex, int endIndex);//返回从 beginIndex 位置(包含)开始到 endIndex 位置(不包含)结束的字符串
	String substring(int beginIndex);//返回从 beginIndex 位置开始到结尾的字符串

示例：

	String host ="www.oracle.com.cn ";
	String sub = host.substring(4);//sub = "oracle.com.cn "; 
	sub = host.substring(4,10);//sub = "oracle";截取字符串第4位到第10位之间的字符串

>**Java API 中有一个特点：使用两个数表示范围时，含头不含尾**

### trim 方法
trim 方法去除字符串前后的空字符（**不能去除中间的空白字符**）

	System.out.println(host.length());//输出18
	String trim = host.trim();//trim = "www.oracle.com.cn";
	System.out.println(trim.length()); //输出17

### charAt 方法
charAt 方法返回字符串中指定位置的字符

	char charAt(int index);//返字符串中第 index 个字符

### startsWith 和 endsWith 方法
检测一个字符串是否以指定的字符串开头或结尾

	boolean startsWith(String prefix);//字符串是否以指定字符串开头
	boolean endsWith(String suffix);//字符串是否以指定字符串结尾

### toUpperCase 和 toLowerCase 方法
将字符串中的英文转换成大写或小写

	String uoUpperCase();//将字符串英文转换为大写
	String uoLowerCase();//将字符串英文转换为小写

### valueOf 方法
将其他类型转换成字符串类型（有若干重载方法）

	String.valueOf(各种类型 a);//

代码示例：

	int value = 123;
	double pi = 3.1419526;
	boolean falg = false;
	char [] charArr = {'a','b','c'};
	str1 = String.valueOf(value);//"123"
	str2 = String.valueOf(pi);//"3.1415926"
	str3 = String.valueOf(value);//"false"
	str4 = String.valueOf(value);//"abc"

### 操作[正则表达式](/2017/03/15/正则表达式/)的方法

**matchs 方法：**
将一个字符串与正则表达式进行匹配，成功返回 true，否则返回 false，格式：

	boolean matches(String regex);

邮箱正则表达式 `[a-zA-Z0-9_]+@[a-zA-Z0-9_]+(.[a-zA-Z]+)+` 示例:

	String regex = "[a-zA-Z0-9_]+@[a-zA-Z0-9_]+(\\.[a-zA-Z]+)+";
	System.out.println(regex);//可以看到输出了我们想要的正则表达式
	String email = "bao_456@163.c0m";
	boolean b = email.matches(regex);
	System.out.println(email + (b?"是个邮箱":"邮箱不合法"));//输出不合法
	String email = "bao_456@163.com";
	System.out.println(email + (b?"是个邮箱":"邮箱不合法"));//输出合法

>**因为在正则表达式中“.”表示任意字符，为了让它单纯的表示一个“\.”,所以需要转义“\\.”**
>**又因为在 Java 中“\”有特殊含义，所以还需要用“\\\”表示“\”**

**spit 方法：**
以 regex 表达式进行分割，将字符串分割成字符串数组，格式：

	String[] spit(String regex);//

示例：

	String str = "abc123def456jk1789";
	String[] arr = str.split("[0-9]");//单个字符
	for (int i = 0; i < arr.length; i++) {
		System.out.println(arr[i]);//结尾的三个空白字符被忽略
	}

>按照数字进行拆分，当字符串中连续匹配上两个，那么中间会拆分一个空字符
>但是在字符串末尾连续匹配所有被拆分的空字符串被忽略

	String str = "abc123def456jk1789";
	arr = str.split("[0-9]+");//多个个字符
	for (int i = 0; i < arr.length; i++) {
		System.out.println(arr[i]);
	}

图片重命名示例：

	String imageName = "1.jpg";
	String[] arr = imageName.split
	imageName = System.currentTimeMillis() + "." + arr[arr.length - 1];
	System.

当然也可以不用正则表达式重命名：

	imageName = "1.2.3.jpg";
	int index = imageName.lastIndexOf(".");
	String ends = imageName.substring(index);
	imageNmae = System.currentTimeMillis() + ends;
	System.out.print(imageName);

**replaceAll 方法：**
将字符串中匹配正则表达式的字符串全部替换为新的字符串，格式：

	replaceAll(String regex, String str)

敏感字符屏蔽示例：

	String str = "123abc456jk1789mmm";
	str = str.replaceAll("[0-9]+","***");
	System.out.println(str);//输出 “***abc***jk***mmm”
	regex = "(tm|sb|mmp|jb|qnmlgb)";
	String message = "你这个sb，qnmlgb，就是个jb";
	message = message.replaceAll(regex,"**");
	System.out.println(message);

## String 、StringBuilder 和 StringBuffer
由于 String 的设计不适合频繁修改内容，所以 Java 提供了专门用来修改字符串内容的类：StringBuffer 和 StringBuilder，其提供编译字符串内容的相关方法，这两个类在修改字符串时的性能很好。

例如，同样循环修改 100000 次,三者耗时对比：

	long startTime = new Date().getTime();
	String str = "a";
	for (int i = 0; i < 100000; i++) {
		str += "a";
	}
	long costTime = new Date().getTime() - startTime;
	System.out.println("String 用时 " + costTime + " 毫秒");//需要好几千毫秒，修改字符串性能开销很大，并且容易造成内存泄漏

	startTime = new Date().getTime();
	StringBuilder sbuilder = new StringBuilder();
	for (int i = 0; i < 100000; i++) {
		sbuilder.append("a");
	}
	costTime = new Date().getTime() - startTime;
	System.out.println("StringBuilder 用时 " + costTime + " 毫秒");//性能明显高于修改 String,在我的电脑上耗时 0 毫秒
	
	startTime = new Date().getTime();
	StringBuffer sbuffer = new StringBuffer();
	for (int i = 0; i < 100000; i++) {
		sbuffer.append("a");
	}
	costTime = new Date().getTime() - startTime;
	System.out.println("StringBuffer 用时 " + costTime + " 毫秒");//性能也明显高于直接修改 String，在我的电脑上耗时 15 毫秒，比 StringBuilder 稍慢

### StringBuilder 与 StringBuffer 的常用方法

	append(String str);//追加字符串
	insert(int index,String str);向指定字符串位置插入字符串
	delete(int star, int end);//删除指定位置的字符串
	replace(int start, int end, String str);//将指定位置的字符串替换成给定的字符串str
	reverse();//反转字符串

>以上方法返回值都是 StringBuilder 或 StringBuffer

### String, StringBuffer 和 StringBuilder 区别：
- String 及 StringBuffer, StringBuilder 都是 java.lang 包下面的。
- String 是不可变的，StringBuffer 及 StringBuilder 是可变的。
- StringBuilder 是线程不安全的，并发处理，性能比 StringBuffer 稍快
- StringBuffer 是线程安全的，同步处理的，性能比 StringBuilder 稍慢