---
title: 类比 Java 学 Python(1)
date: 2023-03-14 22:22:22
img: "/images/JavaVsPython.png"
top: 10
cover: false
coverImg: "/images/JavaVsPython.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: Python
tags:
- Python
keywords:
- Java
- Python
- DataStructure
- BasicType
summary: 最近想系统性的学习一下 Python 编程, 于是就想到了类比 Java 学 Python, 这样既能学到 Python, 又能巩固 Java 的基础知识。本文是这个系列的第一篇, 主要介绍了 Python 的基本数据类型和 Java 的基本数据类型的对应关系。
---

# Python 基本数据类型

## 基本类型

我们知道 Java 的基本数据类型有 8 种, 分别是 byte、short、int、long、float、double、char 和 boolean

Python 的基本数据类型也有 8 种, 分别是 int、float、bool、str、list、tuple、set 和 dict

Python 中的 int、float、bool、str、list、tuple、set 和 dict 分别对应 Java 的 int、float、boolean、char、ArrayList、数组、HashSet 和 HashMap

其中, 整数、浮点数和布尔值的使用方式与 Java 类似, 而字符串、列表、元组、集合和字典的使用方式也与 Java 类似, 但是有一些细微的差别

### 整数(int)

整数类型表示整数值, 与 Java 类似。Python 中的整数类型不需要指定大小, 它可以根据所需自动调整大小。例如: 

```python
a = 1
b = 1000000
c = -500
```

### 浮点数(float)

浮点数类型表示小数值, 与 Java 类似。Python 中的浮点数类型同样可以根据所需自动调整大小。例如: 

```python
x = 3.14
y = -0.001
z = 1.23e-4  # 科学计数法表示的浮点数, 相当于 0.000123
```

### 布尔值(bool)

布尔类型表示真或假两种状态。与 Java 类似, Python 中的布尔类型只有两个值: True 和 False。例如: 

```python
is_sunny = True
is_raining = False
```

### 字符串(str)

字符串类型表示一串字符, 可以用单引号、双引号或三引号表示。与 Java 不同的是, Python 中的字符串是不可变类型, 也就是说, 一旦创建就不能修改。例如: 

```python
s1 = 'hello'
s2 = "world"
s3 = '''Hello, 
world!'''
```

和 Java 中的字符串类似, 都是一种不可变序列, 表示由一系列 Unicode 字符组成的字符序列, 用来存储文本类型的数据。

Python 中的字符串底层实现是通过一个字符数组来实现的, 也就是说, Python 中的字符串实际上是一个字符数组对象。当需要修改字符串时, Python 会创建一个新的字符串对象, 而不是在原有的字符串对象上直接修改。

Python 中的字符串采用了引用计数(reference counting)和垃圾回收(garbage collection)的机制来管理内存。每个字符串对象都有一个引用计数器, 当一个对象被引用时, 它的引用计数会加 1, 当一个对象的引用被删除时, 它的引用计数会减 1, 当引用计数为 0 时, 对象被认为是不再被引用, Python 的垃圾回收机制会回收该对象的内存空间。

Java 中的字符串是一个对象类型, 它底层实现是通过一个字符数组和一个偏移量和长度来表示的。当需要修改字符串时, Java 会创建一个新的字符串对象, 而不是在原有的字符串对象上直接修改。Java 中的字符串常量池(String Pool)可以重用相同的字符串对象, 避免了创建大量相同字符串对象的开销。

另一个不同之处在于, Python 中的字符串可以使用单引号、双引号或三引号表示, 而 Java 中的字符串只能使用双引号表示。

### 列表(list)

列表是一种有序的可变序列, 可以存储任意类型的元素。列表使用方括号 [] 来表示, 各个元素之间用逗号隔开。

```python
a = [1, 2, 3]
b = ['hello', 'world']
c = [1, 'hello', 3.14]
lst = [1, 2, 'hello', True, [4, 5]]
```

和 Java 中的 ArrayList 类似, 都是一种有序的可变序列。不同之处在于, Python 中的列表可以存储任意类型的元素, 而 Java 中的 ArrayList 只能存储对象类型。

此外, Python 中的列表使用方括号 [] 表示, 而 Java 中的 ArrayList 需要通过 `import java.util.ArrayList;` 来导入, 使用时需要先创建对象再添加元素。

它的底层实现是基于动态数组和可扩展数组的, Python 中的列表可以动态地增加或缩减大小, 这是因为列表中的元素实际上是存储在一个动态分配的数组中的。

在 Python 中, 列表的底层实现使用了一个数组缓冲区(array buffer), 用于存储列表中的元素。当列表的大小增加时, Python 会为数组缓冲区分配更大的内存空间, 将现有的元素复制到新的缓冲区中, 然后释放旧的缓冲区。这种方法可以有效地减少内存分配和复制的次数, 提高程序的效率。

