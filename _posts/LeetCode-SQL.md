---
title: SQL 练习
date: 2017-07-07 22:22:22
categories: 数据库
tags: 
- SQL
---

空闲时间刷刷[数据库的面试题](https://leetcode.com/problemset/database/)，用实践来学习/提高自己优化数据库的能力～

<!--more-->

## 交换性别
Given a table `salary`, such as the one below, that has m=male and f=female values. Swap all f and m values (i.e., change all f values to m and vice versa) with a single update query and no intermediate temp table.

给定一个数据表 `salary`，表格如下，该表格中，m 代表男，f 代表女。使用一条 update 语句交换所有 f 和 m 的值（将所有 f 的值改成 m，反之亦然），并且没有中间临时表。

For example（例如）:

| id | name | sex | salary |
|:--:|:----:|:---:|--------|
| 1  | A    | m   | 2500   |
| 2  | B    | f   | 1500   |
| 3  | C    | m   | 5500   |
| 4  | D    | f   | 500    |

After running your query, the above salary table should have the following rows:

运行完你的查询语句后，上面的数据表应该变为下面这样：

| id | name | sex | salary |
|----|------|-----|--------|
| 1  | A    | f   | 2500   |
| 2  | B    | m   | 1500   |
| 3  | C    | f   | 5500   |
| 4  | D    | m   | 500    |

### 查询语句 1
```SQL
UPDATE salary SET sex=(CASE WHEN sex='m' THEN 'f' ELSE 'm' END);
```
该语句简单明了，容易理解，其中

```SQL
CASE WHEN 条件 THEN 真 ELSE 假 END
```
等价于 Java 中的
```Java
if () {
	...
} else {
	...
}
```

这里不再赘述。

### 查询语句 2
```SQL
UPDATE salary SET sex = CHAR(ASCII('f') ^ ASCII('m') ^ ASCII(sex));
```

>ASCII(str)
>返回字符串 str 的最左面字符的 ASCII 代码值。
>如果 str 是空字符串，返回 0。如果 str 是 NULL，返回 NULL。

该语句使用了**异或运算**，先计算 f 和 m 的异或值，然后用其结果再与数据表中的每个 sex 值计算异或值，结果则为 sex 的反值。例如：

```Java
int f = 'f';//102
int m = 'm';//109
System.out.println(Integer.toBinaryString(f));//1100110
System.out.println(Integer.toBinaryString(m));//1101101
int r = f ^ m;
int r = f ^ m;
System.out.println(Integer.toBinaryString(r));//0001011

int sex;
sex = 'f';
System.out.println(Integer.toBinaryString(r ^ sex));//1101101
sex = 'm';
System.out.println(Integer.toBinaryString(r ^ sex));//1100110
```

>异或运算：两个操作数的位中，相同则结果为 0，不同则结果为 1。

<br/>
## 结合两个表
Table: `Person`

| Column Name | Type    |
|-------------|---------|
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
PersonId is the primary key column for this table.
PersonId 是这张表的主键。

Table: `Address`

| Column Name | Type    |
|-------------|---------|
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
AddressId is the primary key column for this table.
AddressId 是这张表的主键。

Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:

写一个数据库语句，无论每个人是否有地址，查询结果都要提供 `Person` 表中每个人的以下信息：

FirstName, LastName, City, State

### 查询语句
```SQL
SELECT FirstName, LastName, City, State FROM Person p LEFT JOIN Address a ON p.PersonId = a.PersonId;
```

<br/>
## Employees Earning More Than Their Managers
The `Employee` table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

数据库表 `Employee` 包括所有员工以及他们的经理。每个员工都有一个 Id 以及一个经理 Id。

| Id | Name  | Salary | ManagerId |
|:--:|:-----:|:------:|:---------:|
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
Given the `Employee` table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

给定数据表 `Employee`，写一个 SQL 语句，找出哪些员工的收入高于他们的经理。例如上面的表格中只有 Joe 的收入高于他的经理。

| Employee |
|:--------:|
| Joe      |

### 查询语句 1
```SQL
SELECT e.Name Employee FROM Employee e WHERE e.Salary > (SELECT salary FROM Employee c WHERE c.Id = e.ManagerId);
```

### 查询语句 2
```SQL
select E1.Name Employee
from Employee as E1, Employee as E2
where E1.ManagerId = E2.Id and E1.Salary > E2.Salary;
```

### 查询语句 3
```SQL
select a.Name Employee
from Employee a inner join Employee b on a.ManagerId=b.Id
where a.Salary>b.Salary
```