---
title: 使用 IDEA 自带的 HTTP Client 来测试 API
date: 2019-05-04 22:22:22
categories: IDEA
tag:
- 工具
- 效率
---

对于 API 测试，常用的方式大多是通过浏览器发送请求、Postman 等 API 工具来测试 API

- Chrome 等浏览器：不方便构造 POST 请求
- Postman：比较专业，但是需要下载工具

之前对于 API 测试我一直使用等 Postman，便捷、可视化、批量测试，登录后还可以很方便的同步，也可以分享接口到组内或网上

但是最近才发现原来 IDEA 已经集成了 API 测试工具

网上查到的很多资料都是 VS Code 里的 [Editor REST Client](https://segmentfault.com/a/1190000016300254)，跟 IDEA 的 [HTTP Client](https://www.jetbrains.com/help/idea/http-client-in-product-code-editor.html) 类似但还是有些区别的

<!-- more -->

IDEA 中貌似以前就已经有了 REST Client 工具，但是现在已经提示过时了，会提示使用 [HTTP Client]() 来测试 API 了

![REST Client](http://wx4.sinaimg.cn/large/a6e9cb00ly1g2u4xgxfy1j235s0lik19.jpg)

而新的 HTTP Client 界面是这样的：

![rest-api.http](http://wx3.sinaimg.cn/large/a6e9cb00ly1g2us41sv2mj21d30u0qv5.jpg)


