---
title: JDBC 编程
date: 2017-04-01 22:22:22
categories: 
- Java 基础
- 数据库编程
tags: 
- JDBC
- 数据库
- MySQL
---

JDBC 是访问数据库的解决方案，使用相同的方式访问不同的数据库，JDBC 定义了一套标准的接口，不同的数据库厂商根据自己的特点去实现，以达到不同的数据库厂商，通过 Java 访问的方式是一致的。

<!--more-->

## JDCB 提供的接口：

DriverManager		驱动管理
Connection			连接接口
Statement			语句对象接口
PreparedStatement	语句对象接口
ResultSet			结果集接口

<br/>
## JDBC 工作原理
1. 加载驱动
导入包 `Class.forName("com.mysql.jdbc.Driver");`
2. 建立连接
获取连接:
```Java
Connection conn = DriverManager.getConnection(url,username,password);
url = "jdbc:mysql://localhost:3306/数据库名"
```
> Connection 在 `java.sql` 包下

3. 创建语句对象
```Java
Statement st = conn.createStatement();
```
>Statement 在 `java.sql` 包下
>Statement 类针对不同类型的 SQL 语句有不同的执行方法

4. 执行 SQL 语句
```Java
boolean st.execute(sql);//该方法通常执行 DDL 语句，永远返回 false ...
int st.executeUpdate(sql);//该方法执行 DML 语句，返回影响行数
ResultSet rs = st.executeQuery(sql);//该方法执行 DQL 语句，查询出来的数据都封装在 ResultSet 中
```
5. 处理结果集
执行查询语句（DQL）后返回的结果集，由 ResultSet 接口接收。
查询的结果集存放在 ResultSet 对象中
ResultSet 对象的最初位置在行首
ResultSet 定义了一个方法 next()，表示移动行间记录，读取到行尾返回 false
getXXX(),该方法用于根据字段取出相应的内容。
```Java
while(re.next()) {//遍历结果集
	int id = rs.getInt("empno");
	String name = rs.getString("ename");
	...
}
```
6. 关闭连接
```Java
conn.close();
```

<br/>
### Statement 与 PreparedStatement 的区别
#### Statement 语句对象
1. 需要将动态的数据拼接到 SQL 语句中，这样导致程序复杂度高，容易出错。
2. Statement 每执行一次都要对传入的 SQL 语句进行预编译一次，效率极差。会对不同的 SQL 语句会进行不同的制定两次执行计划。
3. 一般只用于静态的 SQL 语句，及内容不变的语句
4. 拼接 SQL 语句导致 SQL 语句寒意发生改变，而导致 SQL 注入问题

#### PreparedStatement 语句对象：
1. PreparedStatement 接口是 Statement 的子接口
2. PreparedStatement 有提前 SQL 语句预编译功能。
3. 一般用于执行动态 SQL 语句，可维护性高，性能稍快。
4. 能有效防止 SQL 注入

>PreparedStatement 更改了 Statement 接口中定义的方法
>创建 PreparedStatement 语句对象时，传入 SQL 语句，其中 ？代表占位符。
>调用 PreparedStatement 语句对象的 execute()、executeUpdate 和 executeQuery() 方法都不需要传入 sql 语句

<br/>
## 事务
事务就是对一系列的数据库操作（比如增删改）进行统一的回滚或提交，如果插入成功，那么一起成功，如果中间有任何异常，那么就回滚之前所有的操作。这样可以防止出现脏数据，防止数据库出现错误。

### 事务的特性（ACID）：
1. 原子性：事务是一个不可分割的工作单位，事务的原子性确保动作全部完成或全部失败。
2. 一致性：一旦所有的事务动作完成，事务就被提交。数据和资源就存储于一种满足业务规则的一致性状态中
3. 隔离性：一个事务的执行不能被其他事务干扰。可能有许多事务会同时处理相同的数据，因此每个事务都应该与其他事务进行隔离开来，防止数据损坏，出现异常
4. 持久性：事务一旦提交，他对数据库中数据的改变是永久的，无论发生什么系统错误，他的结果都不应该受到影响

## JDBC 管理事务常用 API
### boolean getAutoCommit()
**throws SQLException**
此方法获取此 Connection 对象的当前自动提交模式。 

**返回：**
此 Connection 对象的自动提交模式的当前状态 


### void setAutoCommit(boolean autoCommit)
**throws SQLException**
该方法将此连接的自动提交模式设置为给定状态。如果连接处于自动提交模式下，则它的所有 SQL 语句将被执行并作为单个事务提交。否则，它的 SQL 语句将聚集到事务中，直到调用 commit 方法或 rollback 方法为止。默认情况下，新连接处于自动提交模式。 
提交发生在语句完成时。语句完成的时间取决于 SQL 语句的类型：
- 对于 DML 语句（比如 Insert、Update 或 Delete）和 DDL 语句，语句在执行完毕时完成。 
- 对于 Select 语句，语句在关联结果集关闭时完成。 
- 对于 CallableStatement 对象或者返回多个结果的语句，语句在所有关联结果集关闭并且已获得所有更新计数和输出参数时完成。 
>注：如果在事务和自动提交模式更改期间调用此方法，则提交该事务。如果调用 setAutoCommit 而自动提交模式未更改，则该调用无操作（no-op）。 

**参数：**
- autoCommit - 为 true 表示启用自动提交模式；为 false 表示禁用自动提交模式 


### void commit()
**throws SQLException**
使所有上一次提交/回滚后进行的更改成为持久更改，并释放此 Connection 对象当前持有的所有数据库锁。此方法只应该在已禁用自动提交模式时使用。 

### void rollback()
**throws SQLException**
取消在当前事务中进行的所有更改，并释放此 Connection 对象当前持有的所有数据库锁。此方法只应该在已禁用自动提交模式时使用。 

<br/>
## DAO
一个完整的项目一般分为**控制层、业务逻辑层、数据访问层、视图层。**

DAO 就是数据访问层，其目的是让业务层逻辑和数据进行分开。在应用程序中，业务逻辑层需要和数据进行交互，直接访问 Dao 不涉及任何数据库的具体操作

### 实现 DAO 的步骤
1. 编写 Dao 工具类（DBUtil 工具类）
2. 一个 Dao 接口（定义了引用程序中用到的方法）
3. 一个实现 Dao 接口的具体类（实现接口中所有对应的方法，和数据库进行直接交互。）
4. 数据传递对象（实体类）


### 实体类对象：
对象关系映射，描述对象和数据表中之间的映射。将 Java 程序中的对象对应到数据库表中，一个实体对象对应数据表中一条记录

**实体类编写**
1. 表名称和类名称对应
2. 表中的字段和类的属性对应
3. 遵循 Java Bean 规范（包含无参构造器、get、set、tostring ）