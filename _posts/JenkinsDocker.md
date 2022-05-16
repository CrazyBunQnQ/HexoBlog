---
title: Jenkins 构建并运行 Docker 镜像
date: 2022-06-06 22:22:22
img: "/images/JenkinsAndDocker.png"
cover: false
coverImg: "/images/JenkinsAndDocker.png"
password: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
toc: false
mathjax: false
categories: Jenkins
tags:
- Docker
- Jenkins
keywords: Docker
summary: 使用 Jenkins 自动构建并运行 Docker 镜像
---

## 准备工作

- Jenkins 环境
- Jenkins 服务器能够连接的 Docker 环境
- Dockerfile 文件

## 创建连接 Docker 的证书

Jenkins 的 Docker 插件只能通过 TCP 方式进行连接，安全起见，我们需要创建用来连接 Docker 的证书，我已经被黑了 3 次了，受够了！

```shell
# 创建根证书 RSA 私钥: 此处需要两次输入密码，请务必记住该密码，在后面步骤会用到
openssl genrsa -aes256 -out docker-ca-key.pem 4096
# 创建 CA 证书，以上一步生成的私钥创建证书，也就是自签证书，也可从第三方 CA 机构签发
# 输入国家代码，州，市，组织名称，组织单位，你的名字，邮箱地址
openssl req -new -x509 -days 3650 -key docker-ca-key.pem -sha256 -out docker-ca.pem
# 创建服务端私钥:
openssl genrsa -out server-key.pem 4096
# 创建服务端签名请求证书文件: 其中的 IP 地址为自己服务器IP地址
openssl req -subj "/CN=172.31.128.152" -sha256 -new -key server-key.pem -out server.csr
# 创建 extfile.cnf 的配置文件: 其中 IP 地址改为自己服务器IP地址
echo subjectAltName = IP:172.31.128.152,IP:0.0.0.0 >> extfile.cnf
echo extendedKeyUsage = serverAuth >> extfile.cnf
# 创建签名生效的服务端证书文件:
openssl x509 -req -days 3650 -sha256 -in server.csr -CA docker-ca.pem -CAkey docker-ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
# 创建客户端私钥:
openssl genrsa -out client-key.pem 4096
# 创建客户端签名请求证书文件:
openssl req -subj '/CN=client' -new -key client-key.pem -out client.csr
# extfile.cnf 文件中增加配置:
echo extendedKeyUsage = clientAuth >> extfile.cnf
# 创建签名生效的客户端证书文件:
openssl x509 -req -days 3650 -sha256 -in client.csr -CA docker-ca.pem -CAkey docker-ca-key.pem -CAcreateserial -out client-cert.pem -extfile extfile.cnf
# 删除无用文件:
rm -v client.csr server.csr
# 为证书文件授权:
chmod -v 0400 docker-ca-key.pem client-key.pem server-key.pem
chmod -v 0444 docker-ca.pem server-cert.pem client-cert.pem
# 查看证书有效期
openssl x509 -in docker-ca.pem -noout -dates
# 创建存放证书的目录，并将所需的证书文件拷进去
mkdir /etc/docker/cert
cp docker-ca.pem /etc/docker/cert/
cp client-cert.pem /etc/docker/cert/
cp client-key.pem /etc/docker/cert/
```

以上 `docker-ca.pem` `client-cert.pem` `client-key.pem` 这三个是我们客户端调用所需的证书文件

## 配置 Docker 支持 TLS 连接

编辑 docker.service 配置文件

```shell
vim /lib/systemd/system/docker.service
```

将原 `ExecStart=` 行注释，添加一行:

```shell
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --tlsverify --tlscacert=/etc/docker/cert/docker-ca.pem --tlscert=/etc/docker/cert/client-cert.pem --tlskey=/etc/docker/cert/client-key.pem --containerd=/run/containerd/containerd.sock
```

> 此处设置 docker 远程端口为 2375，可根据需要修改

刷新配置，重启 Docker

```shell
systemctl daemon-reload && systemctl restart docker
```

## Jenkins 配置 Docker 集群

1. 进入 `Dashbord` -> `系统管理` -> `节点管理` -> `Configure Clouds` 配置集群界面
2. `Add a new cloud` 选择 Docker
3. 点击 `Docker Cloud details...` 按钮
   1. 设置 Docker 集群名称
   2. 设置 `Docker Host URI`: `tcp://172.31.128.152:2375`
       > 此处 ip 为此 Jenkins 服务器能够连接到的 Docker 服务器 ip 地址
   3. 设置 `Server credentials`
      1. `添加` 连接 Docker 集群的凭证
         1. 选择`全局凭证`
         2. 类型选择 `X.509 Client Certificate`
         3. 范围选择`全局`
         4. Client Key 点击添加，将上面生成的 `client-key.pem` 文本内容粘贴进去
         5. Client Certificate 将上面生成的 `client-cert.pem` 文本内容粘贴进去
         6. Server CA Certificate 将上面生成的 `docker-ca.pem` 文本内容粘贴进去
         7. ID 设置为容易辨认的凭证名称 `docker-38-cert`，避免混淆
             ![添加连接 Docker 的凭证](/images/JenkinsDockerCredential.png)
      2. 选择上面添加的凭证 `docker-38-cert`
   4. 勾选 `Enabled` 选项

![img.png](/images/JenkinsDockerConfig.png)

## Jenkins 配置构建步骤

### 构建镜像

在项目配置中的`构建`步骤中添加 `Build / Publish Docker Image`:

![img.png](/images/BuildPublishDockerImage.png)

### 运行镜像

继续添加构建步骤 `执行 shell`:

```shell
# 删除中间镜像
docker rmi -f $(docker images | grep "^<none>" | awk '{print $3}')

# 删除此项目正在运行的 Docker 容器
cid=$(docker ps | grep $CONTAINER_NAME |awk '{print $1}')
if [ x"$cid" != x ]
    then
    docker rm -f $cid
fi

# 启动 Docker 容器
docker run -itd --name $CONTAINER_NAME -p $API_PORT:80 --restart always $IMAGE_NAME
```

[//]: # (srw-rw----  1 root  docker    0 May 13 23:22 docker.sock)