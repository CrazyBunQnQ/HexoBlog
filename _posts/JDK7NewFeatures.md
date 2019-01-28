---
title: JDK 7 新特性
date: 2019-01-27 22:22:22
categories: Java
tags:
- JDK
---

面试的时候面试官问我用的哪个 JDK 版本，然后问我有啥新特性，支支吾吾就答了几个...
回来赶紧看看都有啥新特性，查完发现我平时还用了不少呢，有些居然不知道是新特性...好尴尬
赶紧复习下...
<!-- [JDK 8 新特性]()看这里 -->

<!-- more -->

## 提高工作效率

JDK 7 新特性中，最直观的修改就是优化了一些 JDK 6 实现起来比较琐碎的代码，例如 `switch` 不能使用 `String` 类型等
下面挨个说说这些修改：

### Switch 语句允许使用 String 类型

```java
String test = "a";
switch (test) {
    case "a":
        System.out.println("这是字母 a");
        break;
    case "b":
        System.out.println("这是字母 b");
        break;
    case "c":
        System.out.println("这是字母 c");
        break;
    default:
        System.out.println("不知道这是什么");
}
```

### catch 可以一次处理多个异常：将多个异常用同一个 catch 捕获，减少重复代码

```java
try {
    ...
// 捕获多个异常
} catch (IOException | SQLException e) {
    ...
} catch (Exception e) {
    ...
}
```

### try 可以自动关闭资源

```java
try (BufferedReader br = new BufferedReader(new FileReader(path))) {
     return br.readLine();
} catch (Exception e) {
    ...
}
```
以上代码等同于：

```java
BufferedReader br = new BufferedReader(new FileReader(path));
try {
    return br.readLine();
} catch (Exception e) {
    ...
} finally {
    if (br != null)
        br.close();
}
```
>只有实现了 `java.lang.AutoCloseable` 接口，或者 `java.io.Closable`（实际上继随自 `java.lang.AutoCloseable`）接口的对象，才会自动调用其 `close()` 函数。

关于 `java.lang.AutoCloseable` 与 `java.io.Closable` 的官方解释如下：

- AutoClosable:
   - 关闭此资源，放弃任何基础资源。这个方法在 `try-with-resources` 语句管理的对象上自动调用。
   - 虽然声明此接口方法抛出异常，但强烈建议实现者声明 `close` 方法的具体实现以抛出更具体的异常，或者如果关闭操作不能失败则不抛出任何异常。
   - 强烈建议此接口的实现者不要使用 `close` 方法抛出 `InterruptedException`。此异常与线程的中断状态交互，如果抑制 `InterruptedException`，则可能发生运行时错误行为。更一般地说，如果它会导致异常被抑制的问题，`AutoCloseable.close` 方法不应该抛出它。
   - 请注意，与 `Closeable` 的 `close` 方法不同，此 `close` 方法不需要是**幂等**的。换句话说，不止一次调用此 `close` 方法可能会产生一些可见的副作用，这与 `Closeable.close` 不同，如果多次调用则需要它无效。但是，强烈建议强制使用此接口的实现者使其 `close` 方法具有幂等性。
   - Exception - if this resource cannot be closed
- Closable:
   - 关闭此流并释放与之关联的任何系统资源。如果流已经关闭，则调用此方法无效。
   - IOException - if an I/O error occurs

>幂等：同样的请求被执行一次与连续执行多次的效果是一样的 `f(f(x)) = f(x)`

### 支持数字常量和二进制常量中使用下划线

```java
long creditCardNumber = 1234_5678_9012_3456L;// 等同于 long creditCardNumber = 1234567890123456L;
long socialSecurityNumber = 999_99_9999L;// 等同于 long socialSecurityNumber = 999999999L;
float pi = 3.14_15F;// 等同于 float pi = 3.1415F;
long hexBytes = 0xFF_EC_DE_5E;// 等同于 long hexBytes = 0xFFECDE5E; 或 long hexBytes = 4293713502L;
long hexWords = 0xCAFE_BABE;// 同上
long maxLong = 0x7fff_ffff_ffff_ffffL;//同上
byte nybbles = 0b0010_0101;// 等同于 byte nybbles = ob0010_0101; 或 byte nybbles = 37;
long bytes = 0b11010010_01101001_10010100_10010010;
//float pi1 = 3_.1415F;// 无效;不能将下划线放在小数点附近  
//float pi2 = 3._1415F;// 无效;不能将下划线放在小数点附近 
//long socialSecurityNumber1= 999_99_9999_L;// 无效;在 L 后缀之前不能加下划线
//int x1 = _52;// 这是一个标识符，而不是数字文字  
int x2 = 5_2;// 等同于 int x2 = 52;
//int x3 = 52_;// 无效;不能将下划线放在文字的末尾
int x4 = 5_______2;// 等同于 innt x4 = 52
//int x5 = 0_x52;// 无效;不能将下划线放在 0x 基数前缀中
//int x6 = 0x_52;// 无效;不能将下划线放在数字的开头
int x7 = 0x5_2;// 等同于 int x7 = 0x52; 或 int x7 = 82;
//int x8 = 0x52_;// 无效;不能将下划线放在数字的末尾
int x9 = 0_52;// 等同于 int x9 = 52;
int x10 = 05_2;// 等同于 int x10 = 52
//int x11 = 052_;// 无效;不能将下划线放在数字的末尾
```

### 支持将整数类型用二进制表示，**用 `0b` 或 `0B` 开头**

```java
byte b = (byte)0b0010_0010;// 等同于 byte b = 34;
short s = (short)ob1010_0001_0100_0101;// 等同于 short s = 41285;
int i1 = 0b1010_0001_0100_0101_1010_0001_0100_0101;// 等同于 int i1 = 2705695045;
int i2 = 0B101;// 等同于 int i2 = 5;
// 注意 long 类型要以 'L' 结尾，不推荐使用 'l'
long l = 0b1010_0001_0100_0101_1010_0001L;// 等同于 long l = 10569121L;
int[] arr = {0b10, 0B101, 0b110};// 等同于 int[] arr = {2, 5, 6};
```

### 简化泛型实例的创建代码

创建泛型实例时可以去掉后面 new 部分的泛型类型

- JDK 7 优化前

    ```java
    List strList = new ArrayList();
    List<String> strList4 = new ArrayList<String>();
    List<Map<String, List<String>>> strList5 =  new ArrayList<Map<String, List<String>>>();
    ```
- JDK 7 优化后——编译器使用尖括号 `<>` 推断类型

    ```java
    List<String> strList0 = new ArrayList<String>();
    List<Map<String, List<String>>> strList1 =  new ArrayList<Map<String, List<String>>>();
    List<String> strList2 = new ArrayList<>();
    List<Map<String, List<String>>> strList3 = new ArrayList<>();
    List<String> list = new ArrayList<>();
    list.add("A");
    //list.addAll(new ArrayList<>());// 这里需要添加泛型类型
    ```
