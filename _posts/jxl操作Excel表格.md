---
title: 操作 Excel 表格（jxl）
date: 2017-5-11 9:09:30 
categories: 触类旁通
tags:
- Excel
- jxl
- 表格
---

```Java
//创建 WorkBook 对象 Excel 文件
WritableWorkbook workBook = Workbook.createWrokbook(new File("..."));
//创建工作表
WritableSheet sheet = workBook.createSheet("aaa");//新创建一个名为 aaa 的工作表
WritableSheet sheet = workBook.createSheet("aaa",0);//为第一个工作表命名为 aaa
//向第 1 列第 2 行（就是坐标）添加数据
sheet.addCell(new Lable(0, 1, "序号"));//在(0,1)坐标的格子添加“序号”
sheet.addCell(new Lable(1, 1, "姓名"));//在(1,1)坐标的格子添加“姓名”
//将数据写入到 Excel 表格中
workBook.write();
//关闭
workBook.close();
```