---
title: Some Important Points for Oracle 
date: 2017-08-18 22:22:22
categories: 数据库
tags: 
- Oracle
---

公司使用的是 oracle 数据库，还不太熟悉，所以整理一些 Oracle 数据库的要点，方便用到时查询。

1. [SQL 简介]()
2. [SQL 操作服]()
3. [Oracle 常用数据类型]()
4. [Oracle 函数]()
5. [Oracle 常用语法]()

<!--more-->

## SQL 简介
**SQL（Structured Query Language，结构化查询语言）支持如下几个类别：**

- [数据定义语言 (DDL)]()：<font color="blue">CREATE</font>（创建）、<font color="blue">ALTER</font>（更改）、<font color="blue">TRUNCATE</font>（截断）、<font color="blue">DROP</font>（删除）命令。
- [数据操纵语言 (DML)]()：<font color="blue">INSERT</font>（插入）、<font color="blue">SELECT</font>（选择）、<font color="blue">DELETE</font>（删除）、<font color="blue">UPDATE</font>（修改）命令。
- [事务控制语言]()：<font color="blue">COMMIT</font>（提交）、<font color="blue">SAVEPOINT</font>（保存点）、ROLLBACK（回滚）命令。
- [数据控制语言]()：<font color="blue">GRANT</font>（授予）、<font color="blue">REVOKE</font>（回收）命令。

>特点
>
1. 非过程语言，它同时可以访问多条记录。
2. 所有关系型数据库的通用型语言，可移植性强。
3. 对于数据和对象的操作简单。


### 数据定义语言
用于改变数据库结构，包括创建、修改和删除数据库对象。

#### 1、CREATE TABLE 创建表
创建表, 索引, 视图, 同义词, 过程, 函数, 数据库链接等

```SQL
CREATE TABLE [schema.]table
(columname    datetype [, .]);
```

- 表名的最大长度为 30 个字符；
- 表名首字母为字母，可以用下划线、数字和字母，但不能使用空格和单引号；
- 同一用户模式下的不同表不能有相同的名称；
- 表名、列名、用户名、和其他对象名不区分大小写，系统会自动转换成大写。

ORACLE 常用的字段类型有
CHAR            固定长度的字符串
VARCHAR2        可变长度的字符串
NUMBER(M,N)        数字型 M 是位数总长度, N 是小数的长度
DATE            日期类型

创建表时要把较小的不为空的字段放在前面, 可能为空的字段放在后面

创建表时可以用中文的字段名, 但最好还是用英文的字段名

创建表时可以给字段加上默认值, 例如 DEFAULT SYSDATE
这样每次插入和修改时, 不用程序操作这个字段都能得到动作的时间

创建表时可以给字段加上约束条件
例如 不允许重复 UNIQUE, 关键字 PRIMARY KEY

#### 2、ALTER TABLE 修改表
改变表, 索引, 视图等

```SLQ
ALTER TABLE <tablename>
    MODIFY (column definition);
    ADD (column definition);
    DROP COLUMN column;
```

改变表的名称
ALTER TABLE 表名 1  TO 表名 2;

在表的后面增加一个字段
ALTER TABLE 表名 ADD 字段名 字段名描述;

修改表里字段的定义描述
ALTER TABLE 表名 MODIFY 字段名 字段名描述;

给表里的字段加上约束条件
ALTER TABLE 表名 ADD CONSTRAINT 约束名 PRIMARY KEY (字段名);
ALTER TABLE 表名 ADD CONSTRAINT 约束名 UNIQUE (字段名);

把表放在或取出数据库的内存区
ALTER TABLE 表名 CACHE;
ALTER TABLE 表名 NOCACHE;

#### 3、TRUNCATE TABLE 截取表
清空表里的所有记录, 保留表的结构
```SQL
TRUNCATE TABLE <tablename>；
```
快速删除记录并释放空间，不使用事务处理，无法回滚，效率高。

DESC <tablename>  查看表结构

#### 4、DROP TABLE 删除表
```SQL
DROP TABLE <tablename>
```

