---
title: MySQL 数据库
date: 2017-03-28 22:22:22
categories: 
- 数据库
tags: 
- MySQL
---

关系数据库
关系：描述两个元素间的关联或对应关系
使用关系模型吧数据库组织到二位数据表(Table)中
产品：
- Oracle——主流大型商业
- DB2
- Sybase
- SQL Server
- MySQL——主流小型开源

<!--more-->

## 表的概念
- 一个关系数据库由多个数据表组成，数据表是关系数据库的基本存储结构
- 表是二维的，由行和列组成
- 表的行是横排数据，也被称作记录(Record)
- 表的列是纵列数据，也被称作为字段(Field)
- 表和表之间存在关联关系

<br/>
## 结构化查询语言
- SQL是在关系数据库上执行数据操作、检索及维护所使用的标准语言，可以用来查询数据，操纵数据，定义数据，控制数据
- 所有数据库都是用相同或者相似的语言

SQL可分为：
- 数据定义语言(DDL)：Data Definition Language,用于建立修改删除数据库对象，包括 Creat、Alter、Drop
- 数据操纵语言(DML)：Data Manipulation Language，用于改变数据表中的数据，和事务相关，执行完后需要经过事务控制语句提交后才真正的将改变应用到数据库中，包括 Insert、Update，Delete
- 事物控制语言(TCL)：Transaction Control Language，用于维护数据一致性，包括 Commit、Rollback、Savepoint（保存点）
- 数据查询语言(DQL)：Data Query Language，用来查询所需要的数据，Select
- 数据控制语言(DCL)：Data Control Language，用于执行权限的手语和回收操作，包括 Grant、Revoke、Create User

<br/>
## MySQL基本数据类型

1. 数值类型
2. 字符串类型
3. 时间日期类型

### 数值类型
整数
浮点数

### 字符串类型
- 文本
- 二进制
- 字符串

### 时间日期类型
- 时间
- 日期

<br/>
## 创建表
创建表之前创建库，表依赖于库
1. 创建库：
```SQL
create database 数据库名
```
>这里的 database 是单数

2. 查看当前库：
```SQL
show databases
```
>这里的 database**s** 是复数

3. 使用某个库：
```SQL
use 数据库名
```
4. 查看当前库下所有表格：
```SQL
show tables
```
>table**s** 为复数

5. 删除库：
```SQL
drop database 数据库名
```
6. 创建表：
```SQL
create table 表名(
	字段名 数据类型 约束...,
	字段名 数据类型 约束...
);
```
7. 查看表结构：desc 表名

>`not null` 是一种约束条件，用于确保字段值不为空；
>默认情况下，任何列都允许有空值；
>当某个字段被设置了非空约束条件，这个字段中必须存在有效值。

<br/>
## 修改表
- 修改表名：

```SQL
alter table 旧表名 rename 新表名;
```
- 增加列：

```SQL
alter table 表名 add 字段名 数据类型;
```
- 删除列：

```SQL
alter table 表名 drop 字段名;
```
- 修改列：

```SQL
alter table 表名 change 旧字段名 新字段名 数据类型;
```
- 插入记录：

```SQL
insert into 表名（字段名1,字段名2,字段名3...) values (值1,值2,值3...);
```
- 插入完整记录：

```SQL
insert into 表名 values (值1,值2,值3...);
```
- 更新字段值：

```SQL
update 表名 set 字段值=值;
update 表名 set 字段名=值 where 字段名=值;
update 表名 set 字段名1=值1,字段名2=值2... where 字段名=值;
```

<br/>
## 查询表
- 查询所有列：

```SQL
select * from 表名;
```
- 查询当前时间：

```SQL
select now() from dual;
```
- 查询某字段名的值：

```SQL
select 列名1, 列名2... from 表名;
```
- 使用别名：

```SQL
select 列名1 as 别名1, 列名2 别名2, 列名3 as '别名3'... from 表名;
```
- 限定范围查询：

```SQL
select 列名... from 表名 where 条件;
```

>数据库默认字符集 utf-8，终端默认字符集 gbk

<br/>
## 删除
- 全删：

```SQL
delete from 表名
```
- 删除指定字段名的行：

```SQL
delete from 表名 where 字段名=值;
delete from 表名 where 字段名 is null;
```
>判断空的条件null 需要使用 is null
>可以使用 concat 拼接字符串
>例如，拼接 name 和 ':' 语句为：`select concat(name,':')`


## 添加 外键
alter table 表名 add constraint 约束名称 foreign key(字段名) references 表名(字段名)

## 分页查询
select * from 表名 limit 页数,条数
select * from emp limit 0,2;//查询第一页，每页两条

## 关联子查询
给定表：![表](http://wx1.sinaimg.cn/mw690/a6e9cb00ly1fgsyojg2euj207a0ei3z2.jpg) 写出 sql 语句查询出下面的结果：![结果](http://wx2.sinaimg.cn/mw690/a6e9cb00ly1fgsyojww7bj20au040wej.jpg)
```sql
SELECT nam, (SELECT COUNT(jieguo) FROM table1 WHERE nam=t1.nam AND jieguo='win') win_num, (SELECT COUNT(jieguo) FROM table1 WHERE nam=t1.nam AND jieguo='lost') lost_num FROM table1 t1 GROUP BY nam ;
```