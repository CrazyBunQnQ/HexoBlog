---
title: Python 3 的字符串
date: 2017-11-12 22:22:22
categories: Python
tags: 字符串
---

字符串是什么？

在上一篇博客我们已经初步了解到了字符串，简单地说，字符串就是......
<div style="text-align:center;font-size:20px;color:#d63e63">"<font color="e89648">任何在这双引号之间的文字</font>"</div>

<div style="text-align:center">或者</div>

<div style="text-align:center;font-size:20px;color:#d63e63">'<font color="e89648">单引号其实和双引号完全一样</font>'</div>

<div style="text-align:center">再或者</div>

<div style="text-align:center;font-size:20px;color:#d63e63">'''<font color="e89648">三个引号被用于过长段的文<br/>字或者是说明，只要三引号不完<br/>你就可以随意换行写下文字</font>'''</div>

这一篇呢，咱详细的讲讲 Python 3 的字符串用法~略微详细的...哈哈哈

<!--more-->

## 字符串的基本用法

### 合并

运行下面的代码：

```python
what_he_does = ' plays '
his_instrument = 'guitar'
his_name = 'Robert Johnson'
artist_intro = his_name + what_he_does + his_instrument
print (artist_intro)
```

会输出

```ini
Robert Johnson plays guitar
```

感觉好无聊啊，不过这都是基础，以后加上界面一定就好看了^_^

### 类型转换

Python 中不同的数据类型是不能够进行合并的，但是可以通过一些方法进行转换

```python
num = 1
string = '1'
num2 = int(string) # 字符串转换成数字

print (num + num)
```

>如果你不知道变量是什么类型，可以通过 `type()` 函数来查看类型。在编辑器中输入 `print (type(xxx))` 即可查看 xxx 的数据类型。
>
>另外，由于中文注释也会导致报错，所以需要在文件开头加一行魔法注释 `#coding:utf-8`

### 字符串相乘

既然字符串可以相加，那么字符串之间能不能相乘呢？当然可以！

```python
words = 'words' * 3
print (words)
# 输出结果
wordswordswords
```

怎么样，有意思吧？咱再试试更复杂的！

```python
word = 'a looooong word'
num = 12
string = 'bang!'
total = string * (len(word) - num)
print (total)
# 输出结果
bang!bang!bang!
```

Bang! 恭喜你，掌握了字符串最基本的用法了！

## 字符串的分片与索引

字符串可以通过 `string[x]` 的方式进行索引、分片。实际上就是从字符串中找出你要截取的东西，复制出来一小段你要的长度，储存在另一个地方，而不会对原字符串改动。分片获得的每个字符串可以看做是原字符串的一个副本。

类似 Java 中的 `substring()`，但又有些不同：

```python
name = 'My name is Bozi'

print (name[0]) # 第 0 号字符
print (name[-4]) # 第 -4 号字符，也就是倒数第 4 个字符
print (name[11:14]) # 从第 11 号到第 14 位，第 14 号被排除在外
print (name[11:15]) # 从第 11 号到第 15 位，第 15 号被排除在外
print (name[5:]) # 从第 5 号到结束
print (name[:5]) # 从第 0 号到第 5 号
# 输出结果
M
B
Boz
Bozi
me is Bozi
My na
```

|name = "|M|y||n|a|m|e||i|s||B|o|z|i|"|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|indexing|0<br/>-15|1<br/>-14|2<br/>-13|3<br/>-12|4<br/>-11|5<br/>-10|6<br/>-9|7<br/>-8|8<br/>-7|9<br/>-6|10<br/>-5|11<br/>-4|12<br/>-3|13<br/>-2|14<br/>-1||

### Java 中的字符串截取 substring()

>没学过 Java 直接跳过

顺便复习一下 Java API，哈哈哈

- public String substring(int beginIndex)

    返回一个字符串，它是字符串的子字符串。子字符串以指定索引中的字符开始，并扩展到该字符串的末尾:

    ```java
    String result = "abcdefg".substring(3);
    System.out.println(result);
    //输出结果
    defg
    ```

