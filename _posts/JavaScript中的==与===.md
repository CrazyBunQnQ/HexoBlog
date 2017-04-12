---
title: JavaScript 中的 == 与 ===
date: 2017-04-12 23:33:33
---

`===` 叫做严格相等运算符，`==` 叫做不严格相等运算符。两者的区别网上随处可见，总结下答案无外乎就是：
>双等号会造成类型转换，推荐一律使用三等号。

<!--more-->

## `==` 与 `===` 的运算规则
### `===`
1. 不同类型值
如果两个值的类型不同，直接返回false。
2. 同一类的原始类型值
同一类型的原始类型的值（数值、字符串、布尔值）比较时，值相同就返回true，值不同就返回false。
3. 同一类的复合类型值
两个复合类型（对象、数组、函数）的数据比较时，不是比较它们的值是否相等，而是比较它们是否指向同一个对象。
4. undefined 和 null
undefined 和 null 与自身严格相等。
null === null  //true
undefined === undefined  //true

### `==`
1. `==` 在比较相同类型的数据时，与 `===` 完全一样；
2. 在比较不同类型的数据时，`==` 会先将数据进行类型转换，然后再用 `===` 比较。

#### `==` 进行类型转换规则：
1. 原始类型的值
原始类型的数据会转换成数值类型再进行比较。字符串和布尔值都会转换成数值，所以题主的问题中会有第二个string输出。
2. 对象与原始类型值比较
对象（这里指广义的对象，包括数值和函数）与原始类型的值比较时，对象转化成原始类型的值，再进行比较。
3. undefined 和 null
undefined 和 null 与其他类型的值比较时，结果都为 false，它们互相比较时结果为 true。

<br/>
## 为何不建议使用 `==`
### 使用 `==` 会导致代码意图混乱
`==` 带来的便利性抵不上其带来的成本,举个简单的例子：
团队协作中你肯定需要读别人的代码。而当你看到 `==` 时，要判断清楚作者的代码意图是确实需要转型，还是无所谓要不要转型只是随手写了，还是不应该转型但是写错了……所花费的脑力和时间要比明确的使用`===`(加上可能需要的明确转型)要多得多。
要记得团队中的每个人（包括原作者自己）都需要付出这种理解和维护成本。

<br/>
### `==` 隐藏的类型转换，会带来一些违反直觉的结果。
'' == '0'           // false
0 == ''             // true
0 == '0'            // true

false == 'false'    // false
false == '0'        // true

false == undefined  // false
false == null       // false
null == undefined   // true

' \t\r\n ' == 0     // true

### `==` 可能会带来意外的副作用
代码示例：
```JavaScript
var x = 1;
var obj = {valueOf: function(){ x = 2; return 0 }}
console.log(obj == 0, x) // true, 2
```
甚至还会产生异常
```JavaScript
var x = 1;
var obj = {valueOf: function(){ return {} }, toString: function(){ return {}}}
console.log(obj == 0) // Error: Cannot convert object to primitive value
```

<br/>
## 附：用 `==` 与 `==` 判断各类型数据的结果表
下图是 `==` 判断各类型数据的结果集，橙色部分：判断结果为 true：
![==](http://wx3.sinaimg.cn/mw690/a6e9cb00ly1fejyghnijlj20go0gl76u.jpg)
<br/>
下图是 `===` 判断各类型数据的结果集，橙色部分：判断结果为 true：
![===](http://wx2.sinaimg.cn/mw690/a6e9cb00ly1fejyfxkvlqj20go0glq5q.jpg)
<br/>
下图是更完整的判断各类型数据的结果集
- 红色：`===` 判断结果为 true;
- 橙色：`==` 判断结果为 true;
- 黄色：`<=` 和 `>=` 判断结果都为 true，但是 `==` 的判断结果为 false;
- 蓝色：只有 `>=` 的判断结果为 true;
- 绿色：只有 `<=` 的判断结果为 true;
 
![===、==、>=和<=](http://wx3.sinaimg.cn/mw690/a6e9cb00ly1fejyfug2wlj20go0gnade.jpg)


<br/>
**本文整理自[知乎](https://www.zhihu.com/question/31442029)上各位大神的回答。**