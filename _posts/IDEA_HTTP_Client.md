---
title: 使用 IDEA 自带的 HTTP Client 来测试 API
date: 2019-05-04 22:22:22
categories: 开发工具
tag:
  - 工具
  - 效率
keywords: IDEA
summary: 对于 API 测试，常用的方式大多是通过浏览器发送请求、Postman 等 API 工具来测试 API
---

## HTTP Client 介绍

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

## HTTP Client 用法

### 请求方式

#### 普通 Get 请求

```http request
GET http://it.yusys.com.cn/yusys/PictureCheckCode.jpeg?nocache={{$timestamp}}
Accept: application/json
```

#### POST Json 请求

```http request
POST http://localhost:80/api/item
Content-Type: application/json

{}
```

#### POST 表单请求

```http request
POST http://localhost:80/api/item
Content-Type: application/x-www-form-urlencoded

id=99&content=new-element
```

#### POST 文本请求

```http request
POST http://localhost:80/api/item
Content-Type: multipart/form-data; boundary=WebAppBoundary

--WebAppBoundary
Content-Disposition: form-data; name="field-name"

field-value
--WebAppBoundary--
```

#### POST 文件请求

```http request
POST {{url}}/api/item
Content-Type: multipart/form-data; boundary=WebAppBoundary

--WebAppBoundary
Content-Disposition: form-data; name="field-name"; filename="file.txt"

< ./relative/path/to/local_file.txt
--WebAppBoundary--
```

#### 其他请求

还有其他类型的请求都支持，这里不做详细介绍了

- `PUT` 
- `DELETE` 
- ...

### 自定义配置

有时候同一个 api 有多个环境，尤其开发过程中，有本地、测试、生产的环境，每个环境的地址不一样

这时候就可以在创建一个配置文件 `http-client.env.json` 放在与 `http` 文件相同路径，设置如下：

```json
{
    "development": {
        "url": "http://localhost:8080"
    },
    "production": {
        "url": "http://123.234.6.191"
    }
}
```

这样就可以在请求中使用 `{{url}}` 来发送不同环境的请求啦

发送请求时会让你选择 `development` 还是 `production`

是不是非常方便？

### 动态参数

HTTP Client 自带几个动态参数，每次运行请求时，动态参数都会生成一个新值:

- `$uuid`: 生成通用唯一标识符（UUID-v4）
- `$timestamp`: 生成当前的 UNIX 时间戳
- `$randomInt`: 生成 0 到 1000 之间的随机整数

示例见第一个 `GET` 请求

### 请求后执行 JS 脚本

待续...

