---
title: JavaScript 验证码的实现
date: 2017-04-14 22:22:22
categories: 
- Web 基础
- 未完成
tags: 
- JavaScript
- 验证码
---

最近想给自己的网站做个注册页面，就发现需要个验证码来防止机器注册。

<!--more-->
下面是核心方法介绍
## Canvas
更具体的可以参看 [HTML 5 Canvas 参考手册](http://www.w3school.com.cn/tags/html_ref_canvas.asp) 

### 获取或创建 canvas 元素（HTML 标签）
- 获取 HTML 上的 canvas 标签
HTML 代码：
```HTML
<canvas id="myCanvas" width="200" height="100"></canvas>
```
JS 代码：
```JavaScript
canvas = document.getElementById("myCanvas");
```
- 临时创建一个 canvas 元素
```JavaScript
canvas = document.createElement('canvas')
```

<br/>
### 创建 CanvasRenderingContext2D 对象
**语法**
```JavaScript
Canvas.getContext(contextID)
```
**参数**
contextID 指定了您想要在画布上绘制的类型。当前唯一的合法值是 "2d"，它指定了二维绘图，并且导致这个方法返回一个环境对象，该对象导出一个二维绘图 API。
>不过当前只支持 "2D" 参数，可能是为了以后扩展三维绘图做准备吧，哈哈

**返回值**
一个 CanvasRenderingContext2D 对象，使用它可以绘制到 Canvas 元素中。

### 设置 CanvasRenderingContext2D 对象属性
```JavaScript
ctx.fillStyle = '#f3fbfe';//背景色
ctx.fillRect(矩形左上角 x 坐标, 矩形左上角 y 坐标, 矩形右下角 x 坐标, 矩形右下角 y 坐标);//设置矩形
ctx.globalAlpha = .8;//设置透明度
ctx.font = '16px sans-serif';//设置字体和字体大小
```