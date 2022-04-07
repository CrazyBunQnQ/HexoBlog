---
title: Java 死锁原因及排查
date: 2021-08-05 22:22:22
img: "images/JavaAnnotation.jpg"
cover: false
coverImg: "images/JavaAnnotation.jpg"
toc: false
mathjax: false
categories: Java
tags:
- Java 基础
keywords: 死锁
summary: 在高并发多线程的应用里，很可能就会遇到死锁问题，来看看死锁的原因，遇到了要怎么解决呢？
---

在高并发多线程的应用里，很可能就会遇到死锁问题，来看看死锁的原因，遇到了要怎么解决呢？

## 死锁的原因

Java 发生死锁的根本原因是: 在申请锁时发生了交叉闭环申请

即线程在获得了锁 A 并且没有释放的情况下又去申请锁 B, 这时另一个线程已经获得了锁 B

在释放锁 B 之前又要先获得锁 A, 因此闭环发生, 陷入死锁循环, 这就是死锁了

### 示例 1

```java
public class DeadLockA extends Thread {
    @Override
    public void run() {
        try{
            System.out.println("LockA 开始运行");
            while(true){
                synchronized(Client.obj1){
                    System.out.println("LockA 锁住 obj1");
                    // 给 LockB 一个锁住 obj2 的机会...
                    Thread.sleep(100);
                    System.out.println("LockA 尝试锁住 obj2...");
                    synchronized(Client.obj2){
                        System.out.println("LockA 锁住 obj2");
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}

public class DeadLockB extends Thread {
    @Override
    public void run() {
        try{
            System.out.println("LockB 开始运行");
            while(true){
                synchronized(Client.obj2){
                    System.out.println("LockB 锁住 obj2");
                    System.out.println("LockB 尝试锁住 obj1...");
                    synchronized(Client.obj1){
                        System.out.println("LockB 锁住 obj1");
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}

public class Client {
    public static final String obj1 = "obj1";
    public static final String obj2 = "obj2";

    public static void main(String[] ars) {
        new DeadLockA().start();
        new DeadLockB().start();
    }
}
```

#### 运行结果

```log
LockA 开始运行
LockA 锁住 obj1
LockB 开始运行
LockB 锁住 obj2
LockB 尝试锁住 obj1...
LockA 尝试锁住 obj2...
```

两个线程最后都在等待对方释放锁, 最终进入了死锁状态

### 示例 2

```java
public class TestClass {

    public synchronized void method(TestClass clazz) {
        System.out.println("TestClass method in");
        clazz.method2();
        System.out.println("TestClass method out");
    }

    public synchronized void method2() {
        System.out.println("TestClass method2");
    }
}

public class TestLock extends Thread {
    private TestClass class1;
    private TestClass class2;

    public TestLock(TestClass class1, TestClass class2) {
        this.class1 = class1;
        this.class2 = class2;
    }

    @Override
    public void run() {
        class1.method(class2);
    }
}

public class Client {
    public static void main(String[] ars) {
        TestClass classA = new TestClass();
        TestClass classB = new TestClass();
        new TestLock(classA, classB).start();
        new TestLock(classB, classA).start();
    }
}
```

#### 运行结果

```log
TestClass method in
TestClass method in
```

结果显示进入两次方法, 但是并没有走完, 因为死锁了

一旦出现死锁, 整个程序既不会发生任何错误, 也不会给出任何提示, 只是所有线程处于阻塞状态, 无法继续

## 如何避免死锁

Java 虚拟机没有提供检测, 也没有采取任何措施来处理死锁的情况, 所以多线程编程中, 应该手动采取措施避免死锁

我们知道了死锁如何产生的, 那么就知道该如何去预防

如果一个线程每次只能获取一个锁, 那么就不会出现由于嵌套持有锁顺序导致的死锁

### 正确的顺序获得锁

上面的例子出现死锁的根本原因就是获取所的顺序是乱序的, 超乎我们控制的

上面例子最理想的情况就是把业务逻辑抽离出来, 把获取锁的代码放在一个公共的方法里面, 让这两个线程获取锁都是从我的公共的方法里面获取

当 `Thread1` 线程进入公共方法时, 获取了 `A` 锁, 另外 `Thread2` 又进来了, 但是 `A` 锁已经被 `Thread1` 线程获取了, 所以只能阻塞等待

`Thread1` 接着又获取锁 `B`, `Thread2` 线程就不能再获取不到了锁 `A`, 更别说再去获取锁 `B` 了，这样就有一定的顺序了

只有当 `Thread1` 释放了所有锁, 线程 `B` 才能获取