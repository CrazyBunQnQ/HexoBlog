---
title: JavaScript 面向对象
date: 2017-04-13 22:22:22
categories: Web 基础
tags: 
- JavaScript
- 面向对象
---

JavaScript 中的面向对象与 Java 中的面向对象类似，JavaScript 中的原型对象 和 Java 中的类是一个概念。

<!--more-->

## 原型对象
### 定义原型对象：
```JavaScript
function 原型对象名(){ 
	方法;
	属性;
}
```
>定义原型对象看起来和定义方法很想，所以为了方便区分，习惯上将对象名首字母大写，方法名首字母小写。

### 创建原型对象与 Java 一样，使用 new 关键字创建原型对象
```JavaScript
var 对象名 = new 原型对象名();
var a = new Person();
```

### 设置对象属性：
```JavaScript
对象名.属性名 = 属性值;
a.name = "张三";
a.age = 10;
a.sex = "M";
```

### 设置方法：
```JavaScript
a.say = function() {
	alert(a.name + "," + a.age + "," + a.sex); 
}
```

### 调用对象的方法：
```JavaScript
a.say();
```

<br/>
## JavaScript 原型对象的公有属性，私有属性，静态属性
### 公有属性
公有属性、方法可以在类的外部访问，使用 `this.XXX` 定义的属性和方法为公有,`XXX` 为属性名或方法名：
```JavaScript
function Person() {
	this.name = "张三";//公有属性
	this.age = 10;//公有属性
	this.show = function() {//公有方法
		console.log("name:" + this.name + ", age:" + this.age);
	}
}
```
>**值得一提的是，类的公有属性在类的内部调用时，也需要使用 `this.属性名`。**

<br/>
### 私有属性
私有属性、方法只能在类的内部访问，使用 `var XXX` 定义的属性和方法为私有,`XXX` 为属性名或方法名：
```JavaScript
function Person() {
	var name = "张三";//私有属性
	var age = 10;//私有属性
	var show = function() {//私有方法
		console.log("name:" + name + ", age:" + age);
	}
}
```
>私有属性在访问时直接使用属性名即可

<br/>
### 静态属性
使用 `类名.XXX` 定义的属性和方法为静态属性或静态方法,`XXX` 为属性名或方法名：
```JavaScript
function Person() {
	Person.name = "张三";//私有属性
	Person.age = 10;//私有属性
	Person.show = function() {//私有方法
		console.log("name:" + Person.name + ", age:" + Person.age);
	}
}
```
>与 Java 一样，静态属性和方法不属于任何具体的对象，只能通过 `类名.XXX` 来调用。
>与 公有属性类似，即使是类的内部也需要使用 `类名.XXX` 来调用。

<br/>
## 原型对象 prototype 属性
1. 用于扩展当前原型对象的方法和属性，扩展的方法和属性是每个具体对象中都有的。
2. 用于重写当前原型对象的方法和属性。

假设 Dog 对象已经给定了，无法修改：
```JavaScript
function Dog(name, sex){
	this.name = name;
	this.sex = sex;
	this.eat = function() {
		alert("一只" + sex + "狗" + this.name + "正在啃骨头！");
	}
}

var dog1 = new Dog("旺旺","公");
dog1.eat();
```

这时若想添加一个 bark 方法，就可以使用 `类名.prototype.XXX` 给 Dog 类添加属性或方法，这些属性和方法在每个 Dog 具体对象中都可以调用。

```JavaScript
Dog.prototype.bark = function() {
	alert("它正在狂吠");
}

dog1.bark();
```

>使用 prototype 也可以重写原型对象中的方法和系统提供的方法。


<br/>
## JavaScript 对象 与 JSON 对象
### 对象的创建方式
- [使用 `new 原型对象()` 创建原型对象]()
- 非原型对象也可以直接创建
```JavaScript
var p2 = {
	name: "李四",
	age: 10,
	classroom:{
		classId: 1,
		className: "小葵花班"
	},
	score: [100, 20, 40],
	eat: function() {
		console.log("吃了一天包子。");
	}
};
```
>该对象是单独的一个对象，没有原型模板，不是原型对象。

### JSON
JSON 是一个特殊的 JavaScript 对象，常用的传输数据格式。
其格式为 js 普通对象的属性名全部添加 "" 后的样子
```JavaScript
var p2Json = {
	"name": "李四",
	"age": 10,
	"classroom":{
		"classId": 1,
		"className": "小葵花班"
	},
	"score": [100, 20, 40],
	"eat": function() {
		console.log("吃了一天包子。");
	}
};
```
调用 JSON 对象方式与 JavaScript 对象一样
```JavaScript
alert(p2.name);
alert(p2Json.name());
```

### JSON 对象转换为 JavaScript 对象
在传递数据的时候一般将 JSON 对象转换成字符串。
使用 `JSON.stringify()` 方法可以将 JS 对象或者 JSON 对象转换成 JSON 字符串。
```JavaScript
var p2JsonStr = JSON.stringify(p2Json);
alert(p2JsonStr);
```
若想将 JSON 对象转换为 JavaScript 对象，则需要先将 JSON 对象转换为字符串
```JavaScript
var p2New = JSON.parse(p2JsonStr);
```

<br/>
## JavaScript 面向对象的特征（封装、继承和多肽）
### 封装
```JavaScript
function Person(n,a) {
	var name = n;//私有属性
	var age = a;//私有属性
	this.show = function() {//公有方法
		console.log("name:" + name + ", age:" + age);
	}
	this.setName = function(v) {
		name = v;
	}
	this.setAge = function(a) {
		age = a;
	}
	this.getName = function() {
		return name;
	}
	this.getAge = function() {
		return age;
	}
}

var p1 = new Person("lucy",10);
alert(p1.getAge);
```
>与 Java 不同，这里的参数名不可和私有属性同名。

### 继承
```JavaScript
function Student(n,a) {
	this.person = Person;//继承 Person
	this.person(n,a);
	this.eat = function() {
		console.log("吃饭");
	}
}
```

### 多态
向上转型：父类引用执行不同的子类对象，调用相同的方法，结果不同。
同一个引用指向不同的对象，表现的行为方式不同

<br/>
## JavaScript 内置对象
- [Array](http://www.w3school.com.cn/jsref/jsref_obj_array.asp)
- [Date](http://www.w3school.com.cn/jsref/jsref_obj_date.asp)
- [Math](http://www.w3school.com.cn/jsref/jsref_obj_math.asp)
- [Number](http://www.w3school.com.cn/jsref/jsref_obj_number.asp)
- [String](http://www.w3school.com.cn/jsref/jsref_obj_string.asp)
- [Functions](http://www.w3school.com.cn/jsref/jsref_obj_global.asp)

更多内置对象可参考 [w3cschool](www.w3school.com.cn) 上的[《JavaScript 对象参考手册》](http://www.w3school.com.cn/jsref/index.asp)