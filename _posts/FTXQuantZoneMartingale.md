---
title: FTX 量化空间马丁格尔策略
date: 2021-11-05 22:22:22
img: "/images/FTXQuantZone.png"
top: 10
cover: false
coverImg: "/images/FTXQuantZone.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: 虚拟货币
tags:
  - 自动交易
  - FTX
  - 量化空间
  - 马丁格尔
keywords: FTX
summary: "之前介绍了 FTX 交易所量化空间的功能和函数以及简单的网格策略，这次说下如何利用量化空间创建马丁格尔机器人: 分批买入，一次卖出"
---

之前介绍了 FTX 交易所量化空间的功能和函数以及简单的网格策略，这次说下如何利用量化空间创建马丁格尔机器人: 分批买入，一次卖出

该策略运气好的话，在**最终卖出时，保证期望收益的情况下还能剩下一些币** ^_^

派网最近出了个新的交易机器人: 马丁格尔机器人，那为啥我不直接用派网机器人呢？

原因很简单: 派网的**资金利用率低**

例如开一个机器人用到 1000U, 但是没到下限之前，就会有些 U 没有用到，但是被冻结了，尤其是接近上限时，会有很多 U 没有用到但是没法用在别的地方

![创建策略](/images/FTXCreateStrategy.jpg)

