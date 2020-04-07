---
title: Map 映射
date: 2017-03-20 23:23:23
categories: Java
tags: 
- 集合
- Map
---
映射（Map）是一种存放一组条目的容器，每个条目形如（key, value），其中 key 为关键码对象，value 为具体的数据对象。**在映射中，各条目的关键码不允许重复冗余。**映射中的元素由其关键码唯一标识，映射的作用是通过关键码直接找到对应的元素。

<!-- more -->
## Map (接口)
Map 接口定义了存储所谓的 key-value，即键值对。Key 可以看成 value 索引，作为 key 的对象在 Map 中不可重复。

实现 Map 接口最常用的是 HashMap，TreeMap。Map 也支持泛型。

```java
	Map map = new HashMap();
	Map<String, Integer> m = new TreeMap<String, Integer>();
```

映射的常用操作方法：

|操作方法|描述|
|:--:|:--:|
|getSize()|获得映射的规模，即其中元素的数目，返回值为 int 类型|
|isEmpty()|判断映射是否为空，返回值为 boolean 类型|
|get(key)|若映射中存在以 key 为关键码的条目，则返回该条目的数据对象，否则返回 nul|
|put(key, value)|若映射中不存在以 key 为关键码的条目，则将条目 (key, value) 加入到映射中并返回 null，否则，将已有条目的数据对象替换为 value，并返回原先的数据对象。|

### V put(K k, V v) ###
若 Map 中不存在以 key 为关键码的条目，则将条目 (key, value) 加入到映射中并返回 null，否则，将已有条目的数据对象替换为 value，并返回原先的数据对象。

```java
	map.put("语文", 60);
	map.put("数学", 99);
	map.put("英语", 59);
	map.put("物理", 100);
	map.put("化学", 88);
	System.out.println(map);//输出 {物理=100, 数学=99, 化学=88, 语文=60, 英语=59}
	//不允许重复
	map.put("英语", 80);
	System.out.println(map);
	//m.put(2,"dsf");//报错，已经指定了泛型的类型
```

### putAll(Map m)

```java
	m.putAll(map);
	System.out.println(m);
```

### get(Object k)
根据给定的 key 获取对应的 value 对象，不存在则返回 null。

```java
	Integer value = m.get("语文");
	System.out.printLn(value);//60
	value = m.get("生物");
	System.out.printLn(value);//null
```

### V remove(K k)
根据给定的 key 所对应的记录从 Map 中移除，并且将该删除成功后的 value 值返回。

```java
	value = m.remove("英语");
	System.out.println(value);
	System.out.print(m);
```

### int size()
返回 Map 中的元素个数

```java
	System.out.print(m.size());
```

### void clear()
该方法用于清空所有元素。

```java
	m.clear();
	System.out.print(m.size());
```

### boolean containsKey(Object key)
判断 Map 中是否包含给定的 key，包含则返回 true，否则返回 false。

```java
	System.out.println("map 中是否包含 " + m.containsKey("英语"));
	System.out.println("map 中是否包含 " + m.containsKey("语文"));
```

### Set keySet()
用于返回当前 Map 中所有的 key（键），存入一个 Set 集合。

```java
	Set<String> set = m.keySet();
	System.out.println(set);
```

### Collection values()
用于返回当前 Map 中所有的 value（值），存入一个 Collection 集合。（因为 value 可以重复，所以不是 Set）

```java
	Collection<Integer> c = m.values();
	System.out.println(c);
```

### Set<Entry<K,V>> entrySet()
**会将当前 Map 中每一组 key-value 封装为一个 Entry 对象，并存入一个 Set 集合返回。**
也就是新的 Set 集合中每个元素都是一个 Entry 对象。每一个 Entry 对象都对应一个 key-value 键值对

```java
	Set<Entry<String, Integer>> entry = m.entrySet();
	System.out.println(entry);
```

## 遍历 Map
遍历 Map 有三种方式：
- 遍历所有的 key
- 遍历所有的 value
>不常用也不推荐用
- 遍历每一组键值对（Entry）

### 遍历所有 key ###

```java
	Map<String, Integer> m = new TreeMap<String, Integer>();
	m.put("语文", 60);
	m.put("数学", 99);
	m.put("英语", 59);
	m.put("物理", 100);
	m.put("化学", 88);
	System.out.println(m);
	Set<String> set = m.keySet();
	for(String key:set) {
		System.out.println("key:" + key + ",  value:" + m.get(key));
	}
```

### 遍历每一组键值对

```java
	Set<Entry<String, Integer>> entry = m.entrySet();
	for(Entry<String, Integer> e:entry) {//遍历 Set 集合，拿到每一个 Entry 对象
		System.out.println("key:" + e.getKey() + ",  value:" + e.getValue());
	}
```

### ~~遍历所有 value~~
不常用

```java
	for (Integer i:m.values()) {
		System.out.println(i);
	}
```

</br>
# 坑有点大！稍后填坑！！！ #
