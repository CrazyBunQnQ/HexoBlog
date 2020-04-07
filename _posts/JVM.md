---
title: JVM 工作原理
date: 2017-07-21 11:32
categories: Java
tags: 
- JVM
- GC
- 待完善
---

Java 虚拟机（Java virtual machine，JVM）是运行 Java 程序必不可少的机制。JVM 实现了 Java 语言最重要的特征：即平台无关性。

因为编译后的 Java 程序指令并不直接在硬件系统的 CPU 上执行，而是由 JVM 执行。JVM 屏蔽了与具体平台相关的信息，使 Java 语言编译程序只需要生成在 JVM 上运行的目标字节码 `.class` 文件，就可以在多种平台上不加修改地运行。Java 虚拟机在执行字节码时，把字节码解释成具体平台上的机器指令执行。因此实现了 Java 平台无关性。它是 Java 程序能在多平台间进行无缝移植的可靠保证，同时也是 Java 程序的安全检验引擎（还进行安全检查）。

<!--more-->

JVM 是编译后的 Java 程序（`.class` 文件）和硬件系统之间的接口。
>Java 程序通过 javac 进行编译，javac 是 JDK 中的 Java 语言编译器。
>该工具可以将后缀为 `.java` 的源文件编译为后缀名为 `.class` 的可以运行于 Java 虚拟机的字节码文件。

## JVM 体系架构
![JVM 体系架构图](http://wx1.sinaimg.cn/mw690/a6e9cb00ly1fhrcybxrsbj20hc0b8tdf.jpg)
JVM = 类加载器(Classloader) + 执行引擎(Execution Engine) + 运行时数据区域(Runtime Data Area)
>Classloader 把硬盘上的 `.class` 文件加载到 JVM 中的 Runtime Data Area，但是它不负责这个类文件能否执行，而是由 Execution Engine 来负责的。

### ClassLoader（类加载器）
Classloader 用来装载 `.class` 文件，它由两种装载 `.class` 的方式：
1. 隐式：运行过程中，碰到 new 方式生成对象时，隐式调用 Classloader 到 JVM。
2. 显式：通过 `class.forname()` 动态加载。

#### Parent Delegation Model (双亲委派模型)
类的加载过程采用双亲委托机制，这种机制能更好的保证 Java 平台的安全。
该模型要求除了顶层的 Bootstrap Class Loader 启动类加载器外，其余的类加载器都应当有自己的**父类加载器**。子类加载器和父类加载器**不是以继承 (Inheritance) 的关系**来实现的，而是通过**组合 (Composition) 关系**来复用父类加载器的代码。

每个类加载器都有自己的命名空间，该命名空间由该加载器及所有父类加载器所加载的类组成：

- 在同一个命名空间中，不会出现类的完整名字（包括类的包名）相同的两个类；
- 在不同的命名空间中，有可能会出现类的完整名字（包括类的包名）相同的两个类。

**双亲委派模型的工作过程：**

1. 当前 ClassLoaer 首先从自己已经加载的类中查询是否此类已经加载，如果已经加载则直接返回原来已经加载的类。
>每个类加载器都有自己的加载缓存，当一个类被加载了以后就会放入缓存，等下次加载的时候就可以直接返回了。

2. 当前 ClassLoader 的缓存中没有找到被加载的类时，委托父类加载器去加载，并将其放入自己的缓存中，以便下次有加载请求的时候直接返回。

**使用这种模型来组织类加载器之间的关系的好处：**
主要为乐**安全性**，避免用户自己编写的类动态替换 Java 的一些核心类，比如 String，同时也避免了**重复加载**，因为 JVM 中区分不同类，不仅仅是根据类名，相同的 class 文件被不同的 ClassLoader 加载就是不同的两个类，如果互相转型的话会抛出 `java.lang.ClassCaseException`。

类加载器 ClassLoader 是具有层次结构的，也就是父子关系。其中 Bootstarp 是所有类加载器的父亲。如图：
![ClassLoader 层次结构](http://wx2.sinaimg.cn/mw690/a6e9cb00ly1fhrhg8u51gj20f50cxdgv.jpg)

- **Bootstrap Class Loader：父类**
当运行 Java 虚拟机时，这个类加载器被创建，它负责加载虚拟机的核心类库，如 java.lang.* 等。例如 java.lang.Object 就是由 Bootstrap Class Loader 加载的。

	>Bootstrap Class Loader 不是用 Java 语言写的，而是用 C/C++ 写的。
- **Extension Class Loader：**
这个加载器加载除了基本 API 之外的一些拓展类。
- **AppClass Loader：**
加载应用程序和程序员自定义的类。

除了以上虚拟机自带的加载器以外，用户还可以定制自己的类加载器（**User-defined Class Loader**)。Java 提供了抽象类 java.lang.ClassLoader，所有用户自定义的类加载器应该继承 ClassLoader 类。

这是 JVM 分工自治生态系统的一个很好的体现。

### Execution Engine（执行引擎）
执行引擎就是用于执行字节码，或者执行本地方法

### Runtime Data Area（运行时数据区域）
JVM 运行时数据区（JVM Runtime Data Area）指在运行期间，其对 JVM 内存空间的划分和分配。JVM 在运行时将数据划分为了 6 个区域来存储。

程序员写的所有程序都被加载到 **Runtime Data Area** 中，不同类别放在 Heap Memory，Java Stack，Native Method Stack，PC Register 和 Method Area 中。

**下面对各个部分的功能和存储内容进行描述：**
![JVM Memory Structure](http://wx2.sinaimg.cn/mw690/a6e9cb00ly1fhrhvgb5kpj20ha0de760.jpg)

1. **PC Register (PC 程序计数器)：**
一块较小的内存空间，可以看作是当前**线程**所执行字节码的行号指示器，存储每个线程下一步将执行的 JVM 指令，如该方法为 native 的，则 PC 寄存器中不存储任何信息。
Java 的多线程机制离不开程序计数器，每个线程都有一个自己的 PC，以便完成不同线程上下文环境的切换。
2. **JVM Stack (Java 虚拟机栈)：**
与 PC 一样，Java 虚拟机栈也是线程私有的。
每一个 JVM 线程都有自己的 Java 虚拟机栈，这个栈与线程同时创建，它的生命周期与线程相同。
虚拟机栈描述的是 **Java 方法执行的内存模型：**
	- 每个方法被执行的时候都会同时创建一个**栈帧（Stack Frame）**用于存储局部变量表、操作数栈、动态链接和方法出口等信息。
	- **每一个方法被调用直至执行完成的过程就对应着一个栈帧在虚拟机栈中从入栈到出栈的过程。**
3. **Native Method Stack (本地方法栈)：**
与虚拟机栈的作用相似，虚拟机栈为虚拟机执行 Java 方法服务，而本地方法栈则为虚拟机使用道的本地方法服务。
4. **Heap Memory (Java 堆)：**
Java 堆是被所有线程共享的一块存储区域，在虚拟机启动的时候创建，它是 JVM 用来存储对象实例以及数组值的区域，可以认为 Java 中所有通过 new 创建的对象其内存都在此分配。
Java 堆在 JVM 启动的时候就被创建，堆中存储了各种对象，这些对象被自动管理内存系统所管理。这些对象无需、也无法显式地被销毁。
JVM 将 Heap 分为两块：New Generation 和 Old Generation

	>自动管理内存系统所管理：Automatic Storage Management System 也就是常说的 Garbage Collector（垃圾回收器）
5. **Method Area (方法去)：**
6. 运行时常量池：