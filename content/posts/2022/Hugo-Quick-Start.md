---
title: "Hugo 快速入门"
date: 2022-12-03T19:21:25+08:00
tags: ["hugo"]
categories: ["博客"]
draft: false
---

Hugo是由Go语言实现的静态网站生成器。简单、易用、高效、易扩展、快速部署。

## Intall
```shell
go install github.com/gohugoio/hugo@latest
```

## Quick Start
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

## Add Content
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

## Configure the site
可以通过根目录的`config.toml`文件配置网站相关信息：
```shell
baseURL = 'http://example.org/'
languageCode = 'en-us'
title = 'My New Hugo Site'
theme = 'ananke'
```

## Publish the site
生成站点的静态文件，文件将生成到根目录下的`public`目录
```shell
hugo
```

## Host on GitHub
> https://gohugo.io/hosting-and-deployment/hosting-on-github/

1. 创建名为`<USERNAME>.github.io` 或 `<ORGANIZATION>.github.io`的GitHub仓库
2. 在仓库中新增文件`.github/workflows/gh-pages.yml`并填写以下内容：
```yaml
name: github pages

on:
  push:
    branches:
      - main  # Set a branch that will trigger a deployment
  pull_request:

jobs:
  deploy:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          # extended: true

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/main'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

把`config.toml`中的`baseURL`修改为`https://<USERNAME>.github.io`。

Ref：
1. https://github.com/gohugoio/hugo
2. https://www.xianmin.org/post/2022/07-familiar-one-keybinding-style/
