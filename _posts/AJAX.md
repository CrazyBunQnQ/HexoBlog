---
title: AJAX
date: 2017-5-2 17:47:09 
categories:
- Java 基础
tags: 
- AJAX
---

AJAX (asyn javascript and xml，异步 JavaScript 和 XML)

<!--more-->

- 同步的：
发出请求 → 页面销毁，等待服务请求 → 处理请求 → 返回新页面（新页面）
这样会导致表单提交后如果失败会清空用户输入的数据，导致用户体验很差

- 异步的：
向服务器发出请求和用户的操作是异步的，各做各的，不需要等待，页面只会局部刷新，不会整个刷新。
每输入一个内容，都会发送请求，你输入你的，服务器处理它的数据。

优势：
- 用户体验好（页面不会被销毁，按需及时获取数据）
- 按需获取数据

## 异步编程
1. 获取浏览器内置的 BOM 对象 XmlHttpRequest
2. 和服务器建立连接
3. 发送请求
4. 页面上做 JS 处理

实例：验证用户名是否重复
```JavaScript
//获取不同浏览器内置对象 XMLHttpRequest
function getXhr() {
	var xhr = null;
	if (window.XMLHttpRequest) {
		// 大多数浏览器获取内置对象 XMLHttpRequest 的方法
		xhr = new XMLHttpRequest;
	} else {
		// IE 浏览器获取内置对象 XMLHttpRequest
		xhr = new ActiveXObject("Microsoft.XMLHttp");
	}
	return xhr;
}

// 异步发送请求
function checkUname() {
	//1.获取浏览器内置对象 XMLHttpRequest
	var xhr = getXhr();
	//获取用户输入的用户名
	var username = document.getElementById("uname").value;
	//2.和服务器建立连接
	xhr.open("get","checkuname?uname=" + username,true);
	//3.获取到服务器返回的数据 页面处理
	xhr.onreadystatechange = function () {//回调函数 callback（服务器返回数据后才会执行，而不是立即执行，根据服务器返回的状态码进行相应处理）
		//判断服务器响应状态
		if (xhr.readyState === 4 && xhr.state === 200) {
			//获取服务器返回的数据内容
			var txt = xhr.responseText;
			document.getElementById("msg").innerHTML = txt==0?"用户名已被使用":"";
		}
	};
	//4.发送异步请求
	xhr.send(null);
}
```

若要改为 post 请求
```JavaScript
xhr.open("post","checkuname" + username,true);
xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
xhr.send("uname=" + username);
```

>服务器响应的五个状态值
- 0：(未初始化)对象已经建立
- 1：(初始化)对象已经建立，尚未调用 send 方法 
- 2：(发送数据)异步请求刚发送出去  send 方法已经调用
- 3：(数据发送中)服务器将数据部分响应给浏览器   已经接受部分数据，此时，数据不完全发送完毕
- 4：服务器将数据全部响应给浏览器 响应结束，此时可以通过 responseText/respo 获取数据了

get 和 post 的区别：
- open("get", "地址?参数名=参数值", true);

- open("post", "地址", true);
send("参数名=参数值&参数名=参数值");

>open() 方法第三个参数：
>false：就是等待有返回数据的时候再继续往下走，还没有得到数据的时候就会卡在那里，直到获取数据为止。
>true：就是不等待,直接返回，这就是所谓的异步获取数据！

## 解析 JSON 数据
json 数据格式：
{"id":101,"name":"张三丰"}

//获取到
var txt = xhr.responseText;
//将 JSON 字符串解析为 DOM 对象
var obj = JSON.parse(str);
//或
var arr = txt.evalJson();

document.getElementByID("tb").innerHTML = "";
var tr = document.createElemennt("tr");//创建标签
var td1 = document.createElemennt("td");//创建标签
var td2 = document.createElemennt("td");//创建标签
var td3 = document.createElemennt("td");//创建标签
td1.innerHTML = obj.stock_no;
td2.innerHTML = obj.stock-name;
td3.innerHTML = obj.stock_price;
tr.appendChild(td1);
tr.appendChild(td2);
tr.appendChild(td3);
document.getElementByID("tb").appendChild(tr);

>prototype 1.6.js 框架
>封装了很多 js 函数





## JQuery:
js 框架 封装了原始 js 代码
封装了 js的操作
功能
开发效率快 准确度高
屏蔽所有浏览器的差异，兼容性好
jquery 对象  （dom 对象封装后成了 jquery对象）
dom 对象

1. [jquery 选择器](http://www.w3school.com.cn/jquery/jquery_ref_selectors.asp)

>类似于 css 选择器
>选择性查找对象


------

>html()：支持 html 标记，会渲染为对应的效果
>text()：不支持 html 标记


### jquery 操作 DOM
