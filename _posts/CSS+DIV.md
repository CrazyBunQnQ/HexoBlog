---
title: DIV + CSS
date: 2017-04-11 22:22:22
categories: Web 基础
tags: 
- CSS
- DIV
- HTML
---

CSS(Casading Style Sheet) → 层叠样式表，用来美化网页。
DIV(DIVision) → DIV 是层叠样式表中的定位技术。

<!--more-->

## CSS
### CSS 的声明和注释
对指定标签做修饰
```CSS
选择器{
	声明
}
```

CSS 中只有一种注释方式：
```CSS
/*这里写注释*/
```

<br/>
### 选择器
选择器选中某个或多个特定的标签。
#### 基本选择器
**id 选择器：**在标签中加入 id 属性 `id="id 名称"`
```CSS
#id 名称{
	样式声明
}
```

**标签选择器：**
```CSS
标签名{
	样式声明
}
```

**类选择器：**在标签上加入 class 属性 `class="类名"`
```CSS
.类名{
	样式声明
}
```

**属性选择器**在标签中加入 name 属性
```CSS
[name]{
	样式声明
}

[name="属性值"]{
	样式声明
}
```

**全局选择器:**
```CSS
*{
	样式声明
}
```

<br/>
#### 复合选择器
- 交集选择器：同时达到多个选择器条件的选择器。标签名必须在最前，后面可添加其他[基本选择器](/2017/04/11/CSS+DIV/#基本选择器)
```CSS
标签名.类名#id 名{
	样式声明
}
```
- 并集选择器：一次性定义多个选择器，每个选择器都应用该样式，多个选择器之间用英文逗号隔开，没有顺序
```CSS
.类名,标签名,id 名{
	样式声明
}
```
- 后台选择器：定义父选择器中的子选择器样式，父选择器不受影响，严格的顺序，用空格隔开，例如定义标签 c 的样式如下：
```CSS
a 标签 a 的子标签 b b 的子标签 c {
	样式声明
}
```

<br/>
#### 选择器优先级
1. id 选择器
2. 属性选择器、类选择器
3. 标签选择器
4. 全局选择器

>同优先级的选择器，后面的覆盖前面的


 打完收工，然后扬眉吐气 我觉着没错，但是那些频繁收工频繁扬眉频繁吐气的人是什么情况？
<br/>
### CSS 特性
- 继承性：子标签若没有定义样式，则会继承父标签的样式
- 层叠性：样式不冲突的前提下，所有选择器添加的样式都会展现

<br/>
### 常用属性
```CSS
div{
	color: purple;/*字体颜色*/
	width: 200px;/*宽度
	height: 200px;/*高度
	background-image: url(img/img1.jpg);/*背景图片*/
	background-color: yellow;/*背景颜色*/
	font-size: 30px;/*字体大小*/
	font-family: 宋体;/*字体*/
	font-style: italic;/*倾斜*/
	font-weight: bold;/*加粗*/
	cursor: pointer;/*光标形态*/
	line-height: 200px;/*行高，文字在行高内居中*/
	overflow: hidden;/*处理溢出部分，多出的部分隐藏*/
	letter-spacint: 2em;/*字符间距，一个 em 等于一个 font-size*/
}
```

<br/>
### 引入样式表的四种方式（就近原则）
#### 行内式引入：
在标签上添加 style 属性:
```CSS
style="样式 1:样式 1 的值; 样式 2:样式 2 的值"
```
#### 嵌入式引入
在 head 标签下添加一个 `<style></style>` 标签，在 `style` 标签下写样式。

#### 导入式引入
需要编写一个外部 CSS 文件(.css 文件)，在 `<style></style>` 标签下写一个导入指令:
```CSS
@import 文件位置
``` 

#### 链接式引入
需要编写一个外部 CSS 文件(.css 文件)，在 `<head>` 标签中写入 `<link>` 标记引入外部文件:
```CSS
<link rel="stylesheet" href="路径"/>
```

>导入式和链接式的区别：
>导入式是同步加载的，需要等待 html 文档全部加载完毕才能加载该 CSS 样式文件；
>链接式是异步加载的，和 html 文档同时加载。

<br/>
### 其他
#### 超级链接的四种状态
```CSS
/*链接初始化状态*/
a:link {
	color: green;
	text-decoration: none;
}
/*鼠标悬停状态*/

a:hover {
	color: red;
	text-decoration: underline;
}
/*鼠标点击一瞬间的状态*/
a:active {
	color: yellow;
	text-decoration: underline;
}
/*鼠标点击后的状态*/
a:visited{
	color: grey;
	text-decoration: none;
}
```
<br/>
### 重置样式
可以将块标签和行标签互换，也可以将加粗变为倾斜，倾斜变为加粗等等。
```CSS
b{/*加粗标签*/
	font-weight: normal;/*取消加粗*/
	font-style: italic;/*倾斜*/
}
i{/*倾斜标签*/
	font-style: normal;/*取消倾斜*/
	font-weight: bold;/*加粗*/
}

div{/*块级标签*/
	display:inline;/*改为行级标签*/
}
span{/*行级标签*/
	display:block;/*改为块标签*/
}
```

<br/>
## div 布局
在网页中确定每个模块的位置，也就是每个 div 盒子的位置。

### 盒子模型
如图所示:
![盒子模型](http://wx4.sinaimg.cn/mw690/a6e9cb00ly1feiqdjhq12j205l05qwe9.jpg)
一个盒子包含**元素（图中蓝色部分）、内边距(padding)、边框(border)和外边距(margin)** 四个元素。
- 元素：可以设置元素的大小,width 和 height。
- 内边距：元素和边框的距离(padding)
```CSS
padding: 四周内边距;
padding: 上下内边距 左右内边距;
padding: 上内边距 左右内边距 下内边距;
padding: 上内边距 右内边距 下内边距 左内边距;
```
- 边框：盒子的边框宽度(border)，可同时设置边框的类型和颜色。
```CSS
border: 四周边框的宽度 类型 颜色;
border-top: 上边框的宽度 类型 颜色;
border-bottom: 下边框的宽度 类型 颜色;
border-left: 左边框的宽度 类型 颜色;
border-right: 有边框的宽度 类型 颜色;
```
- 外边距：盒子与盒子之间的距离(margin),**上下相邻的两个盒子间距取两者中的最大外边距，而左右相邻的两个盒子间距为两者外边距的和**。
```CSS
margin: 四周外边距;
margin-top: 上外边距;
margin-bottom: 下外边距;
margin-left: 左外边距;
margin-right: 右外边距;
```

<br/>
### 盒子定位
通过 position 设置盒子的定位方式，通过 left、top 设置坐标
1. 标准流定位：就是盒子的默认位置
```CSS
position: static;/*默认为 static*/
```
2. 绝对定位：相对于整个网页的位置，left 为盒子距网页左侧的距离，top 为盒子距网页顶部的距离。绝对布局有 absolute 和 fixed 两种
```CSS
position: absolute;
```
```CSS
position: fixed;
```
>absolute 和 fixed 区别：
>absolute: 相对于页面，会随着滚动条移动。
>fixed：相对于浏览器窗口，不受滚动条影响，一直显示在浏览器窗口中的固定位置。
3. 相对布局：相对于标准流定位的位置。
```CSS
position: relative;
```

<br/>
### 盒子浮动
设置 float 属性，可以设置子元素在父容器中浮动(分层)。
```CSS
float: left;/*左浮动，靠左一字排开*/
float: right;/*右浮动*/
```
CSS:
```CSS
#father div{
	float: left;
}
#father p{
	clear: both;/*清楚浮动*/
}
```
HTML:
```HTML
<div id="father">
	<div id="son1>son1</div>
	<div id="son2>son2</div>
	<div id="son3>son3</div>
	<p></p>
</div>
```