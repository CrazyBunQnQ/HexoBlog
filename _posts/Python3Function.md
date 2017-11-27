---
title: Python 3 的函数
date: 2017-11-18 22:22:22
categories: Python 3
tags: 函数
---

字符串是什么？

其实经过上一篇博客的阅读与训练，你已经掌握了函数的用法：
<div style="text-align:center;font-size:20px;color:#d63e63">print 是一个放入对象就能将结果打印的函数</div>

<div style="text-align:center;font-size:20px;color:#d63e63">input 是一个可以让用户输入信息的函数</div>

<div style="text-align:center;font-size:20px;color:#d63e63">len 是一个可以测量对象长度的函数</div>

<div style="text-align:center;font-size:20px;color:#d63e63">int 是一个可以将字符串类型的数字转换成整数类型的函数</div>

通过观察规律，其实不难发现，Python 中所谓的使用函数就是把你要处理的对象放到一个名字后面的括号里就可以了。简单的来说，函数就是这么使用，往里面塞东西就能得到处理结果。

<!--more-->

## 内建函数 (Built-in Functions)

以 Python 3.50 版本为例，一共存在 68 个内建函数（Built-in Function）。之所以被称之为内建函数，并不是因为还有「外建函数」这个概念，内建的意思是这些函数在 3.50 版本安装完成后你就可以使用它们，是「自带」的而已。

||||||
|:-:|:-:|:-:|:-:|:-:|
|abs()|dict()|help()|min()|setattr()|
|all()|dir()|hex()|next()|alice()|
|any()|divmod()|id()|object()|sorted()|
|ascii()|enumerate()|input()|oct()|staticmethod()|
|bin()|eval()|int()|open()|str()|
|bool()|exec()|isinstance()|ord()|sum()|
|bytearray()|filter()|issubclass()|pow()|super()|
|bytes()|float()|iter()|print()|tuple()|
|callable()|format()|len()|property()|type()|
|chr()|frozenset()|list()|range()|vars()|
|classmethod()|getattr()|locals()|repr()|zip()|
|compile()|globals()|map()|reversed()|\_import\_()|
|complex()|hasattr()|max()|round()||
|delattr()|hash()|memoryview()|set()||

>现在并不用着急把这些函数是怎么用的都搞明白，其中一些内建函数很实用，但是另外一些就不常用，比如涉及字符编码的函数 ascii(), bin(), chr() 等等，这些都是相对底层的编程设计中才会使用到的函数，在你深入到一定程度的时候才会派的上永昌。

<br/>

## 开始创建函数

我们需要学会使用已有的函数，更需要学会创建新的函数。自带的函数数量是有限的，想要让 Python 帮助我们做更多的事情，就要自己设计符合使用需求的函数。创建函数也很简单，其实我们在多年前的初中课上早已掌握了其原理。

先试着在命令行/终端中进入 Python 环境，输入这样的公式：

```python
>>> 1/2*(3+4)*5
17.5
>>> 32*9/5+32
89.6
```

看着眼熟不？第一个是数学梯形计算公式，而第二个是物理的摄氏度与华氏度的转换公式。

函数式编程中最基本的魔法，但同时一切的复杂又被隐含其中。它的原理和我们学习的数学公式相似，但是并不完全一样。

**这里先介绍几个常见的词：**

- def (即 define, 定义) 的含义是创建函数，也就是定义一个函数。
- arg (即 argument, 参数) 有时你还能见到这种写法：parameter，二者都是参数的意思，但是稍有不同。
- return 即返回结果。

下面我们来定义一个函数：

Define a function named 'function' which has two arguments : arg1 and arg2, returns the result —— 'Something'

是不是很易读很顺畅？哈哈，翻译成代码的话比英文句子更简洁一点：

![Python3 定义函数](http://wx3.sinaimg.cn/mw690/a6e9cb00gy1flvpcdd9xpj20s00d4tao.jpg)

**注意**

- def 和 return 是关键字（keyword），Python 就是靠识别这些特定的关键字来明白用户的意图，实现更为复杂的编程。
- 在闭合括号后面的冒号必不可少，而且必须是英文输入法，否则就是错误的语法。
- 如果在 IDE 中冒号后面回车（换行）你会自动的得到一个缩进。函数缩进后面的语句被称作是语句块（block），缩进是为了表明语句和逻辑的从属关系，是 Python 最显著的特征之一。

>缩进问题刚开始很容易忽视，导致代码无法成功运行，比如我。。。。

现在我们试着把之前提到的摄氏度转化公式定义为 Python 函数：

```python
def fahrenheit_Converter(C):
    fahrenheit = C * 9/5 + 32
    return str(fahrenheit) + '°F'
```

我们把摄氏度定义为函数 fahrenheit_Converter(),那么输入进去的必然是摄氏度（Celsius）数值，我们把 C 设为参数，最后返回的是华氏度（fahrenheit）数值。

>注意：计算的结果类型是 int，不能与字符串「°F」相合并，所以需要先使用 str() 函数进行转换。

定义完了函数，我们再来使用它：

```python
C2F = fahrenheit_Converter(35)
print (C2F)
#输出结果
95°F
```

我们把使用函数这种行为叫做「调用」(call)，你可以简单的理解成你请求 Python 给你帮忙去做一件事情，就像上一篇文章学到的 len() 一样：「请帮我测量这个对象的长度，并将结果打印出来。」

到此为止，Python 中函数的定义和基本用法我们就已经了解了。