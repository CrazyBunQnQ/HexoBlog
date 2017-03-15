---
title: 经典 bug 集锦
date: 2017-03-15 15:15:15
categories: 杀虫
tags: 
- Debug
- 调试
- 错误
- 异常
---

## An API baseline has not been set for the current workspace.	

Windows → Preferences → Plug-in Development → API Baselines
在 Options 里找到  Missing API baseline ，根据自己的情况改成 Warning 或者 Ignore，点击 Apply 应用即可。

>建议在[这里](http://www.ibm.com/developerworks/library/os-eclipse-api-tools/)研读一下 API baselines ，然后再决定这些 API baselines 是否对你有用。