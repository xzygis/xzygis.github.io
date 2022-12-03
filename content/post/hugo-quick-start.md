---
title: "Hugo Quick Start"
date: 2022-12-03T19:21:25+08:00
tags: ["hugo"]
categories: ["hugo"]
draft: false
---

# Intall
```shell
go install github.com/gohugoio/hugo@latest
```

# Quick Start
> https://gohugo.io/getting-started/quick-start/

运行以下命令创建一个使用`Ananke`主题的网站：
```shell
hugo new site quickstart
cd quickstart
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke themes/ananke
echo "theme = 'ananke'" >> config.toml
hugo server
```

# Add Content
给网站增加新的网页：
```shell
hugo new posts/my-first-post.md
```
Hugo在`content/posts`目录创建了`my-first-post.md`文件，文件内容如下：
```shell
---
title: "My First Post"
date: 2022-11-20T09:03:20-08:00
draft: true
---
```

修改并保存文件后启动Hugo服务器可以预览网站，可以使用以下的任一命令以包含draft内容：
```shell
hugo server --buildDrafts
hugo server -D
```

# Configure the site
可以通过根目录的`config.toml`文件配置网站相关信息：
```shell
baseURL = 'http://example.org/'
languageCode = 'en-us'
title = 'My New Hugo Site'
theme = 'ananke'
```

# Publish the site
生成站点的静态文件，文件将生成到根目录下的`public`目录
```shell
hugo
```

# Host on GitHub


参考：
https://www.xianmin.org/post/2022/07-familiar-one-keybinding-style/


Ref：

[1] GitHub：https://github.com/gohugoio/hugo
