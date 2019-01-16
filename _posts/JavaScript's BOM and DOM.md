---
title: JavaScript 之 BOM 和 DOM 对象
date: 2017-04-14 22:22:22
categories: Web 基础
tags: 
- BOM
- DOM
- JavaScript
---

- [BOM：浏览器窗口对象](/2017/04/14/BOM 和 DOM/#HTML BOM 对象)
- [DOM：文档对象](/2017/04/14/BOM 和 DOM/#HTML DOM 对象)

<!--more-->

## HTML BOM 对象
- [Window 对象](http://www.w3school.com.cn/jsref/dom_obj_window.asp)
Window 对象表示浏览器中打开的窗口。
如果文档包含框架（frame 或 iframe 标签），浏览器会为 HTML 文档创建一个 window 对象，并为每个框架创建一个额外的 window 对象。
>直接在 `<script>` 标签下设置的全局变量，都属于 window 对象。
>反过来，调用 window 对象可以直接使用 `对象名` 而不需要使用 `window.对象名`。
- **[Navigator 对象](http://www.w3school.com.cn/jsref/dom_obj_navigator.asp)**
Navigator 对象包含有关浏览器的信息。
- **[Screen 对象](http://www.w3school.com.cn/jsref/dom_obj_screen.asp)**
Screen 对象包含有关客户端显示屏幕的信息。
- **[History 对象](http://www.w3school.com.cn/jsref/dom_obj_history.asp)**
History 对象包含用户（在浏览器窗口中）访问过的 URL。
>History 对象是 Window 对象的一部分，可通过 `window.history` 属性对其进行访问。
- **[Location 对象](http://www.w3school.com.cn/jsref/dom_obj_location.asp)**
Location 对象包含有关当前 URL 的信息。
>Location 对象也是 Window 对象的一个部分，可通过 `window.location` 属性来访问。

<br/>
## HTML DOM 对象
- **[Document 对象](http://www.w3school.com.cn/jsref/dom_obj_document.asp)**
每个载入浏览器的 HTML 文档都会成为 Document 对象。
Document 对象使我们可以从脚本中对 HTML 页面中的所有元素进行访问。
>Document 对象是 Window 对象的一部分，可通过 `window.document` 属性对其进行访问。
- **[Element 对象](http://www.w3school.com.cn/jsref/dom_obj_all.asp)**
在 HTML DOM 中，Element 对象表示 HTML 元素。
Element 对象可以拥有类型为元素节点、文本节点、注释节点的子节点。
NodeList 对象表示节点列表，比如 HTML 元素的子节点集合。
元素也可以拥有属性。属性(Attribute)是属性节点。
>在 HTML DOM （文档对象模型）中，每个部分都是 **DOM 节点**：
	- 文档本身是文档节点
	- 所有 HTML 元素是元素节点
	- 所有 HTML 属性是属性节点
	- HTML 元素内的文本是文本节点
	- 注释是注释节点
- **[Attribute 对象](http://www.w3school.com.cn/jsref/dom_obj_attributes.asp)**
	- Attr 对象
	在 HTML DOM 中，**Attr** 对象表示 HTML 属性。
	HTML 属性始终属于 HTML 元素。
	- NamedNodeMap 对象
	在 HTML DOM 中，**NamedNodeMap** 对象表示元素属性节点的无序集合。
	NamedNodeMap 中的节点可通过名称或索引（数字）来访问。
- **[Event 对象](http://www.w3school.com.cn/jsref/dom_obj_event.asp)**
Event 对象代表事件的状态，比如事件在其中发生的元素、键盘按键的状态、鼠标的位置、鼠标按钮的状态。
事件通常与函数结合使用，函数不会在事件发生前被执行！