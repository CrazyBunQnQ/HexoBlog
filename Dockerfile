# node 环境镜像
FROM node:buster AS build-env
# 创建 hexo-blog 文件夹且设置成工作文件夹
WORKDIR /usr/src
# 1.安装 hexo 及所需插件
#   - 搜索插件
#   - 字数统计插件
#   - 中文链接转拼音插件
#   - RSS 订阅插件
#   - emoji 表情插件
# 2.下载主题
# 3.下载文章
# 4.初始化博客目录
# 5.移动主题到博客目录
# 6.移动文章到源文件目录
# 7.进入博客目录
# 8.更新 hexo 配置文件
# 9.更新主题配置文件
# 10.清理目录兵重新生成静态文件
RUN npm install hexo-cli -g && \
npm install --save hexo-generator-search hexo-wordcount hexo-permalink-pinyin hexo-generator-feed hexo-filter-github-emojis && \
git clone https://github.com/CrazyBunQnQ/hexo-theme-matery.git matery && \
git clone https://github.com/CrazyBunQnQ/HexoBlog.git source && \
hexo init hexo-blog && \
mv matery hexo-blog/themes/ && \
rm -r hexo-blog/source && mv source hexo-blog/ && \
cd hexo-blog && \
mv ./source/hexo_config.yml ./_config.yml && \
mv ./source/_config.yml ./themes/matery/_config.yml && \
hexo clean && hexo g

# nginx 镜像
FROM nginx:latest
# 维护者信息
MAINTAINER CrazyBunQnQ "crazybunqnq@gmail.com"

# 设置镜像时区环境变量
ENV TZ=Asia/Shanghai

# 给 app.sh 赋予可执行权限, 并设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#COPY . /usr/share/nginx/html/
WORKDIR /usr/share/nginx/html

# 把上一部生成的 HTML 文件复制到 Nginx 中
COPY --from=build-env /usr/src/hexo-blog/public /usr/share/nginx/html
EXPOSE 80 443

# docker run -itd --name blog-matery -p 8081:80 --restart always crazybun/blog-matery:69
# docker run -itd --name blog-matery -p 80:80 -p 443:443 --restart=always \
# -v /root/DockerData/Blog/html:/usr/share/nginx/html \
# -v /root/DockerData/Blog/etc/letsencrypt:/etc/letsencrypt \
# -v /root/DockerData/Blog/var/lib/letsencrypt:/var/lib/letsencrypt \
# crazybun/blog-matery