---
title: 经典 bug 集锦
date: 2017-03-15 15:15:15
categories: 杀虫
tags: 
- Debug
- 调试
- 错误
- 异常
- Issues
---

什么是经验？经验，就是遇到问题之后，你通过努力把它解决了，这就是你的经验！

<!-- more -->

在程序员的道路上，会遇到各种各样的问题和错误，我认为我不可能记住每一个问题的解决方式，好脑子不如烂笔头嘛，所以我要把我今后遇到的各种问题与错误都记录在这里～

## An API baseline has not been set for the current workspace.	

Windows → Preferences → Plug-in Development → API Baselines
在 Options 里找到  Missing API baseline ，根据自己的情况改成 Warning 或者 Ignore，点击 Apply 应用即可。

>建议在[这里](http://www.ibm.com/developerworks/library/os-eclipse-api-tools/)研读一下 API baselines ，然后再决定这些 API baselines 是否对你有用。