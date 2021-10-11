---
title: FTX 量化空间无限网格策略
date: 2021-10-07 22:22:22
img: "/images/FTXQuantZone.png"
top: 10
cover: fasle
coverImg: "/images/FTXQuantZone.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: 虚拟货币
tags:
  - 自动交易
  - FTX
  - 量化空间
  - 网格交易
keywords: FTX
summary: "之前介绍了 FTX 交易所量化空间的功能和函数，这次说下如何利用量化空间创建自动网格交易的策略"
---

之前介绍了 FTX 交易所量化空间的功能和函数，这次说下如何利用量化空间创建自动网格交易的策略

![创建策略](/images/FTXCreateStrategy.jpg)

> [**使用我的推荐码注册 FTX 账号，可以获得 <font color="#FF6666">5%</font> 的手续费折扣**](https://ftx.com/#a=38135782)

<!--more-->

## 设定全局变量策略

### 触发条件

`true`

### 执行逻辑

#### 设置买入百分比

`buyPercent=0.1`

跌到 `购买价格 * (1 - buyPercent)` 时再买入, 这里我设置的每跌 10% 买一次

#### 设置出售百分比

`sellPercent=0.12`

涨到 `购买价格 * (1 + sellPercent)` 时再卖出, 这里我设置的每涨 12% 就卖

#### 设置每次买入额

`cost=500`

我喜欢每次以固定额度买入，有的人喜欢每次买入固定数量，区别不大，逻辑自己稍微调整一下即可

## 第一单策略

### 触发条件

`get_variable(firstBuyPrice) == 0 and get_variable(girdNum) == 0`

建议再加上其他你觉得合适的触发条件, 不加也可以，启动后会立即执行

例如我想在当前价小于 30 天均价的时候再购买, 就可以填加这个条件: `and price("BTC/USDT") < average_price("BTC/USDT", 60 * 24 * 30)`

### 执行逻辑

#### 购买

以`price("BTC/USDT")`下限价买单, 买入 `get_variable(cost) / price("BTC/USDT")`

#### 设置变量

firstBuyPrice=`当前价格`
preBuyPrice=`当前价格`
girdNum=1

> `girdNum` 网格数量，每次购买 +1, 每次出售 -1

## 后续购买策略

### 触发条件

第一次购买价格不为 0 且当前价格低于上次购买价格的 90%

`get_variable(firstBuyPrice) != 0 and price("BTC/USDT") <= get_variable(firstBuyPrice) * (1 - get_variable(buyPercent)) ** get_variable(girdNum)`

> 仍然可以加上其他你觉着合适的条件

### 执行逻辑

#### 购买

以`price("BTC/USDT")`下限价买单, 买入 `get_variable(cost) / price("BTC/USDT")`

<!-- 不可用 usdt == 0 -->

#### 设置变量

girdNum=`get_variable(girdNum) + 1`
