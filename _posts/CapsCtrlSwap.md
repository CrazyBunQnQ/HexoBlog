---
title: Caps 键与 Ctrl 键互换
date: 2018-01-01 11:11:11
categories: 触类旁通
tags:
- Keyboard
- Ctrl
- Caps
---

## 2018 年的第一篇文章

如果你经常用到 Ctrl 键，便会为他的位置打抱不平，而 Capslock 键则有种占着茅坑不那啥的感觉，特别是其功能几乎完全可以被 Shift 键所代替。

再加上我用了 HHKB 键盘之后，感觉 HHKB 的键位布局很舒服，之后再用普通键盘就很难受，于是，交换这两个键的位置便是明智之举。

查找了各种方法之后，感觉修改注册表是最完美的方法。

<!--more-->

## Caps 与 Ctrl 互换

>将下面的文本保存为 `.reg` 格式的文件，然后双击后重启即可

```json
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]
"Scancode Map"=hex:00,00,00,00,00,00,00,00,03,00,00,00,1D,00,3A,00,3A,00,1D,00,00,00,00,00
```

<br/>
## 只将 Caps 改为 Ctrl

>如果你像我一样完全不再使用 Caps 键的话，可以把两个键都设置为 Ctrl 键

```json
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]
"Scancode Map"=hex:00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00
```

同样将上面的文本保存为 `.reg` 格式的文件，然后双击后重启即可

## 补充说明

将修改注册表的操作保存成 `.reg` 文件很神奇啊，用起来很方便，双击一下就改啦！

所以就顺便了解了下 `.reg` 注册表文件的格式。

**往注册表中添加键值**就如上面一样，不说啦，下面补充下如何删除注册表。

### 删除整个子项

直接在这项路径前加一个连字符 `-` 即可。

```json
Windows Registry Editor Version 5.00
[-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]
```

就像上面这样，就会把 Keyboard Layout 这个子项及其下的所有内容删除。<font color="#FF6699">这里只是举个例子！别把这个删了！</font>

### 删除子项中的某一键值

直接用上面的例子来讲，删除子项 `Keyboard Layout` 下的一个 `Scancode Map` 键值就像这样：

```json
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]
"Scancode Map"=-
```

>把这个文件也保存成 `.reg` 的话，加上面的两个 `reg` 文件，就可以三种模式随意切换啦！
>喜欢哪个，双击哪个~

## macOS 中 Caps 键与 Ctrl 键互换

macOS 中互换 Caps 键和 Ctrl 键很方便，直接在 `系统偏好设置>键盘>修饰键...` 中改一下就好啦！

![CapsCtrlSwap](http://wx4.sinaimg.cn/mw690/a6e9cb00gy1fn2kw2233gj20n60f6gox.jpg)