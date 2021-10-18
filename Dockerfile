# node环境镜像
FROM crazybun/hexo-build-env:node-12 AS build-env
# 创建hexo-blog文件夹且设置成工作文件夹
WORKDIR /usr/src/hexo-blog
# 复制当前文件夹下面的所有文件到hexo-blog中
COPY . ./source/
# 更新配置好文件并生成静态文件
RUN mv ./source/_config.yml ./themes/matery/_config.yml && hexo clean && hexo g

# nginx镜像
FROM arm32v7/nginx:1.17.8
# 维护者信息
MAINTAINER CrazyBunQnQ "crazybunqnq@gmail.com"

# 设置镜像时区环境变量
ENV TZ=Asia/Shanghai

# 给app.sh赋予可执行权限, 并设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#COPY . /usr/share/nginx/html/
WORKDIR /usr/share/nginx/html

# 把上一部生成的HTML文件复制到Nginx中
COPY --from=build-env /usr/src/hexo-blog/public /usr/share/nginx/html
EXPOSE 80
