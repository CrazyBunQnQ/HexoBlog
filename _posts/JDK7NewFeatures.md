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

## Switch 语句允许使用 String 类型

这大概是最直观的修改了，我是听常用的...

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

## catch 可以一次处理多个异常：将多个异常用同一个 catch 捕获，减少重复代码

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

## try 可以自动关闭资源

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

## 支持数字常量和二进制常量中使用下划线

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

## 支持将整数类型用二进制表示，**用 `0b` 或 `0B` 开头**

```java
byte b = (byte)0b0010_0010;// 等同于 byte b = 34;
short s = (short)ob1010_0001_0100_0101;// 等同于 short s = 41285;
int i1 = 0b1010_0001_0100_0101_1010_0001_0100_0101;// 等同于 int i1 = 2705695045;
int i2 = 0B101;// 等同于 int i2 = 5;
// 注意 long 类型要以 'L' 结尾，不推荐使用 'l'
long l = 0b1010_0001_0100_0101_1010_0001L;// 等同于 long l = 10569121L;
int[] arr = {0b10, 0B101, 0b110};// 等同于 int[] arr = {2, 5, 6};
```

## 简化泛型实例的创建代码

创建泛型实例时可以去掉后面 new 部分的泛型类型

### JDK 7 优化前

```java
List strList = new ArrayList();
List<String> strList4 = new ArrayList<String>();
List<Map<String, List<String>>> strList5 =  new ArrayList<Map<String, List<String>>>();
```

### JDK 7 优化后——编译器使用尖括号 `<>` 推断类型

```java
List<String> strList0 = new ArrayList<String>();
List<Map<String, List<String>>> strList1 =  new ArrayList<Map<String, List<String>>>();
List<String> strList2 = new ArrayList<>();
List<Map<String, List<String>>> strList3 = new ArrayList<>();
List<String> list = new ArrayList<>();
list.add("A");
//list.addAll(new ArrayList<>());// 这里需要添加泛型类型
```

## 改进编译警告和错误

### 示例 1:

```java
List l = new ArrayList<Number>();
List<String> ls = l;// 未经检查的警告
l.add(0, new Integer(42));// 另一个未经检查的警告
String s = ls.get(0);// 抛出 ClassCastException 异常
```

### 示例 2:

```java
public static <T> void addToList (List<T> listArg, T... elements) {
   for (T x : elements) {
     listArg.add(x);
   }
}
```

在可变参数方法中传递非具体化参数，你会得到一个警告：

>warning: [varargs] Possible heap pollution from parameterized vararg type.

要消除警告，可以有三种方式:

1. 加 annotation `@SafeVarargs`
2. 加 annotation `@SuppressWarnings({"unchecked", "varargs"})`
3. 使用编译器参数 `–Xlint:varargs;`

## 新增 ThreadLocalRandom 类

ThreadLocalRandom 继承自 Random

>A random number generator isolated to the current thread. Like the global Random generator used by the Math class, a ThreadLocalRandom is initialized with an internally generated seed that may not otherwise be modified. When applicable, use of ThreadLocalRandom rather than shared Random objects in concurrent programs will typically encounter much less overhead and contention. Use of ThreadLocalRandom is particularly appropriate when multiple tasks (for example, each a ForkJoinTask) use random numbers in parallel in thread pools.
>
>Usages of this class should typically be of the form: ThreadLocalRandom.current().nextX(...) (where X is Int, Long, etc). When all usages are of this form, it is never possible to accidently share a ThreadLocalRandom across multiple threads.
>
>This class also provides additional commonly used bounded random generation methods.

随机数生成器被隔离到当前线程。与 Math 类使用的全局 Random 生成器一样，ThreadLocalRandom 使用内部生成的种子进行初始化，否则可能无法修改。适用时，在并发程序中使用 ThreadLocalRandom 而不是共享 Random 对象通常会遇到更少的开销和争用。当多个任务（例如，每个 ForkJoinTask）在线程池中并行使用随机数时，使用 ThreadLocalRandom 是特别合适的。

此类的用法通常应为以下形式: `ThreadLocalRandom.current().nextX(...)`(其中 X 为 Int, Long 等)。当所有用法都是这种形式时，永远不可能在多个线程中意外地共享 ThreadLocalRandom。

该类还提供了其他常用的有界随机生成方法。

>实际上就是使用 threadlocal 保证并发下的随机数生成的线程安全

### 方法

- current
    - public static ThreadLocalRandom current()
    - Returns: 当前线程的 ThreadLocalRandom
- setSeed
    - public void setSeed(long seed)
    - Overrides: Random 类的 setSeed 方法
    - Parameters: seed - 最初的种子
    - Throws: UnsupportedOperationException - always
