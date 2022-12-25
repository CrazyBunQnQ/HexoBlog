---
title: IDEA 插件开发入门
date: 2022-12-22 22:22:22
img: "/images/IDEALogo.png"
cover: fasle
coverImg: "/images/IDEALogo.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: Java
tags:
  - JetBrains Plugin
  - Plugin
keywords: 插件
summary: 一直想开发自己的插件来着，正好工作中有机会了，学习学习~
---

一直想开发自己的插件来着，正好工作中有机会了，研究研究~

<!--more-->

## 开发环境搭建

### 开发工具

所有 JetBrains 旗下的集成开发工具插件都通过 [IntelliJ IDEA](https://www.jetbrains.com/idea/) 进行开发

IntelliJ IDEA 分为两个版本:

- 社区版(Community): 完全免费，代码开源，但是缺少一些旗舰版中的高级特性
- 旗舰版(Ultimate): 30 天免费，支持全部功能，代码不开源，学生有打折

在开发插件的过程中，不管你用的哪个版本的 IDEA，都会自动下载社区版源代码进行调试的

### 启用 Plugin DevKit

Plugin DevKit 本身就是 IntelliJ 的一个插件，它使用 IntelliJ IDEA 自己的构建系统来为开发 IDEA 插件提供插件开发的支持, 所以开发 IDEA 插件之前需要先安装并启用 Plugin DevKit

![Enable Plugin DevKit](/images/IDEAEnablePluginDevKit.png)

### 配置插件开发工具包

> 这里默认大家都已经安了 JDK 并且添加到 IDEA 中了...没有的话安装与添加方式与本节一致

IntelliJ Platform Plugin SDK 就是开发 IntelliJ 平台插件的开发工具包, 是基于 JDK 之上运行的, 类似于开发 Java 应用需要 JDK(Java SDK), 开发 Android 应用需要 Android SDK

这里添加方式跟添加 JDK 一样, 打开项目结构设置，在全局 SDK 中添加 IntelliJ Platform Plugin SDK，就是你本地 IDEA 安装目录，其他设置默认即可

![Add IntelliJ Platform Plugin SDK](/images/IDEAAddPluginSDK.png)

这里会比添加 JDK 多一个沙盒主页，默认就星，在调试插件时启动的 IDEA 就是运行在这里的，不会影响当前的 IntelliJ IDEA

但是同一台机器同时开发多个插件时默认使用的同一个沙盒，即在创建 IntelliJ Platform SDK 时默认指定的沙盒主页

## 创建插件项目

搞定开发环境之后，新建项目时选择 IDE 插件，设置项目信息后点击确定就会打开新的项目窗口

![](/images/IDEACreatePluginProject.png)

### 项目结构

项目打开后, 项目结构如下，还是我们很熟悉的项目结构

![](/images/IDEAPluginProjectStructure.png)

开发过程中，我们主要关注以下内容:

- src: 源码和资源目录
  - 源码在 /main/java 下面
  - 资源文件在 /main/resources 下面, 其中在 META-INF 中已经创建了两个文件
    - plugin.xml: 插件配置文件，开发过程中各种插件相关配置都在这里面，后面会详细说明
    - pluginIcon.svg: 插件图标文件，这是自动创建的默认图标，我们可以自行更改
  - 如果需要写单元测试，跟往常一样，可以在 src 创建 main 的同级目录 /test/java 放入测试代码和测试资源
- build.gradle.kts: 类似 Maven 项目的 pom.xml 文件，是项目的依赖与编译等配置
- settings.gradle.kts: 项目属性，例如项目名称和自定义依赖仓库地址设置在这里，一般不需要改动

其他文件不需要修改

### 依赖下载及项目构建

跟 Maven 项目很像, 侧边栏也会有个 Gradle 栏

![](/images/IDEAPluginGradle.png)

并且会像 Maven 项目一样，点击刷新按钮自动下载依赖，并且包括 IDEA 社区版及其源码, 很方便

![](/images/IDEADownloadIC.png)
![](/images/IDEADownloadICSrc.png)
![](/images/IDEAPluginDownloadDependency.png)

### 插件配置

下面是 plugin.xml 配置的主要元素

```xml
<!-- 插件配置文件。阅读更多: https://plugins.jetbrains.com/docs/intellij/plugin-configuration-file.html -->
<idea-plugin>
  <!-- 插件唯一id，不能和其他插件项目重复，所以推荐使用 com.xxx.xxx 的格式
       插件不同版本之间不能更改，若没有指定，则与插件名称相同 -->
  <id>com.example.demo1</id>

  <!-- 插件名称，别人在官方插件库搜索你的插件时使用的名称 -->
  <name>Demo1</name>

  <!-- 供应商主页和 email, 就是告诉用户作者是谁，万一有人给你打赏呢 -->
  <vendor url="http://www.jetbrains.com" email="support@jetbrains.com"/>

  <!-- 插件页面和 IDE 插件管理器上显示的插件说明。可以在 <![CDATA[ ]]> 标记内添加简单的 HTML 元素（文本格式、段落和列表）。
       Guidelines: https://plugins.jetbrains.com/docs/marketplace/plugin-overview-page.html#plugin-description -->
  <description><![CDATA[
    在此处输入您的插件的简短描述。<br>
    <em>大多数 HTML 标签都可以使用</em>
  ]]></description>

  <!-- 产品和插件兼容性要求, 就是插件所依赖的其他插件的 id. 注意，是插件，不是依赖包
       Read more: https://plugins.jetbrains.com/docs/intellij/plugin-compatibility.html -->
  <!-- 请参阅 http:www.jetbrains.orgintellijsdkdocsbasicsgetting_startedplugin_compatibility.html 了解如何针对不同的产品 -->
  <depends>com.intellij.modules.platform</depends>

  <!-- 插件定义的扩展点, 声明该插件对 IDEA core 或其他插件的扩展
       Read more: https://plugins.jetbrains.com/docs/intellij/plugin-extension-points.html -->
  <extensions defaultExtensionNs="com.intellij">
  </extensions>

  <!-- 以上是创建项目时默认创建的配置, 下面时可以额外进行添加的配置 -->

  <!-- 插件版本变更信息，支持HTML标签；可以在 <![CDATA[ ]]> 标记内添加简单的 HTML 元素（文本格式、段落和列表）。
       将展示在 settings | Plugins 对话框和插件仓库的Web页面 -->
  <change-notes>Initial release of the plugin.</change-notes>

  <!-- 插件版本 -->
  <version>1.0</version>

  <!-- 插件兼容 IDEA 的最大和最小 build 号，两个属性可以任选一个或者同时使用
       官网详细介绍：http://www.jetbrains.org/intellij/sdk/docs/basics/getting_started/build_number_ranges.html-->
  <idea-version since-build="3000" until-build="3999"/>

  <!-- 应用级组件声明 -->
  <application-components>
    <component>
      <!-- 组件接口 -->
      <interface-class>com.foo.Component1Interface</interface-class>
      <!-- 组件的实现类 -->
      <implementation-class>com.foo.impl.Component1Impl</implementation-class>
    </component>
  </application-components>

  <!-- 项目级组件声明 -->
  <project-components>
    <component>
      <!-- 接口和实现类相同 -->
      <interface-class>com.foo.Component2</interface-class>
    </component>
  </project-components>

  <!-- 模块级组件声明 -->
  <module-components>
    <component>
      <interface-class>com.foo.Component3</interface-class>
      <implementation-class>com.foo.impl.Component3Impl</implementation-class>
    </component>
  </module-components>

  <!-- 定义各种动作 -->
  <actions>
    <!-- 自定义组 -->
    <group id="TestMenu" text="测试菜单" popup="true">

    </group>
  </actions>

  <!-- 插件定义的扩展点，以供其他插件扩展该插件 -->
  <extensionPoints>
  </extensionPoints>
</idea-plugin>
```

### 项目配置

build.gradle.kts 示例:

```kotlin
plugins {
  // Java support
  id("java")
  // Gradle IntelliJ Plugin
  id("org.jetbrains.intellij") version "1.11.0"
}

// 组
group = "com.example"
// 插件版本号
version = "1.0-SNAPSHOT"

// 依赖仓库，这里使用了默认的 Maven 仓库, 也可以在此处添加自定义仓库, 比如网络不好可以设置国内仓库
repositories {
  maven {
    setUrl("https://maven.aliyun.com/nexus/content/groups/public/")
    setUrl("https://oss.sonatype.org/content/repositories/snapshots/")
  }
  mavenCentral()
  gradlePluginPortal()
}

// 配置 Gradle IntelliJ 插件, 可以参考: https://plugins.jetbrains.com/docs/intellij/tools-gradle-intellij-plugin.html
intellij {
  // 设置插件名称
  pluginName.set("CrazyGPT")
  // 开发时沙盒中运行的 IDE 版本号
  version.set("2021.3.3")
  // 开发时沙盒中运行的 IDE 版本, 使用社区版可以根据源码更方便的调试插件
  type.set("IC")

  // 插件依赖
  plugins.set(listOf(/* Plugin Dependencies */))
}

tasks {
  // 设置 JVM 兼容版本
  withType<JavaCompile> {
    sourceCompatibility = "11"
    targetCompatibility = "11"
    options.encoding = "UTF-8"
  }

  // 设置 Kotlin 兼容版本
  withType<KotlinCompile> {
    kotlinOptions.jvmTarget = "11"
  }

  // 设置 Gradle 版本
  wrapper {
    gradleVersion = "7.6"
  }

  // 设置插件兼容版本
  patchPluginXml {
    // 插件版本
    version.set("1.0-SNAPSHOT")
    // 支持的最早 IDE 版本
    sinceBuild.set("222.2680.4")
    // 支持的最新 IDE 版本
    untilBuild.set("223.*")
    changeNotes.set("init.")
  }

  signPlugin {
    certificateChain.set(System.getenv("CERTIFICATE_CHAIN"))
    privateKey.set(System.getenv("PRIVATE_KEY"))
    password.set(System.getenv("PRIVATE_KEY_PASSWORD"))
  }

  publishPlugin {
    token.set(System.getenv("PUBLISH_TOKEN"))
  }
}
```

build.gradle.kts 配置与 plugin.xml 配置中有一些重复的配置项，如果两边都设置了，则以 build.gradle.kts 为准

### 添加操作

![](/images/IDEAPluginAddAction1.png)

新建操作之后就会自动在 plugin.xml 中添加一个 action 标签，并且绑定该操作对应的类

![](/images/IDEAPluginAddAction2.png)

在这个操作类中可以添加该操作的业务逻辑

### 添加窗体

![](/images/IDEAPluginAddWindow1.png)
![](/images/IDEAPluginAddWindow2.png)

创建完窗体后，会自动创建窗体类(.java)以及一个同名的窗体设计文件(.form), 窗体设计文件打开之后就长这样，可以理解为 Web 开发的一个前端页面, 只不过是用 Java 写的

![](/images/IDEAPluginAddWindow3.png)

在设计文件中可以拖拽需要的控件到窗体中，会自动在窗体类中添加该变量，在控件上可以创建侦听器，来添加对应控件的各种业务逻辑

## 运行与调试项目

在 Gradle 中，运行 Tasks → intellij → runIde 就可以在沙盒中运行安装了此插件的 IDEA 了，版本为上面指定的 2021.3.3 社区版

![](/images/IDEARunIDE.png)

运行一次之后，会自动添加运行配置，之后再想运行/调试就跟平时我们启动 Spring 项目一样，点上面的运行/调试按钮就可以了

在运行的插件 IDEA 中，可以看到插件已经安装上了

![](/images/IDEAShowPluginInfo.png)

> 为啥是英文的呢? 因为我本地 IDEA 安了很多插件，沙盒里的 IDEA 除了内置插件以外，只安装了此插件，没有中文插件

## 插件打包及发布

与 Maven 类似，这里运行 Gradle buildPlugin 就可以打包了，会将所有依赖包一起打一个可以手动从磁盘安装的压缩包

![](/images/IDEABuildPlugin.png)

打包好的插件安装包会存放在项目的 /build/distributions/ 目录下

![](/images/IDEAPluginZip.png)

把压缩包发给你的朋友就可以让他们体验以下你写的插件了

如果你想要发布你的插件到 JetBrains 插件仓库的话，执行 Gradle publishPlugin 就可以发布了，但是这需要你配置好你的 JetBrains 账号及 Token

> 我水平比较菜，还没到发布插件的成都，想了解的可以自行研究研究...