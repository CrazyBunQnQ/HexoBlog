---
title: JavaScript
date: 2017-04-12 22:22:22
categories: 
- Web 基础
tags: 
- JavaScript
---

JavaScript 简称 js，JavaScript 语言与 Java 语言没关系。JavaScript 是用来做网页动态效果的。JavaScript 分为三个模块：ECMAScript(European Computer Manufacture Assosiation)、DOM(Document Object Model)和 BOM（Browser Object Model）。

<!--more-->

ECMAScript：欧洲制造商协会，定义了基本语法、变量、循环等
DOM：文档对象模型
BOM：浏览器对象模型

## JavaScript 特点
1. js 是一个弱类型语言：变量类型不需要指定，不会出现编译错误，变量类型可以动态修改。
2. js 是一个脚本语言：不能单独运行，必须以来一个载体(html)。
3. js 是一个面向对象的语言

<br/>
## JavaScript 应用场景
1. 网页数据验证
2. 地图
3. 某些网页游戏

<br/>
## JavaScript 引入方式
- 嵌入式：使用下面的代码即可，此方式可以放在任意位置。
```HTML
<script type="text/javascript">
	JavaScript 脚本代码
</script>
```
- 链接式：引入外部文件,也可以放在任意位置。
```CSS
<script type="text/javascript" src="外部 js 路径"></script>
```

<br/>
## JavaScript 基本语法
### JavaScript 变量
JavaScript 变量的两种声明方式：
1. `var num = 10;`
2. `num = "abc";` 这里将 num 变量类型从 number 类型变为了 string 类型。

**注意：**JavaScript 中变量类型不需要指定，变量的类型是在赋值之后确定。**变量类型可以 typeof 函数查看**，并且变量类型可以动态改变。

#### JavaScript 变量类型：
基本数据类型：数值类型（小数和整数），字符串类型，逻辑数据类型

|基本数据类型|
|:--:|:--:|:--:|
|number|数值类型(小数和整数)|`var a = 10;`|
|string|字符串类型|`var b = "abc";`|
|boolean|逻辑数据类型|`var c = true;`|
|**引用数据类型**|
|array|数组|`var d = [1,"abc", false, 2.2];`|
|object|对象|``|


#### JavaScript 类型转换
1. 自动转换：重新赋值
```
var num = 10;
num = "abc";
```
2. 手动转换：使用 parseXXX(变量) 方法转换变量的数据类型为 XXX 类型。
```
var a = 10;
var b = "22.20";
var c = "20";
//计算 a + b + c 的值
var s = a + parseFloat(b) + parseInt(c);
```

#### JavaScript 中两个特殊的值
- **非零数值除以 0 会得到 Infinity(无限的)。**
`isFinite(变量)` 判断当前变量是否是有限的。
- **数值除以非数值会得到 NaN。**
`isNaN(变量)` 可以判断当前变量是否为 NaN，**Infinity 是个数字**。

<br/>
## JavaScript 运算符
|类别|运算符|
|:--:|:--:|
|赋值运算符|=|
|自增|++、--|
|算数运算符|+、-、*、/、%|
|三目运算符|boolean?值 1:值 2|
|逻辑运算符|&&(短路与)、丨丨(短路或)、!(非)、&、丨|
|比较运算符|>、<、>=、<=、==、!=、===|

`&&`、`||` 和 `!` 代码示例：
```JavaScript
age = 18;
sex = "男";
isBoy = age<18 && sex = "男";
isGirl = age < 18 && sex = "女";
isKid = isBoy || isGirl;
notKid = !isKid;
```
>==：不严格相等，值相等就返回 true
>===：严格相等，数值和类型都相等才返回 true
>if (这里可以不是 boolean 值)，如果非 boolean 类型的值则只有 NaN null 0 才会返回 false
>关于 `==` 和 `===` 更详细的区别请看[《JavaScript 中的 `==` 与 `===`》](/2017/04/12/JavaScript 中的==与===/)。


<br/>
## JavaScript 流程控制
### 选择结构：
- if ... else ...
- switch ... case ...

### 循环结构：
- while ... 
- do ... while ...
- for ...

>JavaScript 中的 for 循环与 Java 类似，也有一种增强佛循环：
```JavaScript
`for (var 下标 in 数组) {
	alsert(数组[下标]);
}
```
>注意：
>Java 中的增强 for 循环中定义的变量表示的是数组中的每个元素；
>而 JavaScript 中的增强 for 循环中定义的变量表示的是数组中的下标。

<br/>
## JavaScript 中的函数
### 定义函数
1. 
function 方法名(){
	方法体
}
2. 
var 方法名 = function(){
	方法体
} 

### 调用函数
1. 方法名();
2. var abc = 方法名; abc();

>JavaScript 中不支持方法重载，后面的方法如果和前面的方法名相同，则会覆盖前面的方法名
>JavaScript 天然支持方法重载，JavaScript 中方法的参数可以任意传递，通过封装对象 arguments 获取传递的参数


<br/>
## JavaScript 数组
JavaScript 中的数组是不定长的，且元素可以是任意类型。
定义数组 var arr = [12, "34", 5.6, false];
数组长度 arr.length
遍历数组
```JavaScript
for (var key in arr) {//key 为下标
	arr[key];
}
```
下标 key 也可以不是数字
### 数组动态赋值
为指定下标赋值：
```JavaScript
arr[下标] = 值;
arr["sh"] = "上海";
arr["bj"] = "北京";
for (var key in arr) {//key 为下标
	alert(key + ": " + arr[key]);
}
```

<br/>
### 二维数组
二维数组的声明与遍历：
```JavaScript
var citys = new Array();
cittys["bj"] = ["昌平", "宣武", "丰台"];
cittys["sh"] = ["浦东", "虹桥", "崇明岛"];

for (var key in citys) {
	for (var i = 0; i < citys[key].length; i++) {
		alert(citys[key][i];
	}
}
```

## other
根据获取 HTML 页面元素 `document.getElementByXXX()`