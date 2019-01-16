---
title: I/O 流的简单应用
date: 2017-10-22 22:22:22
categories: Java 基础
tags:
- I/O 流
- 输入输出流
---

<style type="text/css">
.sign {
    text-align:right;
    font-style:italic;
}
</style>

最近使用虚拟机遇到一个有尴尬的问题：

- 无法将文件复制到虚拟机中
- 但是可以复制纯文本内容粘贴到虚拟机中的编辑器里
- 由于特殊情况无法通过设置 VM tools 来解决上述问题...

>这种情况下有没有其他办法能把文件复制到虚拟机中呢？

<!--more-->

## 思考历程

计算机底层就是 0 和 1 嘛！所以任何数据肯定是可以字符串来表示的。
这时，我就想到了输入输出流，我们通过代码来读取文件、修改文件、复制文件、上传及下载文件都是先将文件转化成流的不是吗？

例如下面这个复制文件的代码：

```java
public static long forJava(File f1,File f2) throws Exception{
    long time = new Date().getTime();
    int length = 2097152;
    FileInputStream in = new FileInputStream(f1);
    FileOutputStream out = new FileOutputStream(f2);
    byte[] buffer = new byte[length];
    while (true) {
        int ins = in.read(buffer);
        if (ins == -1) {
            in.close();
            out.flush();
            out.close();
            return new Date().getTime() - time;
        } else
            out.write(buffer,0,ins);
    }
}
```

在复制文件的代码中，我们可以看到：

1. 程序先将原文件转化成了字节输入流
1. 将字节输入流写入到字节输出流
1. 将字节输出流转化成了新的文件

这个字节流不就是一堆数字吗？把这些数字保存起来，存放到一个 txt 文本里，不就可以复制到虚拟机里了吗？

### 代码实现

将上面的流程拆成两半，就可以实现从物理机复制文件到虚拟机中了：

1. 程序先将原文件转化成了字节输入流
1. 将字节数组转换成字符串（用“,”分隔每个字节）存入 txt 文件
1. 将 txt 文件中的文本复制粘贴到虚拟机中的空 txt 文件中
1. 将 txt 文件中的文本读取出来，并转换成字节数组，并写入字节输出流中
1. 将字节输出流转化成了新的文件

代码如下：

```java
//文件转 txt
public static void file2Text(String path, String name) throws IOException {
    File inFile = new File(path + File.separator + name);
    File writeTxt = new File(tmp);
    if (!inFile.exists()) {
        System.out.println("文件不存在");
        return;
    }
    if (!inFile.isFile()) {
        System.out.println("不是一个文件");
        return;
    }
    if (writeTxt.exists()) {
        writeTxt.delete();
    }
    writeTxt.createNewFile();
    BufferedWriter textWriter = new BufferedWriter(new FileWriter(writeTxt));
    FileInputStream fis = new FileInputStream(inFile);
    int len;
    byte[] bys = new byte[1024];
    while ((len = fis.read(bys, 0, bys.length)) != -1) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < len; i++) {
            if (i != 0)
                sb.append(",");
            int b = bys[i];
            sb.append(String.valueOf(b));
        }
        textWriter.write(sb.toString() + "\r\n");
        System.out.println(sb.toString());
    }
    fis.close();
    textWriter.close();
}
```

```java
// txt 转文件
public static void text2File(String path, String name) throws IOException {
    File outFile = new File(path + File.separator + name);
    File writeTxt = new File(tmp);
    if (outFile.exists()) {
        outFile.delete();
    }
    if (!writeTxt.exists() || !writeTxt.isFile()) {
        System.out.println("文件不存在");
        return;
    }
    BufferedReader textReader = new BufferedReader(new FileReader(writeTxt));
    FileOutputStream fos = new FileOutputStream(outFile);
    String line = textReader.readLine();
    while (line != null) {
        String[] arr = line.split(",");
        int len = arr.length;
        byte[] bys = new byte[1024];
        for (int i = 0; i < len; i++) {
            bys[i] = (byte) Integer.parseInt(arr[i]);
        }
        fos.write(bys, 0, len);
        line = textReader.readLine();
    }
    fos.close();
    textReader.close();
}
```

### 效果图：

