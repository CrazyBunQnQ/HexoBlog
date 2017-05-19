---
title: JQuery
date: 2017-5-8 9:26:12 


---


<!--more-->

发送异步请求
$.get(url[, data, callback, type]);
url: 服务器的地址
data: 参数（key=value）
callback: 回调函数
type: 返回内容格式（json, xml, html, script, text, _default）

示例：

`$.get(url, data, callback(data), json`