与 Java 语言的 ArrayList 不同之处在于, Java 中的 ArrayList 使用了连续的存储空间(连续的内存地址), 并且在容量不足时需要重新分配内存空间, 将现有的元素复制到新的内存空间中, 这样就可能导致内存分配和复制的次数增加, 影响程序的性能。

因此, 在处理大量数据时, Python 中的列表可能会更加高效。

但是, 由于 Python 中的列表可以存储任意类型的元素, 因此在处理相同类型的元素时, Java 中的 ArrayList 可能会更加高效。

### 元组(tuple)

元组是一种有序的不可变序列, 也可以存储任意类型的元素。元组使用圆括号 () 来表示, 各个元素之间用逗号隔开。

```python
a = (1, 2, 3)
b = ('hello', 'world')
c = (1, 'hello', 3.14)
tup = (1, 2, 'hello', True, (4, 5))
```

和 Java 中的数组有些相似, 都是一种有序的不可变序列。但元组的长度和元素内容不能被修改。元组通常用于存储不同类型的数据, 例如多个返回值的函数结果, 或者将多个元素作为一个整体进行传递。

元组底层实现是基于数组的, 与列表类似, 但是由于元组是不可变的, 因此在创建时会分配一个固定的内存空间来存储元素, 这个空间在后续的使用中不会被改变。因为元组是不可变的, 所以它们可以被用作字典的键, 而列表则不能。

与 Java 语言的数组不同之处在于, Python 中的元组可以存储任意类型的元素, 而 Java 中的数组虽然也是固定大小的, 但它们是可变的, 可以通过下标来修改元素内容。

此外, Python 中的元组使用圆括号 () 表示, 而 Java 中的数组需要使用方括号 [] 来声明。

### 集合(set)

和 Java 中的 HashSet 类似, 都是一种无序的可变集合, 不允许出现重复元素。集合使用花括号 {} 或 set() 函数来创建, 各个元素之间用逗号隔开。

```python
s1 = {1, 2, 3, 4, 5}
s2 = set([3, 4, 5, 6, 7])
s3 = set('hello')
```

Python 中的集合底层实现是基于哈希表的, 它可以实现常数时间(O(1))的插入、删除和查找操作。

在 Python 中, 哈希表是通过一个数组来实现的, 每个数组元素都是一个指向链表的指针, 每个链表节点存储一个键值对。当需要插入一个元素时, Python 会根据元素的哈希值(hash value)来计算出在数组中的位置, 然后将元素插入到对应的链表中。当需要查找一个元素时, Python 也会根据元素的哈希值来计算出在数组中的位置, 然后遍历对应的链表查找元素。当需要删除一个元素时, Python 会根据元素的哈希值来计算出在数组中的位置, 然后在对应的链表中删除元素。

与 Java 语言的 HashSet 不同之处在于, Java 中的 HashSet 也是基于哈希表实现的, 但是它使用的是数组加链表或红黑树的方式来实现, 而 Python 中的集合只使用了链表, 这也意味着 Python 中的集合在存储大量元素时, 可能会受到哈希冲突(hash collision)的影响, 导致链表长度增加, 进而影响程序的性能。另外, Python 中的集合可以存储任意类型的元素, 而 Java 中的 HashSet 只能存储对象类型的元素。

此外, Python 中的集合使用花括号 {} 或 set() 函数来创建, 而 Java 中的 HashSet 需要通过 `import java.util.HashSet;` 来导入, 使用时需要先创建对象再添加元素。

### 字典(dict)

和 Java 中的 HashMap 类似, 都是一种无序的键值对(key-value)集合, 每个键都必须是唯一的, 键和值可以是任意类型的元素。字典使用花括号 {} 来表示, 键和值之间用冒号 : 隔开, 各个键值对之间用逗号隔开。例如: 

```python
dic = {'name': 'Alice', 'age': 20, 'gender': 'female'}
```

字典的底层实现是通过哈希表(hash table)来实现的。哈希表是一种基于数组实现的数据结构, 它通过将键映射到数组中的一个位置来实现快速的键值查找。Python 中的字典底层实现中使用了一些哈希表优化技术, 例如使用开放地址法(open addressing)解决哈希冲突、缩小哈希表的负载因子(load factor)等等。

与 Python 不同, Java 中的字典(Map)是一个接口类型, 它有多种实现方式, 例如 HashMap、TreeMap、LinkedHashMap 等等。其中, HashMap 是最常用的一种实现方式, 它也是基于哈希表实现的。Java 中的哈希表同样使用了开放地址法解决哈希冲突, 并且也有一些优化技术, 例如链式哈希表(chained hash table)和重新哈希(rehashing)等等。

Python 中的字典可以存储任意类型的键和值, 而 Java 中的 HashMap 只能存储对象类型的键和值。

此外, Python 中的字典使用花括号 {} 表示, 而 Java 中的 HashMap 需要通过 `import java.util.HashMap;` 来导入, 使用时需要先创建对象再添加键值对。

