---
title: 如何通过GitHub+Hexo搭建博客
date: 2020-01-27 21:52:50
tags: ["hexo"]
categories: ["其他"]
---


## 安装Node
```
$ brew install node
```

## 安装Hexo
```
$ npm install -g hexo
```

## 初始化Hexo
```
$ hexo init
```

## 生成网页文件和开启服务器
```
$ hexo g
$ hexo s
```

<!-- more -->

## 关联Github

1. 修改`_config.yml`，修改deploy为：
```
deploy:
  type: 'git'
  repository: https://github.com/xzygis/xzygis.github.io.git
  branch: master
```

2. 生成静态文件并上传Github
```
$ hexo g
$ hexo d
```

若执行`hexo d`出错则执行`npm install hexo-deployer-git --save`。

执行`hexo d`会提示输入用户名密码。

## 配置next主题
在blog目录下执行
```
git clone --branch v5.1.4 https://github.com/iissnan/hexo-theme-next themes/next
```

修改`_config.yml`，设置theme为next。

