---
title: XML 解析
date: 2017-04-18 22:22:22
categories: Web 基础
tags: 
- 待完善
- XML
---

XML (Extenstion Markup Language 扩展性标记语言)，可以用来做资源配置文件(.properties, xml)、数据的传输格式(json, xml 数据)。

<!--more-->

## XML 语法

- 标签必须要闭合，不存在单标记
- 标签不能嵌套
- 标签名可以任意写

## XML 基本结构

**XML (1994) 只有一个版本 1.0**

```XML
<? xml version="1.0" encoding="utf-8" ?>
<根标记>
	<标记></标记>
</根标记>
```

## XML 的两种校验

用来约束 XML 文档的，规定 XML 中该写什么，不该写什么。
- dtd 校验：校验可以做一些基本校验
- schema 校验：做精确的校验

### dtd 校验

举例：user.xml 文件,规则：要求根标记为 users，users 下只能有 user 标签。
<users>
	
	<user id="必选" height="可选">
		<uname></uname>
		<upwd></upwd>
		<age></age>
		<sex></sex>
	</user>
</users>

创建 users.dtd 文件，

### schema 校验

<br/>
## XML 解析(CRUD)
用编程语言对 XML 进行操作

### dom 解析

dom 解析会将整个 XML 文档加载到内存中，形成 DOM 树。
- 优点：操作非常方便，对于数据存储比较小的 XML 有很大优势。
- 缺点：处理 XML 数据比较多的时候，性能不高。

### sax 解析

sax 解析以事件驱动的方式来解析文档
- 优点：适合处理 XML 数据比较多的时候，查询方便，效率高
- 缺点：操作麻烦，**不支持修改**

### dom4j (dom for java)

结合了 dom 解析和 sax 解析的优点
步骤：

1. 导入 jar 包（dom4j）

    ```
    org.dom4j.Document;
    ```
1. 获取一个 XML 解析器 SAXReader

    ```
    SAXReader sax = new SAXReader();
    ```
1. 读取 XML 文档

    ```Java
    Document doc = sax.read("文件名称.xm");
    //将 
    doc.asXML;
    //获取 XML 中写入的值（标签名）
    doc.getStringValue("标签名");
    //获取文档根节点
    Element root = doc.getRootElement();
    //根据 id 获取元素
    Element element = doc.elementByID("id");
    //获取元素标签名
    root.getName();
    //获取所有子元素
    List<Element> elements = root.elements();
    //获取指定元素
    root.element("元素名");
    //获取属性
    Attribute attr = element.attribute("属性名");
    //获取属性值
    attr.getData();
    //获取所有的属性
    element.attributes();
    //在根节点内添加元素
    Element element = root.addElement("元素名")
    //在元素中添加属性
    element.addAttribute("属性名","属性值");
    //在指定元素中添加元素值
    element.addElement("元素名").addText("元素之");
    //规范 XML 格式
    OutputFormat format = OutputFormat.creatPrettyPrint();
    format.setEncoding("utf-8");
    //将数据写入 XML 文档
    XMLWriter writer = new XMLWriter(new FileWriter("users.xml"), format);
    writer.write(doc);
    writer.close();
    ```