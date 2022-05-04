# node 环境镜像
FROM node:buster AS build-env

# 传入构建变量, 构建时生效
ARG GITHUB_TOKEN
ARG GITHUB_EMAIL
ARG GITHUB_NAME
# 设置环境变量，镜像运行时生效
ENV GITHUB_TOKEN_ENV=${GITHUB_TOKEN}

# 创建 hexo-blog 文件夹且设置成工作文件夹
WORKDIR /usr/src

# 安装 hexo
RUN npm install hexo-cli -g && \
# 下载主题
git clone https://github.com/CrazyBunQnQ/hexo-theme-matery.git matery && \
# 下载文章
git clone https://github.com/CrazyBunQnQ/HexoBlog.git source && \
# 初始化博客目录
hexo init hexo-blog && \
# 移动主题到博客目录
mv matery hexo-blog/themes/ && \
# 移动文章到源文件目录
rm -r hexo-blog/source && mv source hexo-blog/ && \
# 进入博客目录
cd hexo-blog && \
# 安装所需插件
#   - github 部署插件
#   - 搜索插件
#   - 字数统计插件
#   - 中文链接转拼音插件
#   - RSS 订阅插件
#   - emoji 表情插件
npm install --save hexo-deployer-git hexo-generator-search hexo-wordcount hexo-permalink-pinyin hexo-generator-feed hexo-filter-github-emojis && \
# 更新 hexo 配置文件
mv ./source/hexo_config.yml ./_config.yml && \
# 设置 hexo 配置文件的 github token
sed -i "s/\${GITHUB_TOKEN}/$GITHUB_TOKEN/" _config.yml && \
# 更新主题配置文件
mv ./source/_config.yml ./themes/matery/_config.yml && \
# 设置 git 邮箱和用户名
git config --global user.email "$GITHUB_EMAIL" && \
git config --global user.name "$GITHUB_NAME" && \
# 清理博客目录、重新生成静态文件
hexo clean && hexo g\
# 部署到 github(此镜像为中间镜像，上面设置的环境变量此时不生效，hexo d 无法从环境变量中读取 token)
 && hexo d

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