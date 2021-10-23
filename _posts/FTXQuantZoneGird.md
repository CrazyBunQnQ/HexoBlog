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

### 执行逻辑-仅设置变量

#### 设置网格策略触发价格

`girdStartPrice=55000`

价格低于这个值才正式开始执行整个网格策略

#### 设置网格上限

`endPrice=70000`

价格高于这个值就不交易了

#### 网格数量

`girdCount=20`

#### 设置买入百分比

`buyPercent=0.1`

跌到 `购买价格 * (1 - buyPercent)` 时再买入, 这里我设置的每跌 10% 买一次

#### 设置出售百分比

`sellPercent=0.12`

涨到 `购买价格 * (1 + sellPercent)` 时再卖出, 这里我设置的每涨 12% 就卖

#### 计算网格下限

通过网格数量, 网格上限, 每次买入百分比计算网格下限

> 该变量不会用到，也就看一下，了解下网格区间，手动算也行: `上限 * (1 - 买入百分比)^网格数量`

`startPrice=get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("girdCount")`

#### 设置每次买入额

`cost=500`

我喜欢每次以固定额度买入，有的人喜欢每次买入固定数量，区别不大，逻辑自己稍微调整一下即可

## 第一单策略

### 触发条件

- 结束价格不为 0
- 购买数量为 0
- 当前价格低于[网格触发价格](#设置网格策略触发价格)
- 其他你认为合适的触发条件，用来提高收益

`get_variable("endPrice") == 0 and get_variable("buyCount") == 0 and price("BTC/USDT") <= get_variable("girdStartPrice")`

建议再加上其他你觉得合适的触发条件, 不加也可以，启动后会立即执行

例如我想在当前价小于 30 天均价的时候再购买, 就可以填加这个条件: `and price("BTC/USDT") < average_price("BTC/USDT", 60 * 24 * 30)`

### 执行逻辑

#### 购买

以`price("BTC/USDT")`下限价买单, 买入 `get_variable("cost") / price("BTC/USDT")`

#### 设置变量

buyCount=1

> `buyCount` 每次购买 +1, 每次出售 -1

## 后续购买策略

### 触发条件

- 网格上限价格不为 0
- 购买次数(`buyCount`)大于 0
- 购买次数(`buyCount`)小于等于网格数量(`girdCount`)
- 当前价格低于最后一次购买价格的 [90%](#设置买入百分比)
- 可用 USDT 大于每次购买所需的 USDT
- 之前下的订单已完全成交
  - 买单完全成交: 可用 USDT == USDT 总余额
  - 卖单完全成交: 可用 BTC == BTC 总余额
- 其你认为合适的条件，用来增加抄底效果

`get_variable("endPrice") != 0 and get_variable("buyCount") > 0 and get_variable("buyCount") <= get_variable("girdCount") and price("BTC/USDT") <= get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount") and balance_free("USDT") > get_variable("cost") and balance_free("USDT") == balance("USDT") and balance_free("BTC") == balance("BTC")`

> 仍然可以加上其他你觉着合适的条件
> 
> `get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount")` 表示**预期的**上次购买价格，即通过买入次数和买入百分比计算出的最后一次的买入价格，并不是实际最后一次购买价格
>
> 例如策略触发价格设置的很低，那么就会连续低价购买很多次，也就是比网格预期的购买价格低很多，涨上去的时候根据预期网格去卖(一点一点分批卖)

### 执行逻辑

#### 购买

以`price("BTC/USDT")`下限价买单, 买入 `get_variable("cost") / price("BTC/USDT")`

#### 设置变量

buyCount=`get_variable("buyCount") + 1`

## 后续出售策略

### 触发条件

- 网格上限价格不为 0
- 购买次数(`buyCount`)大于 1: 最后一单留着在[止盈策略](#止盈策略)里卖
- 当前价格高于于最后一次次购买价格的 [112%](#设置出售百分比)
- 之前下的订单已完全成交
    - 买单完全成交: 可用 USDT == USDT 总余额
    - 卖单完全成交: 可用 BTC == BTC 总余额
- 其他你认为合适的条件，用来增加收益

`get_variable("endPrice") != 0 and get_variable("buyCount") > 1 and price("BTC/USDT") >= (get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount")) * get_variable("sellPercent") and balance_free("USDT") == balance("USDT") and balance_free("BTC") == balance("BTC")`

> `get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount")` 表示通过买入次数和买入百分比计算出的最后一次的买入价格

### 执行逻辑

#### 出售

以`price("BTC/USDT")`下限价卖单, 卖出上次购买的数量: 即 `get_variable("cost") / (get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount"))`

> 买入时的价格只会比预期更低，所以能买更多的币，这里卖出时按照预期买入的币卖出，未卖出的就一直拿着吧, 行情好手动卖出或者在[止盈策略](#止盈策略)里一起卖掉

#### 设置变量

buyCount=`get_variable("buyCount") - 1`

### [**使用我的推荐码注册 FTX 账号，可以获得 <font color="#FF6666">5%</font> 的手续费折扣哟**](https://ftx.com/#a=38135782)

## 止盈策略

直接全部卖出而已, 大同小异

### 触发条件

#### 执行逻辑

#### 设置变量

<!-- 个人比较菜，没有止损习惯，也没有好的止损想法...纯设置的话可以参考[止盈策略](#止盈策略) -->