> 使用 [**Benson Sun**](https://twitter.com/FTX_Benson) 的 [推荐码](https://ftx.com/#a=BensonTW) 注册 FTX 账号，**可以获得 <font color="#FF6666">5%</font> 的手续费折扣**

<!--more-->

## 设定全局变量策略

### 触发条件

`true`

### 执行逻辑-仅设置变量

#### 设置策略触发价格

`girdStartPrice=60`

价格低于这个值才正式开始执行整个策略

#### 补仓次数

> 不建议补仓太多次

`coverCount=5`

#### 设置买入百分比

`buyPercent=0.1`

策略开始后，价格每跌多少进行补仓, 这里我设置的每跌 10% 买一次

#### 设置期望收益百分比

`sellPercent=0.5`

涨到 `持仓均价 * (1 + sellPercent)` 时再卖出所有, 这里我设置的涨 50% 全部卖出

#### 计算最后一次补仓的价格

通过补仓次数、起始价格和每次买入百分比计算购买下限

> 该变量不会用到，也就看一下，了解下网格区间，手动算也行: `起始价格 * (1 - 买入百分比)^补仓次数`

`startPrice=get_variable("girdStartPrice") * (1 - get_variable("buyPercent")) ** get_variable("coverCount")`

#### 设置每次买入额

`cost=500`

我喜欢每次以固定额度买入，有的人喜欢每次买入固定数量，区别不大，逻辑自己稍微调整一下即可

## 第一单策略

> 没有特殊需求的话买入策略可以合并为一个

### 触发条件

- 触发价格不为 0
- 购买数量为 0
- 当前价格低于[网格触发价格](#设置策略触发价格)
- 其他你认为合适的触发条件，用来提高收益

`get_variable("girdStartPrice") != 0 and get_variable("buyCount") == 0 and price("FTT/USD") < get_variable("girdStartPrice")`

建议再加上其他你觉得合适的触发条件, 不加也可以，启动后会立即执行

例如我想在当前价小于 30 天均价的时候再购买, 就可以填加这个条件: `and price("FTT/USD") < average_price("FTT/USD", 60 * 24 * 30)`

### 执行逻辑

#### 购买

- 订单数量: `get_variable("cost") / price("FTT/USD")`
- 限价: `get_variable("girdStartPrice")`

> 不要勾选 `Post Only`, 因为触发条件肯定低于这个价格，所以会以更低的价格购买到

#### 设置变量

- 买入次数: `buyCount = 1`
- 持仓数量: `positionAmount = get_variable("cost") / get_variable("girdStartPrice")`

> `buyCount` 每次购买 +1, 每次出售 -1

## 后续购买策略

### 触发条件

- 触发价格不为 0: `get_variable("girdStartPrice") != 0`
- 购买次数大于 0: `get_variable("buyCount") > 0`
- 当前挂的买单数量小于等于购买次数: `get_variable("buyCount") <= get_variable("coverCount")`
- 当前价格低于上一次补仓价格的 [90%](#设置买入百分比): `price("FTT/USD") < get_variable("girdStartPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount")`
  - 最后一次期望的购买价格: `get_variable("girdStartPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount")`
- 可用 USD 大于每次购买所需的 USD: `balance_free("USD") > get_variable("cost")`
- 之前下的买单已完全成交: `balance_free("USD") == balance("USD")`
- 其你认为合适的条件，用来增加抄底效果，例如当前价小于日均线的 95%: `price("FTT/USD") < average_price("BTC/USD", 60 * 24) * 0.95`

> `get_variable("girdStartPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount")` 表示**预期的**上次购买价格，即通过买入次数和买入百分比计算出的最后一次的买入价格，并不是实际最后一次购买价格
>
> 例如策略触发价格设置的很低，那么就会连续低价购买很多次，也就是比网格预期的购买价格低很多，涨上去的时候根据预期网格去卖(一点一点分批卖)

综上:

`get_variable("girdStartPrice") != 0 and get_variable("buyCount") > 0 and get_variable("buyCount") > 0 and get_variable("buyCount") <= get_variable("coverCount") and price("FTT/USD") < get_variable("girdStartPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount") and balance_free("USD") > get_variable("cost") and balance_free("USD") == balance("USD") and price("FTT/USD") < average_price("BTC/USD", 60 * 24) * 0.95`

### 执行逻辑

#### 购买

- 订单数量: `get_variable("cost") / price("FTT/USD")`
- 限价: `get_variable("girdStartPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount")`

> 不要勾选 `Post Only`, 因为触发条件肯定低于这个价格，所以会以更低的价格购买到

#### 设置变量

- 买入次数: `buyCount=get_variable("buyCount") + 1`
- 持仓数量: `positionAmount = get_variable("positionAmount") + get_variable("cost") / (get_variable("girdStartPrice") * (1 - get_variable("buyPercent")) ** get_variable("buyCount"))`

## 出售策略

### 触发条件

- 触发价格不为 0: `get_variable("girdStartPrice") != 0`
- 当前挂的买单数大于 0: `get_variable("buyCount") > 0`
- 当前价格高于持仓平均价格的 [150%](#设置期望收益百分比): `price("FTT/USD") > (get_variable("cost") * get_variable("buyCount") / get_variable("positionAmount")) * (1 + get_variable("sellPercent"))`
  - 总花费: `get_variable("cost") * get_variable("buyCount")`
  - 持仓均价: `get_variable("cost") * get_variable("buyCount") / get_variable("positionAmount")`
- 其他你认为合适的条件，用来增加收益

> 最后一次购买价通过买入次数和买入百分比计算所得
>
> 因为下买单后，购买次数加 1 了, 所以要 `get_variable("buyCount") - 1` 表示上一次

综上:

`get_variable("girdStartPrice") != 0 and get_variable("buyCount") > 0 and price("FTT/USD") > (get_variable("cost") * get_variable("buyCount") / get_variable("positionAmount")) * (1 + get_variable("sellPercent"))`

### 执行逻辑

#### 出售

- 订单数量: `get_variable("positionAmount")`
- 限价: `(get_variable("cost") * get_variable("buyCount") / get_variable("positionAmount")) * (1 + get_variable("sellPercent"))`
 
勾选上**如果已经有一个委托存在，则保留现有订单**, 按照期望挂上单了，坐等交易成功就好

> 买入时的价格只会比预期更低，所以能买更多的币，这里卖出时按照预期买入的币卖出，未卖出的就一直拿着吧, 行情好手动卖出
> 
> 如果想全部卖出，则订单数量设置为可用余额 `balance_free("FTT")`

#### 设置变量

重置变量

- `buyCount = 0`
- `positionAmount = 0`

#### 停止策略(可选)

停止所有策略

### 使用 [**Benson Sun**](https://twitter.com/FTX_Benson) 的 [推荐码](https://ftx.com/#a=BensonTW) 注册 FTX 账号，**可以获得 <font color="#FF6666">5%</font> 的手续费折扣**
