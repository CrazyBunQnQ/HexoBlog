---
title: 初识 Python 3
date: 2017-11-04 22:22:22
categories: Python
tags: 
- 基础
---

为了了解和学习机器学习，我将魔掌！伸向了 Python 3...
虽然我编程还菜的抠脚，但也算是有点编程基础了，所以就直接去了解 Python 3 语法基础啦~

<!--more-->

## 编码

Python 3 默认以 <font color="red">**UTF-8**</font> 编码

也可以在源码中指定其他编码：

```python
# -*- coding: UTF-8 -*-
```

>由于中文注释也会报错，所以建议在每个文件中都指明编码方式为 UTF-8

## 标识符

- 第一个字符必须是字母或'_'
- 标识符的其他部分可以是字母、数字和'_'
- 标识符对大小写敏感

## 保留字 & 注释 & 输出

- 我们不能把保留字用作任何标识符名称。
- 单行和多行注释都用 '#'
- print 默认输出时换行的，如果要**实现不换行需要在变量末尾加上 end=""**：

```python
# 这是注释
# 多行注释也用 '#'
import keyword # 这也是注释
a="以下是" # 赋值
b="Python " # 赋值
c="3"
d="保留字"
print (a) # 换行输出
print (b,end="") # 不换行输出
print (c,end=" ") # 不换行输出
print (d)
print (keyword.kwlist)
```

可以看到输出结果为：

```python
以下是 Pyhton 3 保留字：
['and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'exec', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'not', 'or', 'pass', 'print', 'raise', 'return', 'try', 'while', 'with', 'yield']
```

## 变量类型

Python 3 不用显式指明变量类型，但是不同的数据类型是不能合并的：

```python
num = 3;
string = '2'

print (num + string)
```

上面的代码运行的时候就会报错，但是可以通过一些方法进行类型转换：

```python
num = 3;
string = '2'
num2 = int(string)

print (num + num2)
```

>如果你不知道变量是什么类型，可以通过 `type()` 函数 lai 查看类型

```python
num = 3
print (type(num))
```

## 行与缩进

Python 使用「缩进」来表示代码块，不需要使用大括号`{}`
>缩进的格数是可变的，但是同一个代码块的语句必须包含相同的缩进空格数

```python
if True:
    print ("Answer")
    print ("True")
else:
    print ("Answer")
  print ("False")
```

>如果缩进不一致，会导致运行错误：

```python
File "test.py", line 6
    print ("False")
                  ^
IndentationError: unindent does not match any outer indentation level
```

## 多行语句

Python 通常是一行写完一条语句，但如果语句很长，我们可以使用反斜杠「`\`」来实现多行语句：

```python
total = item_1 + \
        item_2 + \
        item_3
```

而在 `[]`，`{}` 或 `()` 中的多行语句，不需要使用反斜杠「`\`」:

```python
total = ['item_1', 'item_2', 'item_3']
```

## 数据类型

Python 中有四种数据类型

- 整数：如 1
- 长整数：比较大的整数
- 浮点数：如 1.23、3E-2
- 复数：如 1 + 2j、1.1 + 2.2j

## 字符串

- Python 中单引号和双引号使用完全相同。
- 使用三引号「`'''`」或「`"""`」可以指定一个多行字符串
- 转义字符「`\`」
- 自然字符串：通过在字符串前加 r 或 R，所见即所得。

    ```python
    print (r"this is a line with \n.)"
    ```
    这里将输出

    ```ini
    this is a line with \n.
    ```

    而不是

    ```ini
    this is a line with
    .
    ```
- Python 允许处理 unicode 字符串，加前缀 u 或 U。

    ```python
    print (u"this is an unicode string.")
    ```
- 字符串是不可改变的
- 按字面意义级联字符串：如 `"this " "is " "string"` 会被自动转换为 `this is string`
- 字符串可以跟整数相乘

示例：

```python
word = '字符串'
paragraph = """这是一个段落，
可以由多行组成"""
print (word)
print (paragraph)
print ("this " "is " "string")
words = 'word' * 3
print (words)
```

输出：

```ini
字符串
这是一个句子。
这是一个段落，
this is string
wordwordword
```

## 空行

<font color="#DD5555">也是代码的一部分</font>

函数之间或类的方法之间用空行分割，表示一段新的代码的开始。类和函数入口之间也用一行空行分隔，以突出函数入口的开始。

>空行与代码缩进不同，空行并不是 Python 语法的一部分。书写时不插入空行，Python 解释器运行也不会出错。但是空行的作用在于分隔两段不同功能或含义的代码，便于日后代码的维护与重构。

## 等待用户输入

执行下面的程序在按回车键后会等待用户输入：

```python
input("这里写给用户看的提示")
```

## 同一行写多条语句

Python 可以在同一行中使用多条语句，语句之间使用分号「;」分割：

```python
import sys; x = 'BoziBozi'; sys.stdout.write(x + '\n')
```

执行上面的代码，输出如下：

```ini
BoziBozi

```

## import 与 from...import

### 在 Python 用 `import` 或者 `from...import` 来导入相应的模块。

- 将整个模块（somemodule）导入：`import somedule`
- 从某个模块中导入某个函数：`from somemodule import somefunction`
- 从某个模块中导入多个函数：`from somemodule import firstfunc, secondfunc, thirdfunc...`
- 将某个模块中的全部函数导入：`from somemodule import *`

例 1：导入 sys 模块

```python
import sys
print ('==========Python import mode===============')
print ('命令行参数为：')
for i in sys.argv:
    print (i)
print ('\n python 路径为：', sys.path)
```

例 2：导入 sys 模块的 argv 和 path 成员

```python
from sys import argv, path
print ('==========Python import mode===============')
print ('命令行参数为：')
for i in argv:
    print (i)
print ('\n python 路径为：', path)
```

>导入特定的成员变量时不需要在变量前加 module 名称

## 命令行参数

很多程序可移植性一些操作来查看一些基本信息，Python 可以使用 `-h` 参数查看各个参数帮助信息：

```ini
$ python -h
usage: python [option] ... [-c cmd | -m mod | file | -] [arg] ...
Options and arguments (and corresponding environment variables):
-c cmd : program passed in as string (terminates option list)
-d     : debug output from parser (also PYTHONDEBUG=x)
-E     : ignore environment variables (such as PYTHONPATH)
-h     : print this help message and exit
```