- next
    - protected int next(int bits)
    - Description (从 Random 类中复制过来的):
        - 生成下一个伪随机数。子类应该覆盖它，因为所有其他方法都使用它
        - `next` 的一般约定是它返回一个 int 值，如果参数位在 1 和 32 之间(包括)，那么返回值的许多低位将是(近似)独立选择的位值，每个位值都是(大约)同样可能是 0 或 1。`next` 方法由类 `Random` 实现，通过原子方式将种子更新为 `(seed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1)` 并返回 `(int)(seed >>> (48 - bits))`.
            >The general contract of next is that it returns an int value and if the argument bits is between 1 and 32 (inclusive), then that many low-order bits of the returned value will be (approximately) independently chosen bit values, each of which is (approximately) equally likely to be 0 or 1.
            >
            >The method next is implemented by class Random by atomically updating the seed to `(seed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1)` and returning `(int)(seed >>> (48 - bits))`.
        - 这是[线性同余伪随机数](https://zhuanlan.zhihu.com/p/36301602)生成器，由 D.H.Lehmer 所定义并由 Donald E.Knuth 在《The Computer of Computer Programming，Volume 3：Seminumerical Algorithms，section 3.2.1》中描述。
            >This is a linear congruential pseudorandom number generator, as defined by D. H. Lehmer and described by Donald E. Knuth in The Art of Computer Programming, Volume 3: Seminumerical Algorithms, section 3.2.1.
    - Overrides: Random 类的 next 方法
    - Parameters: bits - 随机位
    - Returns: 来自此随机数生成器序列的下一个伪随机值
- nextInt
    - public int nextInt(int least, int bound)
    - Parameters:
        - least - 下限
        - bound - 上限(不包括)
    - Returns: 伪随机，在给定的最小值(包括)和绑定(不包括)之间均匀分布的值。
    - Throws: IllegalArgumentException - 如果最小值大于或等于上限
- nextLong
    - public long nextLong(long n)
    - Parameters: n - 要返回的随机数的界限。必须是正数。
    - Returns: 伪随机，在 0(包括)和指定值(不包括)之间均匀分布的值。
    - Throws: IllegalArgumentException - 如果 n 不为正数
- nextLong
    - public long nextLong(long least, long bound)
    - Parameters:
        - least - 下限
        - bound - 上限(不包括)
    - Returns: 伪随机，在给定的最小值(包括)和绑定(不包括)之间均匀分布的值。
    - Throws: IllegalArgumentException - 如果最小值大于或等于上限
- nextDouble
    - public double nextDouble(double n)
    - Parameters: n - 要返回的随机数的界限。必须是正数。
    - Returns: 伪随机，在 0(包括)和指定值(不包括)之间均匀分布的值。
    - Throws: IllegalArgumentException - 如果 n 不为正数
- nextDouble
    - public double nextDouble(double least, double bound)
    - Parameters:
        - least - 下限
        - bound - 上限(不包括)
    - Returns: 伪随机，在给定的最小值(包括)和绑定(不包括)之间均匀分布的值。
    - Throws: IllegalArgumentException - 如果最小值大于或等于上限

### 示例：

```java
final int MAX = 100000;
ThreadLocalRandom threadLocalRandom = ThreadLocalRandom.current();
long start = System.nanoTime();
for (int i = 0; i < MAX; i++) {
    threadLocalRandom.nextDouble();
}
long end = System.nanoTime() - start;
System.out.println("use time1 : " + end);
long start2 = System.nanoTime();
for (int i = 0; i < MAX; i++) {
    Math.random();
}
long end2 = System.nanoTime() - start2;
System.out.println("use time2 : " + end2); 
```

## URLClassLoader 类新增 close 方法

它实现了 [Closeable](#try-可以自动关闭资源) 接口，可以及时关闭资源，后续重新加载 class 文件时不会导致资源被占用或者无法释放问

### 官方文档:

>Closes this URLClassLoader, so that it can no longer be used to load new classes or resources that are defined by this loader. Classes and resources defined by any of this loader's parents in the delegation hierarchy are still accessible. Also, any classes or resources that are already loaded, are still accessible.
>
>In the case of jar: and file: URLs, it also closes any files that were opened by it. If another thread is loading a class when the close method is invoked, then the result of that load is undefined.
>
>The method makes a best effort attempt to close all opened files, by catching IOExceptions internally. Unchecked exceptions and errors are not caught. Calling close on an already closed loader has no effect.

关闭此 `URLClassLoader`，以便它不再可用于加载此加载程序定义的新类或资源。由委托层次结构中的任何加载程序父项定义的类和资源仍可访问。此外，仍可访问已加载的任何类或资源。

对于 `jar:` 和 `file:` 的 URL，它还会关闭由它打开的所有文件。如果在调用 `close` 方法时另一个线程正在加载类，则该加载的结果是未定义的。

该方法通过在内部捕获 `IOExceptions`，尽最大努力尝试关闭所有打开的文件。未捕获未经检查的异常和错误。在已经关闭的加载器上调用 `close` 无效。

### 可能抛出的异常

- IOException - if closing any file opened by this class loader resulted in an IOException. Any such exceptions are caught internally. If only one is caught, then it is re-thrown. If more than one exception is caught, then the second and following exceptions are added as suppressed exceptions of the first one caught, which is then re-thrown.
- SecurityException - if a security manager is set, and it denies RuntimePermission("closeClassLoader")

## 套接字直接协议

[套接字直接协议(Sockets Direct Protocol, SDP)](https://www.infoq.cn/article/Java-7-Sockets-Direct-Protocol?useSponsorshipSuggestions=true)。

绕过操作系统的数据拷贝，将数据从一台机器的内存数据通过网络直接传输到另外一台机器的内存中。

>em...实际上我还没看懂，详细内容等我看懂了再补充

## 解决并发下加载 class 可能导致的死锁问题

>这个是 JDK 1.6 的一些新版本就解决了，JDK 7 也做了一些优化。
>
>详细参考[官方文档 Multithreaded Custom Class Loaders in Java SE 7](https://docs.oracle.com/javase/7/docs/technotes/guides/lang/cl-mt.html)

### 示例：

- 类层次结构：
    - A 类继承于 B 类
    - C 类继承于 D 类
- ClassLoader 委派层次结构:
    - 自定义类加载器 CL1:
        1. 直接加载类 A
        2. 将 B 类委托给自定义类加载器 CL2
    - 自定义类加载器 CL2:
        1. 直接加载类 C
        2. 将 D 类委托给自定义类加载器 CL1
- JDK 7 之前: 多线程自定义类加载器在没有非循环委托模型时可能会死锁
    - Thread 1:
        1. 使用 CL1 加载 A 类 (锁定 CL1)
        2. 定义 A 类触发器
        3. 加载 B 类 (尝试锁定 CL2)
    - Thread 2:
        1. 使用 CL2 加载 C 类 (锁住 CL2)
        2. 定义 C 类触发器
        3. 加载 D 类 (尝试锁定 CL1)
        >ClassLoader 类中的同步以前是严厉的，或者在技术方面，不够精细。在整个 ClassLoader 对象上加载同步的类的请求，这使得它容易出现死锁。
- JDK 7: 线程不再处于死锁状态，并且所有类都已成功加载
    - Thread 1:
        1. 使用 CL1 加载 A 类 (锁定 CL1 和 A 类)
        2. 定义 A 类触发器
        3. 加载 B 类 (锁定 CL2 和 B 类)
    - Thread 2:
        1. 使用 CL2 加载 C 类 (锁住 CL2 和 C 类)
        2. 定义 C 类触发器
        3. 加载 D 类 (锁定 CL1 和 D 类)

## 新增 Objects 类

此类包含用于对对象进行操作的 9 静态实用方法。这些实用程序包括 null-safe 或 null-tolerant 方法，用于计算对象的哈希代码，返回对象的字符串以及比较两个对象。

**Objects 继承于 Object**

### Objects.equals

- public static boolean equals(Object a, Object b)
- Parameters:
    - a - 一个对象
    - b - 要与 a 对象进行比较的对象
- Returns: 如果参数彼此相等则为true，否则为false。因此，如果两个参数都为null，则返回true，如果只有一个参数为null，则返回false。否则，通过使用第一个参数的 equals 方法(Object.equals)确定相等性。
- 参见 Object.equals(Object)

### Objects.deepEquals

- public static boolean deepEquals(Object a, Object b)
- Parameters:
    - a - 一个对象
    - b - 要与 a 对象进行深度比较的对象
- Returns: 如果参数彼此非常相等则为 true，否则为 false。两个 null 值深度相等。如果两个参数都是数组，则使用 `Arrays.deepEquals` 中的算法确定相等性。否则，通过使用第一个参数的 equals 方法(Object.equals)确定相等性。
- 参见:
    - Arrays.deepEquals(Object[], Object[])
    - [Objects.equals(Object, Object)](#Objects-equals)
    - Object.equals(Object)

### Objects.hashCode

- public static int hashCode(Object o)
- Parameters: o - 一个对象
- Returns: 非 null 参数的哈希码，参数是 null 则为 0
- 参见:
    - Object.hashCode()

### Objects.hash

- public static int hash(Object... values)
- Parameters: values - 要散列的对象序列
- Returns: 输入对象序列的哈希值
- 参见:
    - Arrays.hashCode(Object[])
    - List.hashCode()

为一系列输入值生成哈希码。生成的哈希代码就好像所有输入值都放在一个数组中一样，并且通过调用 `Arrays.hashCode(Object [])` 对该数组进行哈希处理。

此方法对于在包含多个字段的对象上实现 `Object.hashCode()` 非常有用。例如，如果一个对象有三个字段 x，y 和 z，则可以写：

```java
@Override
public int hashCode() {
    return Objects.hash(x, y, z);
}
```

>**警告：提供单个对象引用时，返回的值不等于该对象引用的哈希码。可以通过调用 `hashCode(Object)` 来计算此值**


### Objects.toString

- public static String toString(Object o)
- Parameters: o - 一个对象
- Returns: 调用 toString 获取非 null 参数的结果，参数为 null 则返回 “null”。
- 参见:
    - Object.toString()
    - String.valueOf(Object)

### Objects.toString

- public static String toString(Object o, String nullDefault)
- Parameters:
    - o - 一个对象
    - nullDefault - 如果第一个参数为 null，则返回此值。即默认值
- Returns: 如果第一个参数不为 null，则在第一个参数上调用 toString，否则返回第二个参数。
- 参见: toString(Object)

### Objects.compare

- public static <T> int compare(T a, T b, Comparator<? super T> c)
- Type Parameters: T - 被比较对象的类型
- Parameters:
    - a - 一个对象
    - b - 要与 a 进行比较的对象
    - c - 用来比较前两个参数的比较器
- Returns: 如果参数相同则为 0，否则为 `c.compare(a，b)`。因此，如果两个参数都为 null ，则返回 0
- 参见:
    - Comparable
    - Comparator

>请注意，如果其中一个参数为 null，则可能会也可能不会抛出 NullPointerException，具体取决于 Comparator 选择具有空值的排序策略(如果有的话)。

### Objects.requireNonNull

- public static <T> T requireNonNull(T obj)
- Type Parameters: T - 被引用的类型
- Parameters: obj - 被检查的对象引用
- Returns: 如果 obj 不为 null 就返回 obj
- Throws: NullPointerException - 如果 obj 为 null

检查指定的对象引用是否为 null。此方法主要用于在方法和构造函数中进行参数验证，如下所示:

```java
public Foo(Bar bar) {
    this.bar = Objects.requireNonNull(bar);
}
```

### Objects.requireNonNull

- public static <T> T requireNonNull(T obj, String message)
- Type Parameters: T - 被引用的类型
- Parameters:
    - obj - 被检查的对象引用
    - message - 在抛出 NullPointerException 时使用的详细消息
- Returns: 如果 obj 不为 null 就返回 obj
- Throws: NullPointerException - 如果 obj 为 null

检查指定的对象引用是否为 null，如果是，则抛出自定义的 NullPointerException。此方法主要用于在具有多个参数的方法和构造函数中进行参数验证，如下所示:

```java
public Foo(Bar bar, Baz baz) {
 this.bar = Objects.requireNonNull(bar, "bar must not be null");
 this.baz = Objects.requireNonNull(baz, "baz must not be null");
}
```

## 增强的文件系统

JDK 7 推出了全新的 NIO2.0 API 以此改变针对文件管理的不便，使得在 `java.nio.file` 包下使用 `Path`、`Paths`、`Files`、`WatchService`、`FileSystem` 等常用类型可以很好的简化开发人员对文件管理的编码工作。

### Path 接口和 Paths 类

Path 接口的某些功能其实可以和 `java.io` 包下的 File 类等价，当然这些功能仅限于**只读**操作。在实际开发过程中，开发人员可以联用 Path 接口和 Paths 类，从而获取文件的一系列上下文信息。

Paths 类仅包含通过转换路径字符串或 URI 返回 Path 的静态方法。

#### Paths.get

将路径字符串或在连接时形成路径字符串的字符串序列转换为 Path。如果 more 没有指定任何元素，那么第一个参数的值就是要转换的路径字符串。如果 more 指定了一个或多个元素，那么每个非空字符串(包括first)都被认为是名称元素的序列(参见 Path 接口)，并被连接起来形成一个路径字符串。有关如何联接字符串的详细信息是提供程序指定的，但通常使用名称分隔符作为分隔符联接字符串。例如，如果名称分隔符是“/”，并调用 `getPath("/foo", "bar", "gus")`，则路径字符串 `"/foo/bar/gus"` 将转换为路径。如果 first 是空字符串， more 不包含任何非空字符串，则返回表示空路径的路径。

该路径是通过调用 `FileSystem.getPath` 方法获得的

注意，虽然这个方法非常方便，但是使用它将意味着假定对默认 `FileSystem`(`FileSystem.getDefault`) 的引用，并限制调用代码的实用程序。因此，不应该在旨在灵活重用的库代码中使用它。一个更灵活的选择是使用现有的 `Path` 实例作为锚，例如:

```java
Path dir = ...;
Path path = dir.resolve("file");
```

- public static Path get(String first, String... more)
- Parameters:
    - first - 路径字符串或路径字符串的初始部分
    - more - 要连接以形成路径字符串的其他字符串
- Returns: 结果 Path
- Throws: InvalidPathException - 如果路径字符串无法转换为 Path
- 参见: FileSystem.getPath(java.lang.String, java.lang.String...)

#### Pahts.get

将给定的 URI 转换为 Path 对象。

此方法在已安装的提供程序上迭代，以定位由给定 URI 的 URI 模式标识的提供程序。URI 方案的比较不考虑大小写。如果找到提供者，则调用其 `getPath` 方法来转换 URI。

对于由 URI 模式 "file" 标识的默认提供程序，给定 URI 有一个非空路径组件，以及未定义的查询和片段组件。是否存在权限组件是取决于平台的。返回的 Path 与默认文件系统(`FileSystem.getDefault`)相关联。

默认提供程序为 File 类提供了类似的往返保证。对于给定的 Path p，它保证

```java
Paths.get(p.toUri()).equals(p.toAbsolutePath())
```

所以只要原始 Path、URI 和新 Path 都是在同一个 Java 虚拟机(可能是不同的调用)中创建的。其他提供者是否提供任何担保是取决于提供者的，因此未指定。

- public static Path get(URI uri)
- Parameters: uri - 要转换的 URI
- Returns: 结果 Path
- Throws:
    - IllegalArgumentException - 如果 uri 参数的前提条件不成立则抛出此异常。URI 的格式是取决于提供者的。
    - FileSystemNotFoundException - 由 URI 标识的文件系统不存在并且无法自动创建，或者未安装由 URI 的方案组件标识的提供程序
    - SecurityException - 如果安装了安全管理器并且它拒绝访问文件系统的未指定权限

#### getNameCount

- int getNameCount()
- Returns: 路径中元素的数量，如果此路径仅表示根组件，则为 0

#### getFileName

此路径作为 Path 对象表示的文件或目录的名称。文件名是目录层次结构中离根目录最远的元素。

- public String getFileName()
- Returns: 表示文件或目录名称的路径，如果此路径具有零个元素，则为 null

#### getRoot

- Path getRoot()
- Returns: 此路径的根组件作为 Path 对象，如果此路径没有根组件，则为 null

#### getParent

The parent of this path object consists of this path's root component, if any, and each element in the path except for the farthest from the root in the directory hierarchy. This method does not access the file system; the path or its parent may not exist. Furthermore, this method does not eliminate special names such as "." and ".." that may be used in some implementations. On UNIX for example, the parent of "/a/b/c" is "/a/b", and the parent of "x/y/." is "x/y". This method may be used with the normalize method, to eliminate redundant names, for cases where shell-like navigation is required.
这个 Path 对象的父对象由这个路径的根组件(如果有的话)和路径中的每个元素(目录层次结构中离根最远的元素除外)组成。此方法不访问文件系统; 路径或其父路径可能不存在。此外，此方法不排除可能在某些实现中使用的特殊名称，如“.”和“..”。例如，在UNIX上，“/a/b/c”的父节点是“/a/b”，“x/y/.”的父节点是“x/y”。此方法可与normalize方法一起使用，以便在需要类shell导航的情况下消除冗余名称。

- Path getParent()
- Returns: 父路径，如果此路径没有父路径，则返回 null


获取当前文件上级关联目录

>其他 Path 接口方法请看 JDK 7 文档，太多了，哈哈哈

### Files 类

联用 Path 接口和 Paths 类可以很方便的访问到目标文件的上下文信息。当然这些操作全都是只读的，如果开发人员想对文件进行其它非只读操作，比如文件的创建、修改、删除等操作，则可以使用 Files 类型进行操作。

Files 类只包含对文件、目录或其他类型的文件进行操作的**静态**方法。在大多数情况下，这里定义的方法将委托给相关的文件系统提供程序来执行文件操作。

Files 类型常用方法如下：

#### Files.createFile

在指定的目标目录创建一个新的空文件，如果该文件已存在则失败。检查文件是否存在以及创建新文件（如果不存在）是针对可能影响目录的所有其他文件系统活动的原子操作。
attrs 参数是可选的文件属性，可在创建文件时以原子方式设置。每个属性都由其名称标识。如果数组中包含多个同名属性，则忽略除最后一次出现的所有属性。

- public static Path createFile(Path path, FileAttribute<?>... attrs) throws IOException
- Parameters:
    - path - 要创建的文件的路径
    - attrs - 创建文件时要自动设置的文件属性的可选列表
- Returns: the file
- Throws:
    - UnsupportedOperationException - if the array contains an attribute that cannot be set atomically when creating the file
    - FileAlreadyExistsException - 如果该名称的文件已存在(可选的特定异常)
    - IOException - 如果发生 I/O 错误或父目录不存在
    - SecurityException - 对于默认提供程序，并且安装了安全管理器，将调用 `checkWrite` 方法以检查对新文件的写访问权。

#### Files.delete

删除指定目标路径的文件或文件夹

使用时可能需要检查文件以确定文件是否是目录。因此，该方法相对于其他文件系统操作可能不是原子的。如果文件是符号链接(快捷方式？)，则删除符号链接本身，而不是原文件。

如果文件是目录，则该目录必须为空。在一些实现中，目录具有用于创建目录时创建的特殊文件或链接的条目。在这样的实现中，当仅存在特殊条目时，目录被认为是空的。此方法可与 `walkFileTree` 方法一起使用，以删除目录和目录中的所有条目，或者删除所需的整个文件树。

在某些操作系统上，可能无法删除正在被 Java 虚拟机或其他程序打开和使用的文件。

- public static void delete(Path path) throws IOException
- Parameters: path - 要删除的文件的路径
- Throws:
    - NoSuchFileException - 如果文件不存在(可选的特定异常)
    - DirectoryNotEmptyException - 如果该文件是一个目录，否则无法删除，因为该目录不为空(可选的特定异常)
    - IOException - 如果发生 I/O 错误
    - SecurityException - 对于默认提供程序，并且安装了安全管理器，将调用 `SecurityManager.checkDelete(String)` 方法以检查对文件的删除访问权限

#### Files.copy

复制操作，总共有三个重载

##### public static long copy(InputStream in, Path target, CopyOption... options) throws IOException

将**输入流中的**所有字节复制到文件。返回时，输入流将位于流的末尾。

默认情况下，如果目标文件已存在或者是符号链接，则复制将失败。如果指定了 `REPLACE_EXISTING` 选项，并且目标文件已存在，则如果它不是非空目录，则替换它。如果目标文件存在且是符号链接，则替换符号链接。在此版本中，`REPLACE_EXISTING` 选项是此方法必须支持的唯一选项。未来版本可能支持其他选项。

如果从输入流读取或写入文件时发生 I/O 错误，则可以在创建目标文件之后以及在读取或写入某些字节之后执行此操作。因此，输入流可能不在流的末尾并且可能处于不一致状态。如果发生 I/O 错误，强烈建议立即关闭输入流。

此方法可能会无限期地阻止从输入流中读取（或写入文件）。在复制期间输入流异步关闭或线程中断的行为是由输入流和文件系统提供程序指定的，因此未指定。

示例: 假设我们想捕获一个网页并将其保存到文件中:

```java
Path path = ...;
URI u = URI.create("http://java.sun.com/");
try (InputStream in = u.toURL().openStream()) {
    Files.copy(in, path);
}
```

- Parameters:
    - in - 要读取的输入流
    - target - 文件的路径(拷贝到那里)
    - options - 指定副本应如何完成的选项
- Returns: 读取或写入的字节数
- Throws:
    - IOException - 如果读取或写入时发生 I/O 错误
    - FileAlreadyExistsException - 如果目标文件存在但由于未指定 `REPLACE_EXISTING` 选项而无法替换(可选的特定异常)
    - DirectoryNotEmptyException - 指定了 `REPLACE_EXISTING` 选项，但无法替换该文件，因为它是非空目录(可选的特定异常) *
    - UnsupportedOperationException - 如果选项包含不受支持的复制选项
    - SecurityException - 对于默认提供程序，并且安装了安全管理器，将调用 `checkWrite` 方法以检查对该文件的写访问权。如果指定了 `REPLACE_EXISTING` 选项，则会调用安全管理器的 `checkDelete` 方法来检查是否可以删除现有文件。

##### public static long copy(Path source, OutputStream out) throws IOException

将**文件中的**所有字节复制到输出流。

如果从文件读取或写入输出流时发生 I/O 错误，则可能在读取或写入某些字节后执行此操作。因此，输出流可能处于不一致状态。如果发生I / O错误，强烈建议立即关闭输出流。

此方法可能会无限期地阻止写入输出流(或从文件中读取)。在复制期间输出流异步关闭或线程中断的行为是由输出流和文件系统提供程序指定的，因此未指定。

请注意，如果给定的输出流是 `Flushable`，则在此方法完成后可能需要调用其 `flush`方法，以便刷新任何缓冲的输出。

- Parameters:
    - source - 原文件的路径
    - out - 要写入的输出流
- Returns: 读取或写入的字节数
- Throws:
    - IOException - 如果读取或写入时发生 I/O 错误
    - SecurityException - 对于默认提供程序，并且安装了安全管理器，将调用 `checkRead` 方法以检查对该文件的读访问权。

##### public static Path copy(Path source, Path target, CopyOption... options) throws IOException

将文件复制到目标文件。

此方法使用 `options` 参数将文件复制到目标文件，该参数指定如何执行复制。默认情况下，如果目标文件已存在或者是符号链接，则复制将失败，除非源和目标是同一文件，在这种情况下，方法完成但不是复制文件。

不需要将文件属性复制到目标文件。 如果支持符号链接，并且文件是符号链接，则复制链接的原始目标。如果文件是目录，则它在目标位置创建一个空目录（不复制目录中的条目）。此方法可与 `walkFileTree` 方法一起使用，以复制目录和目录中的所有条目，或者复制所需的整个文件树。

options 参数可以包括以下任何一项：

|      Option      | Description                                                                                                                                                                              |
|:----------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| REPLACE_EXISTING | 如果目标文件存在，则如果目标文件不是非空目录，则替换目标文件。如果目标文件存在且是符号链接，则替换符号链接本身而不是链接的目标。                                                                         |
| COPY_ATTRIBUTES  | 尝试将与此文件关联的文件属性复制到目标文件。复制的确切文件属性是与平台和文件系统相关的，因此未指定。最小化，如果源文件存储和目标文件存储都支持，则将最后修改时间复制到目标文件。复制文件时间戳可能会导致精度损失。 |
|  NOFOLLOW_LINKS  | 不遵循符号链接。如果文件是符号链接，则复制符号链接本身，而不是链接的目标。如果可以将文件属性复制到新链接，则它是特定于实现的。换句话说，复制符号链接时可以忽略 `COPY_ATTRIBUTES` 选项。                       |

此接口的实现可以支持其他特定于实现的选项。

复制文件不是原子操作。如果抛出 IOException，则可能是目标文件不完整或者某些文件属性尚未从源文件复制。如果指定了 `REPLACE_EXISTING` 选项且目标文件存在，则替换目标文件。对于其他文件系统活动，检查文件是否存在以及创建新文件可能不是原子的。

示例：假设我们要将文件复制到目录中，并为其提供与源文件相同的文件名:

```java
Path source = ...;
Path newdir = ...;
Files.copy(source, newdir.resolve(source.getFileName());
```

- Parameters:
    - source - 要复制的文件的路径
    - target - 目标文件的路径(可能与源路径的不同提供者相关联)
    - options - 指定副本应如何完成的选项
- Returns: 目标文件的路径
- Throws:
    - UnsupportedOperationException - 如果数组包含不受支持的副本选项
    - FileAlreadyExistsException - 如果目标文件存在但由于未指定 `REPLACE_EXISTING` 选项而无法替换(可选的特定异常)
    - DirectoryNotEmptyException - 指定了 `REPLACE_EXISTING` 选项，但无法替换该文件，因为它是非空目录(可选的特定异常)
    - IOException - 如果发生 I/O 错误
    - SecurityException - 对于默认提供程序，并且安装了安全管理器，调用 `checkRead` 方法以检查对源文件的读访问权，调用 `checkWrite` 以检查对目标文件的写访问权。如果复制了符号链接，则调用安全管理器以检查 `java.nio.file.LinkPermission`（用于链接创建操作的权限类。）。

#### Files.move

将文件移动或重命名为目标文件。

默认情况下，此方法尝试将文件移动到目标文件，如果目标文件存在则失败，除非源文件和目标是同一文件，在这种情况下此方法实际上是无效的。如果文件是符号链接，则移动符号链接本身而不是原文件。可以调用此方法来移动空目录。在一些实现中，目录具有用于创建目录时创建的特殊文件或链接的条目。在这样的实现中，当仅存在特殊条目时，目录被认为是空的。

当调用移动非空目录时，如果不需要移动目录中的条目，则移动目录。例如，重命名同一 FileStore 上的目录通常不需要移动目录中的条目。

若移动目录时需要移动其条目，则此方法失败(通过抛出 IOException)。移动文件树可能涉及复制而不是移动目录，这可以使用 [`Files.copy`](#Files-copy) 方法与 `Files.walkFileTree` 实用程序方法一起完成。

options 参数可以包括以下任何一项：

|      Option      | Description                                                                                                                                                                                                                                                                                                          |
|:----------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| REPLACE_EXISTING | 如果目标文件存在，则如果目标文件不是非空目录，则替换目标文件。 如果目标文件存在且是符号链接，则替换符号链接本身而不是原文件。                                                                                                                                                                                                        |
|   ATOMIC_MOVE    | 移动作为原子文件系统操作执行，并忽略所有其他选项。如果目标文件已存在，则它成功与否取决于是否已替换已存在的文件或由于该方法抛出 IOException 而失败。如果移动无法作为原子文件系统操作执行，则抛出 AtomicMoveNotSupportedException。例如，当目标位置位于不同的 FileStore 上并且需要复制文件，或者目标位置与该对象的不同提供者相关联时，可能会出现这种情况。 |

此接口的实现可以支持其他特定于实现的选项。

如果移动要求复制文件，则将最后修改时间复制到新文件。该实现还会尝试复制其他文件属性，但如果无法复制文件属性，则并不会失败。当移动作为非原子操作执行并且抛出 IOException 时，则文件的状态不确定。原始文件和目标文件都可能存在，目标文件可能不完整或者某些文件属性可能未从原始文件中复制。

示例：假设我们要将文件重命名为 “newname”，将文件保留在同一目录中:

```java
Path source = ...;
Files.move(source, source.resolveSibling("newname"));
```

或者，假设我们要将文件移动到新目录，保留相同的文件名，并替换目录中该名称的任何现有文件:

```java
Path source = ...;
Path newdir = ...;
Files.move(source, newdir.resolve(source.getFileName()), REPLACE_EXISTING);
```

- public static Path move(Path source, Path target, CopyOption... options) throws IOException
- Parameters:
    - source - 要移动的文件的路径
    - target - 目标文件的路径(可能与源路径的不同提供者相关联)
    - options - 指定应如何进行移动的选项
- Returns: 目标文件的路径
- Throws:
    - UnsupportedOperationException - 如果数组包含不受支持的副本选项
    - FileAlreadyExistsException - 如果目标文件存在但由于未指定 `REPLACE_EXISTING` 选项而无法替换(可选的特定异常)
    - DirectoryNotEmptyException - 指定了 `REPLACE_EXISTING` 选项，但无法替换该文件，因为它是非空目录(可选的特定异常)
    - AtomicMoveNotSupportedException - 如果 `options` 数组包含 `ATOMIC_MOVE` 选项但该文件不能作为原子文件系统操作移动。
    - IOException - 如果发生 I/O 错误
    - SecurityException - 对于默认提供程序，并且安装了安全管理器，将调用 `checkWrite` 方法以检查对源文件和目标文件的写访问权。

>使用 Files 类型来管理文件，相对于传统的 I/O 方式来说更加方便和简单。因为具体的操作实现将全部移交给 NIO 2.0 API，开发人员则无需关注。

<!--### WatchService

Java7 还为开发人员提供了一套全新的文件系统功能，那就是文件监测。在此或许有很多朋友并不知晓文件监测有何意义及目，那么请大家回想下调试成热发布功能后的Web容器。当项目迭代后并重新部署时，开发人员无需对其进行手动重启，因为Web容器一旦监测到文件发生改变后，便会自动去适应这些“变化”并重新进行内部装载。Web容器的热发布功能同样也是基于文件监测功能，所以不得不承认，文件监测功能的出现对于Java文件系统来说是具有重大意义的。
文件监测是基于事件驱动的，事件触发是作为监测的先决条件。开发人员可以使用java.nio.file包下的StandardWatchEventKinds类型提供的3种字面常量来定义监测事件类型，值得注意的是监测事件需要和WatchService实例一起进行注册。
StandardWatchEventKinds类型提供的监测事件：

ENTRY_CREATE：文件或文件夹新建事件；
ENTRY_DELETE：文件或文件夹删除事件；
ENTRY_MODIFY：文件或文件夹粘贴事件；

使用WatchService类实现文件监控完整示例：
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;

/**
* 文件监控系统
* @author huangjiawei
*/
public class WatchViewTest {
  public static void testWatch() {
      /* 监控目标路径 */
      Path path = Paths.get("C:\\Users\\huangjiawei\\Desktop");
      try {
          /* 创建文件监控对象. */
          WatchService watchService = FileSystems.getDefault().newWatchService();

          /* 注册文件监控的所有事件类型. */
          path.register(watchService, StandardWatchEventKinds.ENTRY_CREATE, StandardWatchEventKinds.ENTRY_DELETE,
                  StandardWatchEventKinds.ENTRY_MODIFY);

          /* 循环监测文件. */
          while (true) {
              WatchKey watchKey = watchService.take();

              /* 迭代触发事件的所有文件 */
              for (WatchEvent<?> event : watchKey.pollEvents()) {
                  System.out.println(event.context().toString() + " 事件类型：" + event.kind());
              }

              if (!watchKey.reset()) {
                  return;
              }
          }
      } catch (Exception e) {
          e.printStackTrace();
      }
  }
  public static void main(String[] args) {
      testWatch();
  }
}
复制代码通过上述程序示例我们可以看出，使用WatchService接口进行文件监控非常简单和方便。首先我们需要定义好目标监控路径，然后调用FileSystems类型的newWatchService()方法创建WatchService对象。接下来我们还需使用Path接口的register()方法注册WatchService实例及监控事件。当这些基础作业层全部准备好后，我们再编写外围实时监测循环。最后迭代WatchKey来获取所有触发监控事件的文件即可。
现在我终于知道，spring boot中那个所谓的dev-tools热更新的基本原理啦！原来JDK都有提供这样的API。-->

