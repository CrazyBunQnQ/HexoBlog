---
title: MySQL 常用 sql
date: 2018-09-22 22:22:22
categories: 数据库
tags:
- MySQL
top: 7
---

记录一些不经常用但是需要的时候很有用的查询语句，不定期更新

<!-- more -->

## 查询信息

### 查询库名

```sql
select database();
```
## 常用操作

### 时间戳

MySQL 中没有产生微秒的函数，now() 只能精确到秒，也没有存储带有毫秒、微秒的日期时间类型。但是却有提取微妙的函数...

```sql
# 显示当前时间戳(秒)
select unix_timestamp(now());
# 提取时间中的微秒 123456
select microsecond('12:00:00.123456');
```

### 类型转换及字符串拼接

- 类型转换：`CAST(value AS TYPE)`
- 字符串拼接：`CONCAT(str1, str2, str3...)`

示例：两个数字拼接成分数

```sql
SELECT CONCAT(CAST(1 AS CHAR), '/', CAST(2 AS CHAR)) AS RATIO FROM DUAL;
```

结果：![](http://wx2.sinaimg.cn/large/a6e9cb00ly1fvez03wzojj204u028mxc.jpg)

### 重复记录

- 删除重复记录: 根据 t 表中的 a, b 字段删除 t 表中多余的重复记录

    ```sql
    delete from t where id not in (select id from
        (select min(id) as id from t group by a, b) as c);
    ```
    >必须要有 `select id from (...) as C`
- 查找重复记录: 根据 t 表中的 a, b 字段查找 t 表中多余的重复记录(不包含 rowid 最小的记录)

    ```sql
    select * from t
        where (a, b) in (select a, b from t group by a, b having count(id) > 1)
        and id not in (select min(id) from t group by a, b having count(id) > 1);
    ```

## 函数

```mysql
CREATE FUNCTION 函数名(参数 参数数据类型) RETURNS 返回数据类型
BEGIN
# 自定义变量
Declare 变量 数据类型;
# 赋值
Set 变量 = 参数 - 1;
  RETURN (
      # 查询语句，可以使用前面设置的变量或参数，但不能在此进行运算
      select DISTINCT Salary from Employee order by Salary DESC limit 变量, 1
  );
END
```

>在查询语句中不能直接写数学运算必须通过赋值来进行运算

### 数据类型

### 常用函数

#### 查询第 N 高的薪水

```mysql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
Declare M INT;
SET M = N - 1;
  RETURN (
      select distinct Salary from Employee order by Salary desc limit M, 1
  );
END
```

## 常见问题

### `limit m, n` 与 `limit m offset n` 区别

```mysql
select * from table limit m,n;                 
```
`limit m, n` 含义是跳过 m 条取出 n 条数据，limit 后面是从第 m 条开始读，读取 n 条信息，即从第 m + 1 条开始读取 n 条数据

```mysql
select * from table limit m offset n;
```
`limit m offset n` 含义是从第 n 条（不包括）数据开始取出 m 条数据，limit 后面跟的是 m 条数据，offset 后面是从第 n 条开始读取，即从 n+1 条开始读取 m 条数据