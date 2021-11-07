---
title: FTX 量化空间网格策略
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

> 使用 [**Benson Sun**](https://twitter.com/FTX_Benson) 的 [推荐码](https://ftx.com/#a=BensonTW) 注册 FTX 账号，**可以获得 <font color="#FF6666">5%</font> 的手续费折扣**

<!--more-->

## 设定全局变量策略

首先要创建一个专门设置变量和重新计算变量的策略

### 触发条件

判断是否设置了网格参数以及刷新计数

```
判断各参数是否设置
get_variable("girdStartPrice") == 0 or 
get_variable("endPrice") == 0 or 
get_variable("girdCount") == 0 or 
get_variable("buyPercent") == 0 or 
get_variable("sellPercent") == 0 or 
get_variable("cost") == 0 or 
get_variable("startPrice") == 0 or 
判断网格下限是否有变动(修改上面的参数后网格下限会变)
get_variable("startPrice") != get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("girdCount") or 
判断当前的持仓订单数量是否变动
get_variable("curCount") != get_variable("buyCount") - get_variable("sellCount")
```

### 执行逻辑-仅设置变量

#### 设置网格策略触发价格

`girdStartPrice=60`

价格低于这个值才正式开始执行整个网格策略

#### 设置网格上限

`endPrice=120`

价格高于这个值就不交易了

#### 网格数量

`girdCount=10`

#### 设置买入百分比

`buyPercent=0.1`

跌到 `购买价格 * (1 - buyPercent)` 时再买入, 这里我设置的每跌 10% 买一次

#### 设置出售百分比

`sellPercent=0.12`

涨到 `购买价格 * (1 + sellPercent)` 时再卖出, 这里我设置的每涨 12% 就卖

#### 设置每次买入额

`cost=500`

我喜欢每次以固定额度买入，有的人喜欢每次买入固定数量，区别不大，逻辑自己稍微调整一下即可

#### 计算网格下限

通过网格数量, 网格上限, 每次买入百分比计算网格下限

> 该变量不会用到，也就看一下，了解下网格区间，手动算也行: `上限 * (1 - 买入百分比)^网格数量`

`startPrice=get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("girdCount")`

#### 计算当前持有的订单数量

每次买卖后需要重新计算订单数量

`curCount = get_variable("buyCount") - get_variable("sellCount")`

---

## 第一单策略

因为要设置触发条件，所以第一单购买单独搞了个策略，如果不需要触发条件，可以去掉这个策略，直接看下一个，但是条件需要微调一下

### 触发条件

- 结束价格不为 0: `get_variable("endPrice") != 0`
- 购买数量为 0: `get_variable("buyCount") == 0`
- 当前价格低于[网格触发价格](#设置网格策略触发价格): `price("FTT/USD") <= get_variable("girdStartPrice")`
- 其他你认为合适的触发条件，用来提高收益, 例如我想在当前价小于 30 天均价的时候再购买, 就可以填加这个条件: `and price("FTT/USD") < average_price("FTT/USD", 60 * 24 * 30)`

综上:

`get_variable("endPrice") != 0 and get_variable("buyCount") == 0 and price("FTT/USD") <= get_variable("girdStartPrice")`

### 执行逻辑

#### 购买

- 订单数量: `get_variable("cost") / price("FTT/USD")`
- 限价: `get_variable("girdStartPrice")`

> 下面的三个选项都不要勾选, 因为触发条件肯定低于这个价格，所以会以更低的价格购买到
> 
> 如果已经有一个委托存在, 勾选`保留现有订单`

#### 设置变量

- 买入次数: `buyCount = 1`

> `buyCount` 每次购买 +1

#### 暂停策略

暂停当前策略 1 分钟，给设置变量策略一点时间去计算持有订单的数量

---

## 后续购买策略

### 触发条件

- 网格上限价格不为 0: `get_variable("endPrice") != 0`
- 购买次数大于 0: `get_variable("buyCount") > 0`
- 当前挂的买单数量大于 0: `get_variable("curCount") > 0`
- 当前挂的买单数量小于等于网格数量: `get_variable("curCount") <= get_variable("girdCount")`
- 当前价格低于最后一次期望购买价格的 [90%](#设置买入百分比): `price("FTT/USD") < get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("curCount")`
  - 最后一次期望的购买价格: `get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("curCount")`
- 可用 USD 大于每次购买所需的 USD: `balance_free("USD") > get_variable("cost")`
- 之前下的买单已完全成交: `balance_free("USD") == balance("USD")`
- 其你认为合适的条件，用来增加抄底效果，例如当前价小于日均线的 95%: `price("FTT/USD") < average_price("FTT/USD", 60 * 24) * 0.95`

> `get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("curCount")` 表示**预期的**上次购买价格，即通过买入次数和买入百分比计算出的最后一次的买入价格，并不是实际最后一次购买价格
>
> 例如策略触发价格设置的很低，那么就会连续低价购买很多次，也就是比网格预期的购买价格低很多，涨上去的时候根据预期网格去卖(一点一点分批卖)

综上:

`get_variable("endPrice") != 0 and get_variable("buyCount") > 0 and get_variable("curCount") > 0 and get_variable("curCount") <= get_variable("girdCount") and price("FTT/USD") < get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("curCount") and balance_free("USD") > get_variable("cost") and balance_free("USD") == balance("USD") and price("FTT/USD") < average_price("FTT/USD", 60 * 24) * 0.95`

### 执行逻辑

#### 购买

- 订单数量: `get_variable("cost") / price("FTT/USD")`
- 限价: `get_variable("endPrice") * (1 - get_variable("buyPercent")) ** get_variable("curCount")`

> 下面的三个选项都不要勾选, 因为触发条件肯定低于这个价格，所以会以更低的价格购买到
>
> 如果已经有一个委托存在, 勾选`保留现有订单`

#### 设置变量

- 买入次数: `buyCount = get_variable("buyCount") + 1`

> `buyCount` 每次购买 +1

#### 暂停策略

暂停当前策略 1 分钟，给设置变量策略一点时间去计算持有订单的数量

---

## 后续出售策略

### 触发条件

- 网格上限价格不为 0: `get_variable("endPrice") != 0`
- 当前挂的买单数大于 1, 最后一单留着看行情手动卖出: `get_variable("curCount") > 1`
- 当前价格高于于最后一次次购买价格的 [112%](#设置出售百分比): `price("FTT/USD") > (get_variable("endPrice") * (1 - get_variable("buyPercent")) ** (get_variable("curCount") - 1)) * (1 + get_variable("sellPercent"))`
  - 最后一次购买价: `get_variable("endPrice") * (1 - get_variable("buyPercent")) ** (get_variable("curCount") - 1)`
- 其他你认为合适的条件，用来增加收益

> 最后一次购买价通过买入次数和买入百分比计算所得
>
> 因为下买单后，购买次数加 1 了, 所以要 `get_variable("curCount") - 1` 表示上一次

综上:

`get_variable("endPrice") != 0 and get_variable("curCount") > 1 and price("FTT/USD") > (get_variable("endPrice") * (1 - get_variable("buyPercent")) ** (get_variable("curCount") - 1)) * (1 + get_variable("sellPercent"))`

### 执行逻辑

#### 出售

- 订单数量: `get_variable("cost") / (get_variable("endPrice") * (1 - get_variable("buyPercent")) ** (get_variable("curCount") - 1))`
- 限价: `(get_variable("endPrice") * (1 - get_variable("buyPercent")) ** (get_variable("curCount") - 1)) * (1 + get_variable("sellPercent"))`
 
勾选上**如果已经有一个委托存在，则保留现有订单**, 按照期望挂上单了，坐等交易成功就好

> 买入时的价格只会比预期更低，所以能买更多的币，这里卖出时按照预期买入的币卖出，未卖出的就一直拿着吧, 行情好手动卖出

#### 设置变量

- 出售次数: `sellCount = get_variable("sellCount") + 1`

> `sellCount` 每次出售 +1

#### 暂停策略

暂停当前策略 1 分钟，给设置变量策略一点时间去计算持有订单的数量

---

### 使用 [**Benson Sun**](https://twitter.com/FTX_Benson) 的 [推荐码](https://ftx.com/#a=BensonTW) 注册 FTX 账号，**可以获得 <font color="#FF6666">5%</font> 的手续费折扣**

## 效果图

![](/images/FTXQuantZoneGird.png)

## 止盈策略

直接全部卖出而已, 大同小异

### 触发条件

#### 执行逻辑

#### 设置变量

<!-- 个人比较菜，没有止损习惯，也没有好的止损想法...纯设置的话可以参考[止盈策略](#止盈策略) -->