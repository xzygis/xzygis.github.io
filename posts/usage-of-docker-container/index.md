# Docker之容器使用


## 获取镜像
```
$ docker pull ubuntu
```

## 启动容器：
```
$ docker run -it ubuntu /bin/bash
# 要退出终端，直接输入 exit
```

<!-- more -->

## 启动已停止运行的容器
```
$ docker ps -a
```

## 启动已停止运行的容器
```
$ docker start b750bbbcfd88 
```

## 后台运行
```
$ docker run -itd --name ubuntu-test ubuntu /bin/bash
```

## 停止一个容器
```
$ docker stop <容器 ID>
```

停止的容器可以通过 docker restart 重启：
```
$ docker restart <容器 ID>
```

## 进入容器
在使用 `-d` 参数时，容器启动后会进入后台。此时想要进入容器，可以通过以下指令进入：

- `docker attach`： 如果从这个容器退出（`exit`），会导致容器的停止。
- `docker exec`：推荐大家使用 `docker exec` 命令，因为此退出容器终端，不会导致容器的停止。

exec命令使用：
```
$ docker exec -it 243c32535da7 /bin/bash
```

## 导出和导入容器

### 导出容器
```
$ docker export 1e560fca3906 > ubuntu.tar
```


### 导入容器
```
$ cat docker/ubuntu.tar | docker import - test/ubuntu:v1
```
或
```
$ docker import docker/ubuntu.tar test/ubuntu:v1 
```

也可以通过指定 URL 或者某个目录来导入，例如：
```
$ docker import http://example.com/exampleimage.tgz example/imagerepo
```

参考来源：

[1] https://www.runoob.com/docker/docker-container-usage.html


---

> 作者: [chuxing](https://github.com/xzygis)  
> URL: https://xzygis.github.io/posts/usage-of-docker-container/  