删除表和它所有的约束条件
DROP TABLE 表名 CASCADE CONSTRAINTS;

### 数据操纵语言
#### 1.INSERT  (往数据表里插入记录的语句)
```SQL
INSERT INTO 表名(字段名 1, 字段名 2, ……) VALUES ( 值 1, 值 2, ……);
INSERT INTO 表名(字段名 1, 字段名 2, ……)  SELECT 字段名 1, 字段名 2, …… FROM 另外的表名;
````

字符串类型的字段值必须用单引号括起来, 例如: ’GOOD DAY’
如果字段值里包含单引号’ 需要进行字符串转换, 我们把它替换成两个单引号''. 
字符串类型的字段值超过定义的长度会出错, 最好在插入前进行长度校验.

日期字段的字段值可以用当前数据库的系统时间 SYSDATE, 精确到秒
或者用字符串转换成日期型函数 TO_DATE(‘2001-08-01’,’YYYY-MM-DD’)
TO_DATE()还有很多种日期格式, 可以参看 ORACLE DOC.
年-月-日 小时:分钟:秒 的格式 YYYY-MM-DD HH24:MI:SS

INSERT 时最大可操作的字符串长度小于等于 4000 个单字节, 如果要插入更长的字符串, 请考虑字段用 CLOB 类型,
方法借用 ORACLE 里自带的 DBMS_LOB 程序包.

INSERT 时如果要用到从 1 开始自动增长的序列号, 应该先建立一个序列号
```SQL
CREATE SEQUENCE 序列号的名称 (最好是表名+序列号标记) INCREMENT BY 1  START  WITH  1 
MAXVALUE  99999  CYCLE  NOCACHE;
```
其中最大的值按字段的长度来定, 如果定义的自动增长的序列号 NUMBER(6) , 最大值为 999999
INSERT 语句插入这个字段值为: 序列号的名称.NEXTVAL

------------------------------------------------------------------
#### 2.DELETE  (删除数据表里记录的语句)
```SQL
DELETE FROM 表名 WHERE 条件;
```

注意：删除记录并不能释放 ORACLE 里被占用的数据块表空间. 它只把那些被删除的数据块标成 unused.

如果确实要删除一个大表里的全部记录, 可以用 TRUNCATE 命令, 它可以释放占用的数据块表空间
TRUNCATE TABLE 表名; 
此操作不可回退.

------------------------------------------------------------------
#### 3.UPDATE  (修改数据表里记录的语句)
```SQL
UPDATE 表名 SET 字段名 1=值 1, 字段名 2=值 2, …… WHERE 条件;
```

如果修改的值 N 没有赋值或定义时, 将把原来的记录内容清为 NULL, 最好在修改前进行非空校验;
值 N 超过定义的长度会出错, 最好在插入前进行长度校验..

------------------------------------------------------------------
注意事项: 
A.    以上 SQL 语句对表都加上了行级锁,
    确认完成后, 必须加上事物处理结束的命令 COMMIT 才能正式生效, 
    否则改变不一定写入数据库里.    
    如果想撤回这些操作, 可以用命令 ROLLBACK 复原.
    
B.    在运行 INSERT, DELETE 和 UPDATE 语句前最好估算一下可能操作的记录范围,
    应该把它限定在较小 (一万条记录) 范围内,. 否则 ORACLE 处理这个事物用到很大的回退段.
    程序响应慢甚至失去响应. 如果记录数上十万以上这些操作, 可以把这些 SQL 语句分段分次完成,
    其间加上 COMMIT 确认事物处理.

<font color="blue">DISTINCT</font> 防止选择重复的行



### 事务控制语言
<font color="blue">COMMIT</font>  提交并结束事务处理。
<font color="blue">SAVEPOINT</font>  保存点，将很长的事务处理划分为较小的部分，用于标记事务中可以应用回滚的点。
<font color="blue">ROLLBACK</font>  用来撤销在当前的事务中已完成的操作。可以回滚整个事务处理；也可以将事务回滚到某个保存点。
```SQL
UPDATE xxx;
 SAVEPOINT mark1;