- public String substring(int beginIndex, int endIndex)

    返回一个新字符串，它是字符串的子字符串。子字符串从指定的开始索引开始，并扩展到索引 `endIndex - 1` 的字符。因此，子字符串的长度为 `endindex - beginindex`。

    ```java
    String result = "abcdefg".substring(3, 5);
    System.out.println(result);
    //输出结果
    de
    ```

### 小练习

在此之前，我们先做个文字小游戏——「<font color="d63e63">找出你朋友中的魔鬼</font>」：

```python
word = 'friends'
find_the_evil_in_your_friends = word[0] + word[2:4] + word[-3:-1]
print (find_the_evil_in_your_friends)
# 输出结果
fiend
```

怎么样？你找到了吗？

下面看一个是项目中的应用：

```python
'http://ww1.site.cn/14d2e8ejw1exjogbxdxhj20ci0kuwex.jpg'
'http://ww1.site.cn/85cc87jw1ex23yhwws5j20jg0szmzk.png'
'http://ww2.site.cn/185cc87jw1ex23ynr1naj20jg0t60wv.jpg'
'http://ww3.site.cn/185cc87jw1ex23yyvq29j20jg0t6gp4.gif'
```

假如现在有 500 多张附有这样链接的图片要下载，也就是说我需要给这 500 张不同格式的图片（png,jpg,gif）以一个统一的方式进行命名。

通过观察规律，决定以链接尾部倒数 10 个字符进行命名，于是可以输入代码如下：

```python
url = 'http://ww1.site.cn/14d2e8ejw1exjogbxdxhj20ci0kuwex.jpg'
file_name = url[-10]
print (file_name)
# 输出结果
0kuwex.jpg
```

## 字符串的常用方法

Python 是面向对象进行编程的语言，而对象拥有各种功能、特性，专业术语称之为——方法（Method）。

假如我们生活中的车是「对象」，即 car。

而车有很多功能，例如「开」就是一个重要功能，于是对于『汽车使用「开」这个功能』，在 Python 中就可以表述成这样：

```python
car.drive()
```

![车的属性和方法]()

>这里与 Java 面向对象差不多

### 替换字符串

了解了对象的方法后，我们来看这样一个场景：

>很多时候我们在网站上查看个人信息的时候，银行账户、身份证和手机号等都会显示部分信息，其余的用「*」来代替。

![替换字符串]()

下面我们试着用 Python 字符串的方法来实现这一个功能:

```python
number = '1386-666-0006'
hiding_nomber = number.replace(number[:9], '*' * 9)
print (hiding_number)
# 输出结果
*********0006
```

其中我们使用了 `replace()` 方法进行「遮挡」。会将原字符串中的某些字符串替换成新的字符串，查看 Python 3 API 文档可以看到：

- str.replace(old, new[, count])
    1. str.replace(old, new)
    1. str.replace(old, new, count)

    Return a copy of the string with all occurrences of substring old replaced by new. If the optional argument count is given, only the first count occurrences are replaced.

翻译成中文为：将字符串中的所有子字符串 old 替换成新字符串 new 后返回，返回的字符串是原字符串的副本，并不影响原字符串。如果给出可选参数 count，则只有前 count 个出现的字字符串 old 被替换。

### 查找字符串

我们再试试解决一个更复杂一点的问题，来模拟手机通讯录中的<font color="d63e63">电话号码联想功能</font>

![电话号码联想]()

>只是个大概思路，真实情况更为复杂

```python
search = '168'
num1 = '1368-168-0006'
num2 = '1681-222-0006'

print (search + ' is at ' + str(num1.find(search)) + ' to ' + str(num1.find(search) + len(search)) + ' of num1')
print (search + ' is at ' + str(num2.find(search)) + ' to ' + str(num2.find(search) + len(search)) + ' of num2')
# 输出结果
168 is at 5 to 8 of num1
168 is at 0 to 3 of num2
```

