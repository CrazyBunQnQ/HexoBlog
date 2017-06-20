---
title: SSM 整合
date:


---

SSM = Spring + SpringMVC + Mybatis
SSH = Struts2 + Spring + Hibernate

<!--more-->

## Spring 整合 Mybatis：
### 整合的优势：
1. 提供第三方的专业数据源连接池（c3p0、dbcp[apache]、dubbo等）；
2. DAO 对象交给 Spring 容器创建管理；
3. 提供了 SqlSessionSupport 支持类，方便获取 SqlSession。


<br/>
## Spring 整合 SpringMVC