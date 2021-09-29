---
title: FTX 量化空间
date: 2021-09-29 22:22:22
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
keywords: FTX
summary: "FTX 交易所是一家非常适合做对冲交易的交易所, 并且它有一个非常棒的功能: 量化空间. 即使你没有服务器，没有交易系统，不会编程，也可以用它来创建你的自动交易机器人."
---

FTX 交易所是一家排名前 5 的、非常适合做对冲交易的交易所. 并且它有一个非常棒的功能: 量化空间. 即使你没有服务器，没有交易系统，不会编程，也可以用它来创建你的自动交易机器人.

进入 FTX 网页版后按下面操作即可创建量化策略

![](http://wx2.sinaimg.cn/large/0033vWhyly1guxk3hjjtkj60w60ku76l02.jpg)

> [**使用我的推荐码注册 FTX 账号，可以获得 <font color="#FF6666">5%</font> 的手续费折扣**](https://ftx.com/#a=38135782)

<!--more-->

## 策略设置

启用的策略会每 15 秒钟判断一次[触发逻辑](#触发逻辑), 当触发逻辑成立时(结果为 `true`), 则会执行该策略后续的[执行逻辑](#执行逻辑)部分, 否则不会执行

### 策略名称

就是起个名, 方便查找方便一看就知道干啥用的

### 触发逻辑

就是执行这个策略的条件，满足条件就会执行这个策略后面的内容

这里面填入结果为`真(true)`或`假(false)`的[表达式](#可用表达式), 后面有各种可用的[表达式](#可用表达式)，你可以随意组合，只要表达式结果是 `true` 或 `false` 即可

> `真(true)`: 表示条件成立, 则继续执行后面的[执行逻辑](#执行逻辑)
> `假(false)`: 表示条件不成立, 不再执行后续逻辑

### 执行逻辑

> **一个策略可以添加多个执行逻辑**

执行逻辑分为多种类型: 开仓, 平仓, [下自定义订单](#自定义订单), 取消自定义订单, 暂停策略, 重启策略, [设定变量](#设定变量)

这里主要说[自定义订单](#自定义订单)和[设定变量](#设定变量)

#### 自定义订单

委托类型，交易方向，市场就不说了，手动交易过的人都知道...

我要说的是订单数量和限价(限价委托的话)也是可以填[表达式](#可用表达式)的, 只要表达式返回结果是相应数字就行

> 订单数量: 购买/出售货币的数量
> 
> 限价: 交易价格

#### 设定变量

变量值也可以填[表达式](#可用表达式), 结果是啥都行，只要引用变量的时候注意就好啦！

> <font color="#FF6666">变量可以跨策略使用！！！</font>

### [**使用我的推荐码注册 FTX 账号，可以获得 <font color="#FF6666">5%</font> 的手续费折扣哟**](https://ftx.com/#a=38135782)

## 可用表达式

### 市场数据

|函数|作用|
|:---|---:|
|price("ETH/USDT")|当前价格|
|price("ETH/USDT", `n`)|1 分钟前的价格|
|average_price("ETH/USDT", `n`)|过去 `n` 分钟的均价|
|ewma_price("ETH-PERP", `n`)|半衰期为前 `n` 分钟价格的 EWMA|
|bid_price("ETH-PERP")|最佳买盘价格|
|offer_price("ETH-PERP")|最佳卖盘价格|
|last_trade_price("ETH-PERP")|最后交易价格|
|index_price("ETH-PERP")|指数价格|
|index_price("ETH-PERP", `n`)|`n` 分钟前的指数价格|
|average_index_price("ETH-PERP")|过去 `n` 分钟，指数的平均价格|
|ewma_index_price("ETH-PERP", `n`)|半衰期为前 `n` 分钟指数价格的 EWMA|
|premium("ETH-PERP")|合约溢价(`标记价格/指数价格`)|
|volume("ETH/USDT")|过去 24 小时的交易量(以报价货币作为计量单位)|
|volume("ETH/USDT", `n`)|过去 `n` 分钟的交易量(以报价货币作为计量单位)|
|base_volume("ETH/USDT")|过去 24 小时的交易量(以基础货币作为计量单位)|
|base_volume("ETH/USDT", `n`)|过去 `n` 分钟的交易量(以基础货币作为计量单位)|
|max_price("ETH/USDT")|过去 10 分钟的最高价格|
|max_price("ETH/USDT", `n`)|过去 `n` 分钟的最高价格|
|min_price("ETH/USDT")|过去 10 分钟的最低价格|
|min_price("ETH/USDT", `n`)|过去 `n` 分钟的最低价格|
|todays_move_price()|Market price of the daily MOVE contract expiring today.|
|todays_move()|Name of the daily MOVE contract expiring today.|
|tomorrows_move_price()|Market price of the daily MOVE contract expiring tomorrow.|
|tomorrows_move()|Name of the daily MOVE contract expiring tomorrow.|
|this_weeks_move_price()|Market price of the weekly MOVE contract expiring this week.|
|this_weeks_move()|Name of the weekly MOVE contract expiring this week.|
|next_weeks_move_price()|Market price of the weekly MOVE contract expiring next week.|
|next_weeks_move()|Name of the weekly MOVE contract expiring next week.|
|this_quarters_move_price()|Market price of the quarterly MOVE contract expiring this quarter.|
|this_quarters_move()|Name of the quarterly MOVE contract expiring this quarter.|
|next_quarters_move_price()|Market price of the quarterly MOVE contract expiring next quarter.|
|next_quarters_move()|Name of the quarterly MOVE contract expiring next quarter.|

> `EWMA`: 哪个大佬知道啥意思，或者计算公式是什么呀？
> 
> `指数价格`: 选择三家以上的主流交易所相应币对, 做为权重成分计算而得. 你可以理解该价格为对应币种在多个大型交易所里的平均市场价格, 它是合约交易所要锚定的价格. 比如: 币本位保证金合约锚定标的货币的美元指数; USDT 保证金合约锚定标的货币的 USDT 指数.
> 
> `标记价格`: 是根据指数价格和基差的移动平均值加和计算而来，它主要用于账户盈亏和清结算的计算.

### 账户数据

|函数|作用|
|:---|---:|
|collateral|账户保证金总额(USD)|
|free_collateral|可用的账户保证金(USD)|
|total_position_size|所有合约的总账户仓位规模(USD)|
|margin_fraction|账户保证金比例(`账户总持仓量/保证金`)|
|open_margin_fraction|账户保证金比例包括当前委托但未交易(`(账户总持仓量+挂单量)/保证金`)|
|leverage|账户杠杆的约值(`账户保证金/总仓位`)|
|initial_mfr|账户初始保证金比例要求|
|maintenance_mfr|账户维持保证金比例要求|
|liquidation_distance|大约被清算的距离|

### 仓位数据

|函数|作用|
|:---|---:|
|position("ETH-PERP")|当前 ETH 合约 ETH 的数量. 正直或零|
|position("ETH-PERP", "buy")|当前做多合约余额, 仓位为负则此值为 0|
|position("ETH-PERP", "sell")|当前做空合约余额, 仓位为正则此值为 0|
|position_side("ETH-PERP")|仓位为正则为 1; 仓位为负责为 -1; 否则为 0|
|position_net("ETH-PERP")|净仓位. 持多长为正, 持空仓为负|
|position_leverage("ETH-PERP")|仓位杠杆的约值|
|position_notional("ETH-PERP")|仓位价值(USD)|
|position_break_even_price("ETH-PERP")|盈亏平衡的价格(保本价格)|
|position_avg_open_price("ETH-PERP")|平均开仓价格|
|position_recent_pnl("ETH-PERP")|Recent pnl(pnl since last flat) of position in USD.|

> `pnl`:

### 钱包数据

|函数|作用|
|:---|---:|
|balance("ETH")|当前现货 ETH 总余额|
|balance_free("ETH")|当前现货 ETH 可用余额|

### 数学公式

|函数|作用|
|:---|---:|
|abs(`x`)|计算 `x` 的绝对值|
|max(`x`, `y`)|求 `x` 和 `y` 的更大值|
|min(`x`, `y`)|求 `x` 和 `y` 的更小值|
|sqrt(`x`)|计算 `x` 的平方根|
|floor(`x`)|计算小于等于 `x` 的最大整数|
|ceil(`x`)|计算大于等于等于 `x` 的最小整数|
|sign(`x`)|如果 `x` 为正则结果为 1; 如果 `x` 为负则结果为 -1; 如果 `x` 为零则结果为 0.|

### 逻辑运算

|运算符|作用|
|:---|---:|
|`x` and `y`|`x` 和 `y` 均为 true 则为 true, 否则为 false|
|`x` or `y`|`x` 和 `y` 均为 false 则为 false, 否则为 true|
|not `x`|`x` 为 false 则为 true, 否则为 true|
|`x` if `y` else `z`|如果 `y` 为 true 则值为 `x`, 否则值为 `z`|

### 算数运算

|运算符|作用|运算符|作用|
|:---|---:|:---|---:|
|+|加法|-|减法|
|*|乘法|/|除法|
|%|求余|//|除法, 下舍|
|`x` ** `y`|`x` 的 `y` 次方|||

### 其他

|函数|作用|
|:---|---:|
|**get_variable(`name`)**|使用**设置变量(set variable)**定义的值, 变量不存在则为 0<br/>**<font color="#FF6666">可以跨策略使用！！！</font>**|
|perpetual("ETH")|获取永续合约市场的名称|
|quarterly("ETH")|获取季度合约市场的名称|
|time|当前 Unix 时间(自 1970 年 1 月 1 日以来的秒数)|
|minute|当前时间的分钟部分. 从小时开始算起的整分钟数|
|hour|当前时间的小时部分. 从 UTC 午夜以来的总小时数|
|day_of_week()|UTC day of the week as an integer, where Monday is 0 and Sunday is 6.|

### 一些示例

- 当前价格小于 30 天均价: `price("ETH/USDT") < average_price("ETH/USDT", 60 * 24 * 30)`
- 当前现货持仓价值: `balance("FTT") * price("FTT/USDT")`
- 当前合约持仓价值: `price("FTT-PERP") * position("FTT-PERP", "sell")`
- 当前现货价值小于 总余额 / 2 * 95%:  `balance("FTT") * price("FTT/USDT") < (balance("USDT") + price("FTT-PERP") * position("FTT-PERP", "sell") + balance("FTT") * price("FTT/USDT")) / 2 * 0.95`

## 策略分享

待续...