DELETE FROM xxx;
 SAVEPOINT mark2;
 ROLLBACK TO SAVEPOINT mark1;
 COMMIT;
 ```



### 数据控制语言
为用户提供权限控制命令。

**授予对象权限:**
```SQL
GRANT SELECT,UPDATE  ON   order_master
  TO MARTIN;
```

**取消对象权限**
```SQL
REVOKE SELECT,UPDATE  ON  order_master
  FROM MARTIN;
```
  
</br>
## SQL 操作符

### 算术操作符
算术表达式有 NUMBER 数据类型的列名、数值常量和连接它们的算术操作符组成。（+ - * /）


### 比较操作符
用于比较两个表达式的值。

- =、!=、<、>、<=、>=、BETWEEN……AND（检查是否在两个值之间）
- [NOT] IN（与列表中的值匹配）
- [NOT] LIKE（匹配字符模式，* _ 通配符）
- [NOT] IS NULL（检查是否为空）

### 逻辑操作符
用于组合生成一个真或假的结果。AND OR NOT

### 集合操作符
集合操作符将两个查询的结果组合成一个结果集合。

- UNION（联合）：返回两个查询选定不重复的行。(删除重复的行)
- UNION ALL（联合所有）：合并两个查询选定的所有行，包括重复的行。
- INTERSECT（交集）：只返回两个查询都有的行。
- MINUS（减集）：在第一个查询结果中排除第二个查询结果中出现的行。（第一减第二）


使用集合操作符连接起来的 SELECT 语句中的列应遵循以下规则：
- 通过集合操作连接的各个查询相同列数，匹配列的数据类型；
- 这种查询不应含有 LONG 类型的列；
- 列标题来自第一个 SELECT 语句。

```SQL
SELECT orderno FROM order_master
  UNION 
SELECT orderno FROM order_detail;
```

### 连接操作符 （||）
用于将两个或者多个字符串合并成一个字符串，或者将一个字符串与一个数值合并在一起。
```SQL
SELECT ('供应商'|| venname || '的地址是' || venaddress)
  FROM vendor_master
