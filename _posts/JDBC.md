---
title: JDBC 编程
data: 2017-04-01 22:22:22
---


JDBC是什么

JDBC是访问数据库的解决方案，使用相同的方式访问不同的数据库，JDBC 定义了一套标准的接口，不同的数据库厂商根据自己的特点去实现，以达到不同的数据库厂商，通过Java 访问的方式是一致的。

## JDCB 提供的接口：

DriverManager		驱动管理
Connection			连接接口
Statement			语句对象接口
PreparedStatement	语句对象接口
ResultSet			结果集接口


## JDBC 工作原理
1. 加载驱动
导入包 Class.forName("com.mysql.jdbc.Driver");
2. 建立连接
获取连接 Connection conn = DriverManager.getConnection(url,username,password);
url = "jdbc:mysql://localhost:3306/数据库名"
>java.sql
3. 创建语句对象
Statement st = conn.createStatement();
>java.sql
针对不同类型的 SQL 语句有不同的执行方法
4. 执行 SQL 语句
boolean st.execute(sql);//该方法通常执行DDL语句，永远返回false...
int st.executeUpdate(sql);//该方法执行DML语句，返回影响行数
ResultSet rs = st.executeQuery(sql);//该方法执行DQL语句，查询出来的数据都封装在ResultSet中
5. 处理结果集
执行查询语句（DQL）后返回的结果集，由ResultSet接口接收。
查询的结果集存放在ResultSet对象中
ResultSet对象的最初位置在行首
ResultSet定义了一个方法next()，表示移动行间记录，读取到行尾返回false
getXXX(),该方法用于根据字段取出相应的内容。
while(re.next()) {//遍历结果集
	int id = rs.getInt("empno");
	String name = rs.getString("ename");
	...
}
6. 关闭连接
conn.close();