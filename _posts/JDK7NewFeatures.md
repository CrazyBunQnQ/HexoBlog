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

### 改进编译警告和错误

示例 1:

```java
List l = new ArrayList<Number>();
List<String> ls = l;// 未经检查的警告
l.add(0, new Integer(42));// 另一个未经检查的警告
String s = ls.get(0);// 抛出 ClassCastException 异常
```

示例 2:

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

### ThreadLocalRandom

ThreadLocalRandom 为并发下随机数生成类，保证并发下的随机数生成的线程安全

>实际上就是使用 threadlocal

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

#### ThreadLocalRandom 类官方文档

ThreadLocalRandom 继承自 Random

>A random number generator isolated to the current thread. Like the global Random generator used by the Math class, a ThreadLocalRandom is initialized with an internally generated seed that may not otherwise be modified. When applicable, use of ThreadLocalRandom rather than shared Random objects in concurrent programs will typically encounter much less overhead and contention. Use of ThreadLocalRandom is particularly appropriate when multiple tasks (for example, each a ForkJoinTask) use random numbers in parallel in thread pools.
>
>Usages of this class should typically be of the form: ThreadLocalRandom.current().nextX(...) (where X is Int, Long, etc). When all usages are of this form, it is never possible to accidently share a ThreadLocalRandom across multiple threads.
>
>This class also provides additional commonly used bounded random generation methods.

随机数生成器被隔离到当前线程。与 Math 类使用的全局 Random 生成器一样，ThreadLocalRandom 使用内部生成的种子进行初始化，否则可能无法修改。适用时，在并发程序中使用 ThreadLocalRandom 而不是共享 Random 对象通常会遇到更少的开销和争用。当多个任务（例如，每个 ForkJoinTask）在线程池中并行使用随机数时，使用 ThreadLocalRandom 是特别合适的。

此类的用法通常应为以下形式: `ThreadLocalRandom.current().nextX(...)`（其中 X 为 Int, Long 等）。当所有用法都是这种形式时，永远不可能在多个线程中意外地共享 ThreadLocalRandom。

该类还提供了其他常用的有界随机生成方法。

#### 方法

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

