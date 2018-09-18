---
title: Python Selenium 保存 canvas 图片
date: 2018-09-01 22:22:22
categories: Python
tags:
- 爬虫
- Selenium
---

今天有个小需求，需要把 GEETEST 验证码图片保存下来，但是 GEETEST 的验证码图片在后台显示是乱序的，而我需要对比正常的图片，如图：

![乱序图片](http://wx3.sinaimg.cn/large/a6e9cb00ly1fuvjf3q1gtj208o04g76j.jpg)  ![正常图片](http://wx2.sinaimg.cn/large/a6e9cb00ly1fuvjhc1xjxj207804g0uh.jpg)

<!-- more -->

尝试了几个办法都不好使，网上也没有找到有效方法，最后想，既然能在页面上正常显示，那能不能直接把标签内容直接保存成图片呢？

然后 F12 大法，找到了该图片是 `<canvas>` 显示的，至于如何用 Python 和 Selenium 保存 canvas 为图片同样没有找到现成的方法，唯一有效的信息就是知道了 Selenium 能执行 JS 代码。

于是乎，尝试了下能否将 JS 执行结果跑出来，结果还真行~

主要代码如下：

```python
from selenium import webdriver

driver = webdriver.Chrome()
# 通过 toDataURL() 方法获取图片 base64 数据，并 return
getImgJS = 'return document.getElementsByClassName("' + class_name + '")[0].toDataURL("image/png");'
# 执行 JS 代码并拿到图片 base64 数据
bg_img = driver.execute_script(getImgJS)
# 去除类型，只要数据部分
bg_img = bg_img[bg_img.find(',') + 1:]
```

拿到图片数据剩下的就好办啦~

只要将数据转化为图片保存到本地就可以了，这里用的是 base64 包

```python
import base64

img_data = base64.b64decode(bg_img)
file = open('bg.png', 'wb')
file.write(img_data)
file.close()
```

这样就大功告成啦~