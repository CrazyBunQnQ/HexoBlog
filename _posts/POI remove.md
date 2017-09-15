---
title: POI 删除表格的坑
date: 2017-09-12 14:31:00
categories: API
tags: 
- Excel
- POI
---

最近项目需求有个导出 excel 表格功能，因为之后可能会有导出 .xlsx 新版表格的需求，所以用了 Apache POI。下面说说我删除表格的时候遇到的坑= =

<!--more-->

最开始我使用的是下面的代码，已知表格名字了，但是导出过程中这个表格中没有数据，所以需要把该表格删掉，所以就先获取名字，再根据名字删除表格。

```Java
String sheetName = sheet.getSheetName();
workbook.removeName(sheetName);
```

但是运行的时候却出现了 `java.lang.ArrayIndexOutOfBoundsException` 问题。
调试进入源码发现 removeName(String) 方法都是根据 workbook 对象的 names 属性删除的...
![源码](http://wx2.sinaimg.cn/mw690/a6e9cb00ly1fjgs8tsblfj20sm09kn5c.jpg)

而我的 workbook 对象 names 属性是 0。所以就出现了下标越界的问题。
![对象](http://wx1.sinaimg.cn/mw690/a6e9cb00gy1fjgsc930vnj20p20gyq5p.jpg)

好吧，既然这样无法删除我就试试根据下标删除总行了吧！
```Java
String sheetName = sheet.getSheetName();
int index = workbook.getSheetIndex(sheetName);
workbook.removeSheet(index);
```
然而事实告诉我 removeName(int) 方法也是根据 names 属性删除的...所以同样报了上面的那个错误。

这时又发现了 removeSheetAt(int) 方法，就试了下，可算是根据 sheets 属性来删除了。。。
代码如下：

```Java
String sheetName = sheet.getSheetName();
int index = workbook.getSheetIndex(sheetName);
workbook.removeSheetAt(index);
```

总结：
Workbook 对象删除表格的两个方法 removeName(String) 和 removeName(int) 都是根据 names 属性删除的呃，貌似根本不是用来删除表格的。。。。
removeSheetAt(int) 才是删除表格。。。。