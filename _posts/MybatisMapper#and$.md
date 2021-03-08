---
title: MyBatis mapper 文件中 $ 和 # 的区别
date: 2021-02-22 22:22:22
img: "/images/Mybatis1.jpeg"
cover: fasle
coverImg: "/images/Mybatis1.jpeg"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: Java
tags:
- 框架
- 数据库
- MyBatis
keywords: MyBatis
summary: 平时查日志很喜欢用正则表达式, 写习惯了结果前几天写 mapper.xml 文件时在 SQL 中手误把 `#` 写成了 `$`, 结果运行的时候报错了, 导致半天没看出来哪错了...找到原因之后很无语, SQL 看了半天都没觉着那有问题, 哈哈哈哈, 这下长记性了
---

一般来说，我们使用 `MyBatis Generator` 来生成 `mapper.xml` 文件时，会生成一些增删改查的文件.

这些文件中需要传入一些参数，传参数的时候，我们会注意到，参数的大括号外面，有两种符号，一种是 `#`，一种是 `$`

这两种符号有什么区别呢？

```mysql
SELECT * FROM huobi_unsold_transaction WHERE client_order_id = #{item.clientOrderOd};

SELECT * FROM huobi_unsold_transaction ORDER BY ${column} desc;
```

从上面的内容我们可以比较清楚的看到

`#{}` 用于传递查询的参数. 一般用于从 `dao` 层传递一个 `string` 或者其他的参数过来, MyBatis 对这个参数会进行加引号等类型转换操作, 将参数转变为一个字符串或其他类型

比如, 这边我们想根据 `clientOrderOd` 查询某次交易的信息, 我们会从 `dao` 传一个参数，比如传 `A-FAST-2154204150680` 进来，MyBatis 生成对应的 SQL 为:

```mysql
SELECT * FROM huobi_unsold_transaction WHERE client_order_id = 'A-FAST-2154204150680';
```

而 `$` 则不同，我们一般用于 `order by` 的后面

此时 MyBatis 对这个参数不会进行任何的处理, 直接生成 SQL 语句

例如, 此处我们传入 `create_time` 作为参数，传入第二个 SQL 中

此时，MyBatis 生成的 SQL 语句为:

```mysql
SELECT * FROM huobi_unsold_transaction ORDER BY create_time desc;
```

可以看到, MyBatis 对其没有做任何的处理。

但是，我们一般推荐使用的是 `#{}`, 不使用 `${}` 的原因如下:

- `${}` 会引起 SQL 注入, 因为 `${}` 会直接参与 SQL 编译
- 会影响 SQL 语句的预编译, 因为 `${}` 仅仅为一个纯碎的 `string` 替换, 在动态 SQL 解析阶段将会进行变量替换

正是这个比较小的知识点, 导致我的弱智交易程序损失了好几块钱...所以记录在此...