在上面的代码中，我们使用了 `str.find()` 方法，我们来看看 Python 3 的 API 文档是怎么说的：

- str.find(sub[, start[, end]])
    1. str.find(sub)
    1. str.find(sub, start)
    1. str.find(sub, start, end)

    Return the lowest index in the string where substring sub is found within the slice s[start:end]. Optional arguments start and end are interpreted as in slice notation. Return -1 if sub is not found.

继续秀我的烂英语(翻译不好请指出，最近在学英语，哈哈)

返回字字符串 `sub` 在 `str`（或者字符串片段 `str[start:end]`）中找到的最低索引位置(整数)。可选参数的开始和结束被解释为片表示法。如果没有在 `str` 中找到 `sub` 则返回 `-1`。

>`find()` 方法仅当你需要知道 sub 在 str 中的位置时才使用，若想要检查 sub 是否为 str 的子字符串，请使用 `in` 运算符:
>    ```python
>    'Py' in 'Python'
>    # 输出结果
>    True
>    ```

这里还用到了数据类型转换 `str()` 将数字转换为字符串

以及 `len()` 方法获得字符串的长度

- len(s)

    Return the length (the number of items) of an object. The argument may be a sequence (such as a string, bytes, tuple, list, or range) or a collection (such as a dictionary, set, or frozen set).

翻译：返回对象的长度(项目的个数)。参数可能是一个序列(例如字符串、字节、元组、列表或范围)或集合(如字典、集合或冻结集)。

>呃...·`len()` 方法好像用的地方还很多呢...貌似把 Java 的各种 `length` 属性、`length()` 方法以及 `size() `方法整合到一起啦？以后遇到再说啦！

### 字符串格式化符

>这个名字...嗯，总觉着怪怪的...

来看个填空题

\_\_ a word she can get what she \_\_ for.

A.With&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;B.came

上面这样的填空题大家肯定不陌生，当字符串中有多个这样的「空」需要填写的时候，我们可以使用 `.format()` 方法进行批处理，它的基本使用方法有下面几种：

```python
example = '{} a word she can get what she {} for.'
print (example.format('With','came'))
# print ('{preposition} a word she can get what she {verb} for.'.format(preposition = 'With', verb = 'came'))
print ('{1} a word she can get what she {2} for.'.format('came','With'))
# 输出结果
With a word she can get what she came for.
With a word she can get what she came for.
```

>这个...第二种方式我运行的时候报错啦，有人知道什么原因吗？...

来来来继续看 API 文档秀我的烂翻译...

- str.format(*args, **kwargs)

    Perform a string formatting operation. The string on which this method is called can contain literal text or replacement fields delimited by braces {}. Each replacement field contains either the numeric index of a positional argument, or the name of a keyword argument. Returns a copy of the string where each replacement field is replaced with the string value of the corresponding argument.

这么长啊...硬着头皮翻译：
执行字符串格式化操作。调用这个方法的字符串可以包含蚊子文本或由大括号「`{}`」分隔的替换字段。每个`{}`都包含一个位置参数的数值索引，或一个关键字参数的名称。该方法返回 str 的副本(不影响原 str 值)，其中每个`{}`替换为相应参数的字符串值。

这种字符串天空的方式使用很广泛，例如向下面代码这样填充王志忠空缺的城市数据：

```python
city = input('write down the name of city:')
url = 'http://apistore.baidu.com/microservice/weather?citypinyin={}'.format(city)
```

>这是利用百毒提供的天气 API 实现客户端天气插件的开发代码片段

## 感谢看完

嗯，以上就是字符串的基本概念和常用方法啦！
>如果想更加详细的了解 Python 3 字符串的用法，可以去查看官方的 API 文档，不过初学者不建议哟，比如我...
>
>因为直接看 API 文档的话太枯燥了，很容易失去兴趣，同样...比如我...

最后！看完有疑问以及有建议的可以留言！！！谢谢！