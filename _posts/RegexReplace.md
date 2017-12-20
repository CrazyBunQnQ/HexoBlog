---
title: VS Code 正则表达式查找替换
date: 2017-12-18
categories: 触类旁通
tags:
- 正则表达式
---

最近做的事情经常要处理重复的文本，用了一段时间之后，利用正则表达式来查找字符串基本上是很熟练啦~
但是前几天看到 [drakeet](https://t.me/drakeets/233) 大神使用正则表达式把自己项目中所有下划线命名的变量改为驼峰命名法之后我知道，原来正则表达式还可以这么玩！
哇塞，之前完全就没想过诶，果然是只有想不到，没有做不到啊。。。
所以马上学习了如何使用正则表达式高效的查找替换，哈哈哈，效率提升不是一星半点啊！

>[正则表达式基础](/2017/03/15/RegexGrammar/)就不再赘述了

<!--more-->

## 查找替换

先上例子：
我要写个存储过程，直接把表结构粘贴过来作为 RECORD（如下），一行一行改就太麻烦了，用正则表达式之后瞬间完成啊！

```sql
CREATE OR REPLACE PACKAGE PCKG_ASYNC_AIMP440020_EXPORT IS
  TYPE R_AIMP440020_LIST_REC IS RECORD(
  TASK_ID    VARCHAR2(20),
  BATCH_DATE VARCHAR2(8),
  DATA_DATE  VARCHAR2(8),
  DATA_REF VARCHAR2(10),
  DATA_SOURCE      VARCHAR2(20),
  PI_INDICATOR VARCHAR2(4),
  PRODUCT_TYPE      VARCHAR2(20),
  REFERENCE_NUMBER VARCHAR2(60),
  CI_NUMBER             VARCHAR2(20),
  CI_GL_DESC VARCHAR2(60),
  ISSUER_TYPE      VARCHAR2(10),
  ISSUER_COUNTRY VARCHAR2(2),
  FITCH_RATING VARCHAR2(4),
  MOODY_RATING VARCHAR2(4),
  SP_RATING VARCHAR2(4),
  TRADE_DATE VARCHAR2(10),
  VALUE_DATE VARCHAR2(10),
  MAT_DATE VARCHAR2(10),
  MAT_TENOR VARCHAR2(30),
  CACLULATION_RATIO VARCHAR2(10),
  CCY VARCHAR2(3),
  CUR_AMOUNT           NUMBER(18,2),
  CUR_AMOUNT_LCE       NUMBER(18,2),
  LAST_AMOUNT           NUMBER(18,2),
  LAST_AMOUNT_LCE       NUMBER(18,2),
  VARI_AMOUNT           NUMBER(18,2),
  VARI_AMOUNT_LCE       NUMBER(18,2),
  VARI_LCE VARCHAR2(10));
```

改成这个样子:

```sql
CREATE OR REPLACE PACKAGE PCKG_ASYNC_AIMP440020_EXPORT IS
  TYPE R_AIMP440020_LIST_REC IS RECORD(
  TASK_ID AIMP440020_CFR_M_BREK.TASK_ID@HKBRIISP_COSP_ADP_HKBRIISP%type,
  BATCH_DATE AIMP440020_CFR_M_BREK.BATCH_DATE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  DATA_DATE AIMP440020_CFR_M_BREK.DATA_DATE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  DATA_REF AIMP440020_CFR_M_BREK.DATA_REF@HKBRIISP_COSP_ADP_HKBRIISP%type,
  DATA_SOURCE AIMP440020_CFR_M_BREK.DATA_SOURCE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  PI_INDICATOR AIMP440020_CFR_M_BREK.PI_INDICATOR@HKBRIISP_COSP_ADP_HKBRIISP%type,
  PRODUCT_TYPE AIMP440020_CFR_M_BREK.PRODUCT_TYPE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  REFERENCE_NUMBER AIMP440020_CFR_M_BREK.REFERENCE_NUMBER@HKBRIISP_COSP_ADP_HKBRIISP%type,
  CI_NUMBER AIMP440020_CFR_M_BREK.CI_NUMBER@HKBRIISP_COSP_ADP_HKBRIISP%type,
  CI_GL_DESC AIMP440020_CFR_M_BREK.CI_GL_DESC@HKBRIISP_COSP_ADP_HKBRIISP%type,
  ISSUER_TYPE AIMP440020_CFR_M_BREK.ISSUER_TYPE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  ISSUER_COUNTRY AIMP440020_CFR_M_BREK.ISSUER_COUNTRY@HKBRIISP_COSP_ADP_HKBRIISP%type,
  FITCH_RATING AIMP440020_CFR_M_BREK.FITCH_RATING@HKBRIISP_COSP_ADP_HKBRIISP%type,
  MOODY_RATING AIMP440020_CFR_M_BREK.MOODY_RATING@HKBRIISP_COSP_ADP_HKBRIISP%type,
  SP_RATING AIMP440020_CFR_M_BREK.SP_RATING@HKBRIISP_COSP_ADP_HKBRIISP%type,
  TRADE_DATE AIMP440020_CFR_M_BREK.TRADE_DATE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  VALUE_DATE AIMP440020_CFR_M_BREK.VALUE_DATE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  MAT_DATE AIMP440020_CFR_M_BREK.MAT_DATE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  MAT_TENOR AIMP440020_CFR_M_BREK.MAT_TENOR@HKBRIISP_COSP_ADP_HKBRIISP%type,
  CACLULATION_RATIO AIMP440020_CFR_M_BREK.CACLULATION_RATIO@HKBRIISP_COSP_ADP_HKBRIISP%type,
  CCY AIMP440020_CFR_M_BREK.CCY@HKBRIISP_COSP_ADP_HKBRIISP%type,
  CUR_AMOUNT AIMP440020_CFR_M_BREK.CUR_AMOUNT@HKBRIISP_COSP_ADP_HKBRIISP%type,
  CUR_AMOUNT_LCE AIMP440020_CFR_M_BREK.CUR_AMOUNT_LCE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  LAST_AMOUNT AIMP440020_CFR_M_BREK.LAST_AMOUNT@HKBRIISP_COSP_ADP_HKBRIISP%type,
  LAST_AMOUNT_LCE AIMP440020_CFR_M_BREK.LAST_AMOUNT_LCE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  VARI_AMOUNT AIMP440020_CFR_M_BREK.VARI_AMOUNT@HKBRIISP_COSP_ADP_HKBRIISP%type,
  VARI_AMOUNT_LCE AIMP440020_CFR_M_BREK.VARI_AMOUNT_LCE@HKBRIISP_COSP_ADP_HKBRIISP%type,
  VARI_LCE AIMP440020_CFR_M_BREK.VARI_LCE@HKBRIISP_COSP_ADP_HKBRIISP%type);
```

只需要做如下操作即可：

- 查找：`  ([A-Z_]+) +((VARCHAR2)|(NUMBER))\([0-9,]{1,4}\)`
- 替换为：`  $1 AIMP440020_CFR_M_BREK.$1@HKBRIISP_COSP_ADP_HKBRIISP%type`

就像魔法一样啊有木有！

>其中 `$1` 代表第一个匹配表达式，也就是 `([A-Z_]+)`
>其他编辑器应该类似，顶多 `$1` 有点区别

再来一个：

```sql
/***************** PART 0 *****************/
/***************** PART 1 *****************/
/***************** PART 2 *****************/
/***************** PART 3 *****************/
/***************** PART 4 *****************/
/***************** PART 5 *****************/
/***************** PART 6 *****************/
/***************** PART 7 *****************/
/***************** PART 8 *****************/
/***************** PART 9 *****************/
/***************** PART 10 *****************/
```

替换成

```sql
/***************** PART 0 *****************/
SET_STEP_NO(0);
/***************** PART 1 *****************/
SET_STEP_NO(1);
/***************** PART 2 *****************/
SET_STEP_NO(2);
/***************** PART 3 *****************/
SET_STEP_NO(3);
/***************** PART 4 *****************/
SET_STEP_NO(4);
/***************** PART 5 *****************/
SET_STEP_NO(5);
/***************** PART 6 *****************/
SET_STEP_NO(6);
/***************** PART 7 *****************/
SET_STEP_NO(7);
/***************** PART 8 *****************/
SET_STEP_NO(8);
/***************** PART 9 *****************/
SET_STEP_NO(9);
/***************** PART 10 *****************/
SET_STEP_NO(10);
```

只需要做如下查找替换：

1. 查找：` PART (\d+)( .{10}\*+/)\n`
1. 替换为：` PART $1$2\nSET_STEP_NO($1);\n`

哈哈哈哈 太好玩了！

### ORACLE 中将所有创建表语句前面加上判断是否存在，存在则先进行删除的操作

再来个比较实用的：

Oracle 中判断数据库表是否存在的方式与 MySql 不太一样，复杂很多，那么给创建表的脚本上都加上判断存在的操作就可以用这个操作啦！

- 有用户的

  查找

  ```sql
  CREATE TABLE ([A-Z0-9_]+)\.([A-Z0-9_]+)\n
  ```

  替换

  ```sql
  \n/********** drop table $1.$2 **********/\ndeclare\n  i integer;\nbegin\n  select count(1)\n    into i\n    from all_tables s\n   where s.owner = '$1'\n     AND s.table_name = '$2';\n  if (i > 0) then\n    execute immediate 'drop table $1.$2';\n  end if;\nend;\n/\n/********** create table $1.$2 **********/\nCREATE TABLE $1.$2
  ```

- 没用户的

  查找

  ```sql
  CREATE TABLE ([A-Z0-9_]+)\n
  ```

  替换

  ```sql
  \n/********** drop table $1 **********/\ndeclare\n  i integer;\nbegin\n  select count(1)\n    into i\n    from all_tables s\n   where s.table_name = '$1';\n  if (i > 0) then\n    execute immediate 'drop table $1';\n  end if;\nend;\n/\n/********** create table $2 **********/\nCREATE TABLE $1
  ```