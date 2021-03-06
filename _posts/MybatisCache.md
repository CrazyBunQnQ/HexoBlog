---
title: Mybatis 缓存
date: 2017-06-14 16:20:20
categories: Java
tag: 
- Mybatis
- 缓存
---

# Mybatis 中的缓存
缓存：一段特殊内存区域。

<!--more-->

## 一级缓存
**一级缓存是 SqlSession 级别的缓存，默认是开启的。**将第一次 sql 语句查询的结果放入到缓存中，第二次如果还发送相同的 sql 语句查询的话，优先从缓存中获取，如果缓存中没有响应的数据，再查询数据库，这样的话，降低数据库的压力，提高系统的性能。
>一级缓存在事务提交后，一级缓存数据也会释放，防止数据的脏读。
>每个 session 都有自己独立的一级缓存，不能跨 session 访问。

<br/>
## 二级缓存数据
**二级缓存比一级缓存范围大，跨 session 获取缓存数据。**其实质也是将缓存数据放在 Map 结构中。
在实际企业中，一般会用到缓存框架(ehcache oscache swarmcache)

服务器集群：很多个服务器在一起，响应用户的多个请求。
Ngnix 负载均衡：让服务器均衡的处理用户的多个请求

Mybatis 默认只支持将二级缓存数据保存到单个服务器中，如果在分布式的服务器环境中，就必须用到支持分布式的缓存框架(如 ehcache)

### ehcache
不但支持单机缓存，还支持分布式缓存。（适用于服务器集群环境中）

1. 引入依赖包（ehcache）和中间件()
2. 启用二级缓存
```xml
<setting name="cacheEnabled" value="true"/>
```
3. 类路径下，配置 ehcache.xml
配置 ehcache 对二级缓存的管理（二级缓存中最大存放的元素数量，间隔访问时间，存活时间，是否永久存放在二级缓存中，是否支持缓存数据往硬盘序列化）
4. 在 *Mapper.xml 中添加 `<cache type="org.mybatis.caches.ehcache.EhcacheCache"></cache>` 标签

>开启二级缓存后，即使关闭旧的 session，也可以在新的 session 中获取到旧 session 的数据；
>二级缓存同一级缓存一样会在事务提交后清空数据，避免脏读；
>二级缓存一般用在数据变化不是很快的应用或对数据实时性要求不高的应用中。