```

## Oracle 常用数据类型

### 1、字符数据类型
CHAR        固定长度字符串        长度 1～2000 个字节，未指定则默认为 1 字节
VARCHAR2    可变长度字符串        长度 1～4000 个字节，定义时必须指定大小
LONG        可变长度字符串        最多能存储 2GB，存储超过 VARCHAR2 的长文本信息
                    ps.一个表中只有一列为 LONG 数据类型，
                      .LONG 列不能建立索引，
                      .存储过程不能接受 LONG 数据类型的参数


### 2、数值数据类型
NUMBER 数据类型可以存储 正数、负数、零、定点数(不带小数点的？)和精度为 38 为的浮点数。
格式： NUMBER [(precision 精度，数字总位数 1～38 间
        , scale 范围，小数点右边的位数 -84～127 间)]


### 3、时期时间数据类型
DATE 数据类型，用于存储表中日期和时间数据。SYSDATE 函数功能就是返回当前的日期和时间。
TIMESTAMP 数据类型，存储时期、时间和时区信息。SYSTIMEATAMP 功能就是返回当前日期、时间和时区。


### 4、二进制数据类型
RAW        二进制数据或字节串    长度 1～2000 字节，定义时应指定大小，可建索引
LONG RAW     可变长度的二进制数据    最大能存储 2GB，限制等同于 LONG 数据类型


### 5、LOB 数据类型
“大对象”数据类型，最多可存储多达 4GB 的信息。LOB 可以是外部的，也可以是内部的，取决于相对于数据库位置。
CLOB        Character LOB        存储大量的字符数据
BLOB        Binary LOB        存储大量的二进制对象（多媒体对象等）
BFILE        Binary FIle        能够将二进制文件存储在数据库外部的操作系统文件中
                    BFILE 存储一个 BFILE 定位器，它指向位于服务器文件系统上的二进制文件。
ps.一个表中可以有多个 LOB 列，每个 LOB 列可以是不同的 LOB 类型。



### 6、伪列
Oracle 中的一个表列，但实际上未存储表中。可以从表中查询，但是不能插入，更新或者删除。

ROWID     返回行记录的行地址，通常情况下，ROWID 值可以唯一地标识数据库中的一行。
作用：    .能最快形式访问表中的一行。
    .能显示表中的行是如何存储的。
    .可以作为表中行的唯一标识。
例：SELECT ROWID, * FROM EMP  WHERE empno='7900';


ROWNUM    返回一个数值单表行的次序，第一行为 1，第二行为 2......
    通过使用 ROWNUM 用户可以限制查询返回的行数(或者分页？)
例：SELECT * FROM EMP WHERE ROWNUM <= 10;

## Oracle 函数
    函数接受一个或多个参数并返回一个值。

单行函数
    也称标量函数，对于从表中查询的每一行，该函数都返回一个值。
    单行函数出现在 SLEECT / WHERE 子句中。

### 1、日期函数
    对日期值进行运算，根据用途产生日期/数值类型的结果。
ADD_MONTHS(d, n)    返回 指定日期加上月数后的 日期值
MONTHS_BETWEEN(d1, d2)    返回 两个日期间的 月数
LAST_DAY(d)        返回 指定日期当前的最后一天的 日期值
RONUD(d,[fmt])        返回 指定日期四舍五入格式(YEAR、MONTH、DAY)后的 日期值
NEXT_DAY(d,day)        返回 指定日期下一个星期几的 日期值
TRUNC(d,[fnt])        返回 指定日期截断为格式后的 日期值
EXTRACT(fmt FROM d)    返回 指定日期提取的格式的 值 


### 2、字符函数
    字符函数接受字符输入，并返回字符或数值。
INITCAP(char)        首字母大写
LOWER(char)        转换为小写
UPPER(char)        转换为大写
LTRIM(char, set)    左裁切
RTRIM(char, set)    右裁切
TRANSLATE(char, from, to)        按字母翻译
REPLACE(char, search_str, replace_str)    字符串替换
INSTR(char, substr[,pos])        查找子串位置
SUBSTR(char, pos, len)            取子字符串
CONCAT(char1, char2)            连接字符串

CHR(ascii)        根据 ASCII 码返回对应字符串
LPAD / RPAD        左 / 右 填充
    LPAD ('function', 15 , '=') 返回    '=======function'
TRAM            开头或结尾(或 开头和结尾)裁剪特定的字符，默认裁剪空格。
    TRIM ([LEADING | TRAILING] trim_char)
LENGTH(char)        返回字符串长度
DECODE            逐个值进行字符串替换
    DECODE (expr, search1, result1, search2, result2, [ ,default])
    DECODE (ostalus, 'p', '准备处理', 'c', '已完成')



### 3、数字函数
    数字函数接受数字输入并返回数值作为输出结果。
ABS(n)        取绝对值
CEIL(n)        向上取值
FLOOR(n)    向下去整
SIN(n)        正弦值
COS(n)        余弦值
POWER(m, n)    指数函数
SQRT(n)        平方根
MOD(m, n)    取余
ROUND(m, n)    小数点后精度四舍五入
TRUNC(m, n)    小数点后精度截断


### 4、转换函数
    转换函数将一种数据类型转换为另一种数据类型。
TO_CHAR (d|n, [,fmt])        格式化 日期 / 数值
TO_DATE (char [,fmt])        将 fmt 模型格式的字符串 转换为日期型
TO_NUMBER (char)        将 包含数字的的字符串转换为 数值型


### 5、其他函数
NVL (exp, exp2)        如果 exp 为空返回 exp2；如果非空返回 exp
NVL2 (exp, exp2, exp3)    如果 exp 为空返回 exp3；如果非空返回 exp2
NULLIF (exp1, exp2)    比较两表达式，相等返回空值，不等则返回 exp1

### 分组函数 / 聚合函数
    分组函数基于一组行返回结果，即为每一组行返回单个值。

AVG (columname)         返回指定列的平均值
MAX (columname)         返回指定列的最大值
MIN (columname)         返回指定列的最小值
SUM (columname)         返回指定列的总值
COUNT    
    COUNT (*)        统计所有行个数，包括重复行和空值得行
    COUNT (columname)    统计指定列非空值的个行数
    COUNT (DISTINCR columname)    统计指定列中 非重复，非空值得行个数    


GROUP BY 子句
    用于将信息表划分为组，对查询结果按组进行聚合运算，为每组返回一个结果。
HAVING 子句
    用来指定 GROUP BY 子句的检索条件。

### 分析函数
    分析函数根据一组行来计算聚合值。这些函数通常用来完成对聚集的累积排名、移动平均数和报表计算。
    分析函数与聚合函数不同的是他们为每组记录返回多个行。

ROW_NUMBER () OVER ([PARTITION BY colum] ORDER BY colum)
    为有序组中的每一行返回一个唯一的排序值，序号由 ORDER BY 子句指定，从 1 开始，即使具有相等的值，排位也不同。
    PARTITION BY colum 按列值进行区分，各分组内在进行排序。

RANK () OVER ([PARTITION BY colum] ORDER BY colum)
    计算一个值在一个组中的地位，由 1 开头，具有相等值得行排位相同，序数随后跳跃相应的数值。

DENSE_RANK () OVER ([PARTITION BY colum] ORDER BY colum)
    计算一个值在一个组中的地位，由 1 开头，具有相等值得行排位相同，并且排位是连续的。







字符串函数
LENGTH()    字符长度
LENTTHB()    字节长度；一个汉字内存中占用 2 字节

LTRIM、RTRIM、TRIM

截串
SUBSTR(表达式，位置，长度)
Oracle 无左右取串函数，但可以使用变通方式完成。
左取串：    SUBSTR('abcdefg', 1, 3)
右取串：    SUBSTR('abcedfg', LENGTH('abcdefg')-3+1, 3)


时间函数
sysdate、current_day
设置时间格式：    ALERT SESSION SET NLS_DATE_FORMAT = 'dd-mon-yyyy HH:mi:ss'
求时间：        NEXT_DAY(sysdate, '星期三')


转换函数
TO_CHAR(sysdate, 'yyyy-mm-dd hh24:mi:ss')
TO_DATE('12-3 月-04')
TO_NUMBER('333')        必须是能转换
TO_TIMESTAMP('2007-10-10 00:00:00.0', 'yyyy-mm-dd hh24:mi:ssxff')    转换为时间戳格式

聚合函数
count(*)    ：查询表行数
count(column)    :查询列行数，会忽略空值，注意
ps.聚合函数不能做为 where 里查询条件出现（因为聚合是对所有查询结果的运算？）


其他函数
USER：当前用户
SUM(DECODE(SEX, '男', 1, 0))    筛选出行被为男的记录 并加 1
SUM(DECODE(SEX, '女', 1, 0))    筛选出行被为女的记录 并加 1
NVL(a2, '非输入')        布尔值判断，利用系统对空值进行处理
SELECT DISTINCT a1 FROM aa    


表连接
内连接：查询时，把能够公共匹配的数据完全查询出来。
    FROM e, d WHERE e.id = d.id
    标准： FROM e JOIN d ON e.id = d.id

外连接：不完全匹配
  左连接：  FROM e JOIN d ON e.id = d.id(+)
    左边数据全部显示，右边匹配不上的部分用空值代替
  右连接：  FROM e JOIN d ON e.id(+) = d.id
    （同理左连接）


子查询
    无关子查询
    相关子查询

EXISTS()：    根据子查询返回是否存在数据来决定父查询。

UNION：        将多个查询出来的信息行整合成一个结果集。
  SELECT eid, ename FROM e
  UNION
  SELECT id, name FROM d
  ps.UNION 查询出来的重复记录不会显示，UNION ALL 则显示全部（包括重复的）。

INTERSECT:    返回查询出来信息行的交集，Oracle 独有。

利用查询结果批量更新：
  INSERT INTO e(eid, ename) SELECT id, name FROM d
或者利用查询结果创建新表：
  CREATE TABLE ttt AS ttt (SELECT * FROM e)