![文本内容](http://wx3.sinaimg.cn/mw690/a6e9cb00gy1fl504quanuj20c20c676j.jpg) ![文件大小](http://wx3.sinaimg.cn/mw690/a6e9cb00gy1fl504pxerwj20ca0cajsi.jpg)

从效果图中可以看到，把数据转化为字节存入 txt 后，占用空间很大！
txt 文件大小甚至是原文件大小的 4 倍！每一个 byte 数值都要占用 1 到 4 位，
再加上我的虚拟机配置比较渣，拷贝这么多字符串进去很容易就编辑器搞挂了！
甚至连虚拟机都要一起跪...

## 优化性能

### Thinking Again...

怎么才能减少占用空间呢？

这时我突然想起，byte 是 java 数值型的基本类型啊！把它转化成 16 进制不就好了？
如果把 byte 转化成 16 进制的话，每一个 byte 都固定对应一个两位的 16 进制数字，
不会出现参差不齐的数字，这样的话连分隔符“,”都省下了！

### 修改后的代码：

```java
// 文件转 txt
public static void file2Text(String path, String txtPath) throws IOException {
    File inFile = new File(path);
    File writeTxt = new File(txtPath);
    if (!inFile.exists()) {
        System.out.println("文件不存在");
        return;
    }
    if (!inFile.isFile()) {
        System.out.println("不是一个文件");
        return;
    }
    if (writeTxt.exists()) {
        writeTxt.delete();
    }
    writeTxt.createNewFile();
    BufferedWriter textWriter = new BufferedWriter(new FileWriter(writeTxt));

    FileInputStream fis = new FileInputStream(inFile);
    int len;
    byte[] bys = new byte[2048];
    while ((len = fis.read(bys, 0, bys.length)) != -1) {
        StringBuffer sb = new StringBuffer();
        String str = bytes2HexString(len, bys);
        textWriter.write(str);
        textWriter.write(sb.toString() + "\r\n");
    }
    fis.close();
    textWriter.close();
}
```

```java
//文件转多个 txt
public static void file2Text(String path, String txtPath, int size) throws IOException {
    int m = 0;//记录当前 size
    int n = 1;//记录文件名
    boolean end = false;
    String nameTmp;
    String curTxtPath = "";
    File inFile = new File(path);
    if (!inFile.exists()) {
        System.out.println("文件不存在");
        return;
    }
    if (!inFile.isFile()) {
        System.out.println("不是一个文件");
        return;
    }
    FileInputStream fis = new FileInputStream(inFile);
    String directory = txtPath.substring(0, txtPath.lastIndexOf(File.separator));
    String name = txtPath.substring(txtPath.lastIndexOf(File.separator) + 1, txtPath.lastIndexOf("."));
    System.out.println("目录：" + directory + ", 名称：" + name);
    int len;//字节数组长度
    File writeTxt = null;
    BufferedWriter textWriter = null;

    while (!end) {
        nameTmp = curTxtPath;
        curTxtPath = directory + File.separator + name + n + ".txt";
        if (nameTmp != curTxtPath) {
            writeTxt = new File(curTxtPath);
            if (writeTxt.exists()) {
                writeTxt.delete();
            }
            writeTxt.createNewFile();
            System.out.println("创建新文件：" + curTxtPath);
            textWriter = new BufferedWriter(new FileWriter(writeTxt));
        }

        byte[] bys = new byte[2048];
        while ((len = fis.read(bys, 0, bys.length)) != -1) {
            String str = bytes2HexString(len, bys);
            textWriter.write(str);
            m++;
            if (m > size) {
                m = 0;
                break;
            }
        }
        end = len == -1;
        textWriter.close();
        n++;
    }
    fis.close();
}
```

```java
//字节数组转 16 进制字符串
public static String bytes2HexString(int len, byte[] bytes) {
    final String HEX = "0123456789abcdef";
    StringBuilder sb = new StringBuilder(bytes.length * 2);
    for (int i = 0; i < len; i++) {
        // 取出这个字节的高 4 位，然后与 0x0f 与运算，得到一个 0-15 之间的数据，通过 HEX.charAt(0-15)即为 16 进制数
        sb.append(HEX.charAt((bytes[i] >> 4) & 0x0f));
        // 取出这个字节的低位，与 0x0f 与运算，得到一个 0-15 之间的数据，通过 HEX.charAt(0-15)即为 16 进制数
        sb.append(HEX.charAt(bytes[i] & 0x0f));
    }
    return sb.toString();
}
```

```java
// txt 转文件
public static void text2File(String path, String txtPath) throws IOException {
    File outFile = new File(path);
    File writeTxt = new File(txtPath);
    if (outFile.exists()) {
        outFile.delete();
    }
    if (!writeTxt.exists() || !writeTxt.isFile()) {
        System.out.println("文件不存在");
        return;
    }
    BufferedReader textReader = new BufferedReader(new FileReader(writeTxt));

    FileOutputStream fos = new FileOutputStream(outFile);
    String line = textReader.readLine();
    System.out.println("line length: " + line.length());
    while (line != null) {
        byte[] bys = hexString2Bytes(line);
        fos.write(bys, 0, bys.length);
        line = textReader.readLine();
    }
    fos.close();
    textReader.close();
}
```

```java
// 16 进制字符串转字节数组
public static byte[] hexString2Bytes(String s) {
    int len = s.length();
    byte[] b = new byte[len / 2];
    for (int i = 0; i < len; i += 2) {
        // 两位一组，表示一个字节,把这样表示的 16 进制字符串，还原成一个字节
        b[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i + 1), 16));
    }
    return b;
}
```

### 效果图

![文本内容](http://wx1.sinaimg.cn/mw690/a6e9cb00gy1fl508t2zo7j20c60cadh0.jpg)

可以看到，这种方式转化的 txt 文件内容灰常灰常的密集！
密集恐惧症勿喷。。。文件大小缩小了很多很多！

## 新的疑问

细心的朋友可能会发现，刚才的 txt 文件大小刚好是原文件大小的 2 倍。
所以，是不是还有更高效的方法呢？比如转化后的数据大小跟原文件一模一样？

### 基于上述想法，我做了个测试：

1. 将原文件后缀改为“.txt”。
1. 用文本编辑器打开后可以看到也是十六进制数据，而且还有空格和换行。
1. 将这些文本复制到虚拟机中的 txt 中。
1. 将虚拟机中的 txt 文件后缀改为原文件后缀。
1. 此时打不开文件了，并且文件大小也发生了变化。

我现在还不知道是什么原因，只有一些猜测：

1. 系统位数不行
1. 平台不同
1. 编码不同

虽然暂时不可以，但我还是相信可以做到！

所以我想问下，有人知道这个数据格式叫啥名么？或者有人知道如何将字节数组转化成这种格式吗？
