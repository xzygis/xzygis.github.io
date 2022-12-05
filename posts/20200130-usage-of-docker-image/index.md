# Docker之镜像使用


## 获取镜像
用法：
```
$ docker pull [OPTIONS] NAME[:TAG|@DIGEST]
```
例如：`docker pull ubuntu:18.04`

## 启动容器
```
$ docker run -it --rm ubuntu:18.04 bash
```
简要的说明一下上面用到的参数:

- `-it`：这是两个参数，一个是 `-i`表示交互式操作，一个是`-t`表示终端。我们这里打算进入 bash 执行一些命令并查看返回结果，因此我们需要交互式终端。
- `--rm`：这个参数是说容器退出后随之将其删除。默认情况下，为了排障需求，退出的容器并不会立即删除，除非手动 docker rm。我们这里只是随便执行个命令，看看结果，不需要排障和保留结果，因此使用`--rm` 可以避免浪费空间。
- `ubuntu:18.04`：这是指用 ubuntu:18.04 镜像为基础来启动容器。
- `bash`：放在镜像名后的是命令，这里我们希望有个交互式 Shell，因此用的是 bash。

<!-- more -->

## 查看镜像列表
使用`docker image ls`或者`docker images`:
```
$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              18.04               93fd78260bd1        5 weeks ago         86.2MB
ubuntu              latest              93fd78260bd1        5 weeks ago         86.2MB
hello-world         latest              4ab4c602aa5e        3 months ago        1.84kB

$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              18.04               93fd78260bd1        5 weeks ago         86.2MB
ubuntu              latest              93fd78260bd1        5 weeks ago         86.2MB
hello-world         latest              4ab4c602aa5e        3 months ago        1.84kB
```
列表包含了 仓库名、标签、镜像 ID、创建时间 以及 所占用的空间。


## 镜像体积
这里标识的所占用空间和在 Docker Hub 上看到的镜像大小不同。比如，`ubuntu:18.04` 镜像大小，在这里是 127 MB，但是在 Docker Hub 显示的却是 50 MB。这是因为 Docker Hub 中显示的体积是压缩后的体积。在镜像下载和上传过程中镜像是保持着压缩状态的，因此 Docker Hub 所显示的大小是网络传输中更关心的流量大小。而 `docker image ls` 显示的是镜像下载到本地后展开的大小，准确说，是展开后的各层所占空间的总和，因为镜像到本地后，查看空间的时候，更关心的是本地磁盘空间占用的大小。

另外一个需要注意的问题是，`docker image ls` 列表中的镜像体积总和并非是所有镜像实际硬盘消耗。由于 Docker 镜像是多层存储结构，并且可以继承、复用，因此不同镜像可能会因为使用相同的基础镜像，从而拥有共同的层。由于 Docker 使用 Union FS，相同的层只需要保存一份即可，因此实际镜像硬盘占用空间很可能要比这个列表镜像大小的总和要小的多。

你可以通过以下命令来便捷的查看镜像、容器、数据卷所占用的空间。
```
$ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              2                   2                   86.18MB             0B (0%)
Containers          14                  2                   148B                25B (16%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
```

## 虚悬镜像
由于新旧镜像同名，旧镜像名称被取消，从而出现仓库名、标签均为` <none> `的镜像。这类无标签镜像也被称为 虚悬镜像(dangling image) 。

## 中间层镜像
为了加速镜像构建、重复利用资源，Docker 会利用 中间层镜像。所以在使用一段时间后，可能会看到一些依赖的中间层镜像。默认的 docker image ls 列表中只会显示顶层镜像，如果希望显示包括中间层镜像在内的所有镜像的话，需要加 -a 参数。
```
$ docker image ls -a
```
这样会看到很多无标签的镜像，与之前的虚悬镜像不同，这些无标签的镜像很多都是中间层镜像，是其它镜像所依赖的镜像。这些无标签镜像不应该删除，否则会导致上层镜像因为依赖丢失而出错。实际上，这些镜像也没必要删除，因为之前说过，相同的层只会存一遍，而这些镜像是别的镜像的依赖，因此并不会因为它们被列出来而多存了一份，无论如何你也会需要它们。只要删除那些依赖它们的镜像后，这些依赖的中间层镜像也会被连带删除。

以特定格式显示：
```
$ docker image ls --format "{{.ID}}: {{.Repository}}"
93fd78260bd1: ubuntu
93fd78260bd1: ubuntu
4ab4c602aa5e: hello-world

$ docker image ls --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}"
IMAGE ID            REPOSITORY          TAG
93fd78260bd1        ubuntu              18.04
93fd78260bd1        ubuntu              latest
4ab4c602aa5e        hello-world         latest
```

## 删除本地镜像
如果要删除本地的镜像，可以使用 `docker image rm` 命令，其格式为：
```
$ docker image rm [选项] <镜像1> [<镜像2> ...]
```
其中，`<镜像>` 可以是 `镜像短 ID`、`镜像长 ID`、`镜像名` 或者 `镜像摘要`。

## Untagged 和 Deleted
如果观察上面这几个命令的运行输出信息的话，你会注意到删除行为分为两类，一类是`Untagged`，另一类是 `Deleted`。我们之前介绍过，镜像的唯一标识是其 ID 和摘要，而一个镜像可以有多个标签。

因此当我们使用上面命令删除镜像的时候，实际上是在要求删除某个标签的镜像。所以首先需要做的是将满足我们要求的所有镜像标签都取消，这就是我们看到的 Untagged 的信息。因为一个镜像可以对应多个标签，因此当我们删除了所指定的标签后，可能还有别的标签指向了这个镜像，如果是这种情况，那么 Delete 行为就不会发生。所以并非所有的 `docker image rm` 都会产生删除镜像的行为，有可能仅仅是取消了某个标签而已。

当该镜像所有的标签都被取消了，该镜像很可能会失去了存在的意义，因此会触发删除行为。镜像是多层存储结构，因此在删除的时候也是从上层向基础层方向依次进行判断删除。镜像的多层结构让镜像复用变动非常容易，因此很有可能某个其它镜像正依赖于当前镜像的某一层。这种情况，依旧不会触发删除该层的行为。直到没有任何层依赖当前层时，才会真实的删除当前层。

除了镜像依赖以外，还需要注意的是**容器对镜像的依赖**。**如果有用这个镜像启动的容器存在（即使容器没有运行），那么同样不可以删除这个镜像**。之前讲过，容器是以镜像为基础，再加一层容器存储层，组成这样的多层存储结构去运行的。因此该镜像如果被这个容器所依赖的，那么删除必然会导致故障。如果这些容器是不需要的，应该先将它们删除，然后再来删除镜像。

## 利用 commit 理解镜像构成
注意： `docker commit` 命令除了学习之外，还有一些特殊的应用场合，比如被入侵后保存现场等。但是，不要使用 `docker commit` 定制镜像，定制镜像应该使用 `Dockerfile` 来完成。

镜像是多层存储，每一层是在前一层的基础上进行的修改；而容器同样也是多层存储，是在以镜像为基础层，在其基础上加一层作为容器运行时的存储层。

现在让我们以定制一个 Web 服务器为例子，来讲解镜像是如何构建的。
```
$ docker run --name webserver -d -p 80:80 nginx
```
这条命令会用 `nginx` 镜像启动一个容器，命名为 webserver，并且映射了 `80` 端口，这样我们可以用浏览器去访问这个 `nginx` 服务器。

用浏览器访问的话，我们会看到默认的 `Nginx` 欢迎页面内容：
```
Welcome to nginx!

If you see this page, the nginx web server is successfully installed and working. Further configuration is required.

For online documentation and support please refer to nginx.org.
 Commercial support is available at nginx.com.

Thank you for using nginx.
```

如果我们想要修改欢迎页面的内容，可以使用 `docker exec` 命令进入容器，修改其内容。
```
$ docker exec -it webserver bash
root@3729b97e8226:/# echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
root@3729b97e8226:/# exit
exit
```
我们以交互式终端方式进入 `webserver` 容器，并执行了 `bash` 命令，也就是获得一个可操作的 Shell。

然后，我们用 `<h1>Hello, Docker!</h1>` 覆盖了 /usr/share/nginx/html/index.html 的内容。现在我们再刷新浏览器的话，会发现内容被改变了。

我们修改了容器的文件，也就是改动了容器的存储层。我们可以通过 `docker diff` 命令看到具体的改动。
```
$ docker diff webserver
C /usr
C /usr/share
C /usr/share/nginx
C /usr/share/nginx/html
C /usr/share/nginx/html/index.html
C /root
A /root/.bash_history
C /var
C /var/cache
C /var/cache/nginx
A /var/cache/nginx/scgi_temp
A /var/cache/nginx/uwsgi_temp
A /var/cache/nginx/client_temp
A /var/cache/nginx/fastcgi_temp
A /var/cache/nginx/proxy_temp
C /run
A /run/nginx.pid
```
当我们运行一个容器的时候（如果不使用卷的话），我们做的任何文件修改都会被记录于容器存储层里。Docker 提供了一个 `docker commit` 命令，可以将容器的存储层保存下来成为镜像。换句话说，就是在原有镜像的基础上，再叠加上容器的存储层，并构成新的镜像。

docker commit 的语法格式为：
```
docker commit [选项] <容器ID或容器名> [<仓库名>[:<标签>]]
```

我们可以用下面的命令将容器保存为镜像：
```
$ docker commit --author "chuxing" --message "update page" webserver nginx:v2
sha256:8aaa0b63a1b842fb301d5d691cae92d9fdb52c73f37858eefada4325a36474f0
```

我们可以在 `docker image ls` 中看到这个新定制的镜像：
```
$ docker image ls nginx
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
nginx               v2                  8aaa0b63a1b8        About a minute ago   109MB
nginx               latest              568c4670fa80        4 weeks ago          109MB
```

新的镜像定制好后，我们可以运行这个镜像:
```
docker run --name web2 -d -p 81:80 nginx:v2
```
## 慎用 docker commit
使用 `docker commit` 命令虽然可以比较直观的帮助理解镜像分层存储的概念，但是实际环境中并不会这样使用。

1. 如果仔细观察之前的 `docker diff webserver` 的结果，你会发现除了真正想要修改的 `/usr/share/nginx/html/index.html` 文件外，还有很多文件被改动或添加了。这还仅仅是最简单的操作，如果是安装软件包、编译构建，那会有大量的无关内容被添加进来，如果不小心清理，将会导致镜像极为臃肿。
2. 使用 `docker commit` 意味着所有对镜像的操作都是黑箱操作，生成的镜像也被称为黑箱镜像，换句话说，就是除了制作镜像的人知道执行过什么命令、怎么生成的镜像，别人根本无从得知。
3. 回顾之前提及的镜像所使用的分层存储的概念，任何修改的结果仅仅是在当前层进行标记、添加、修改，而不会改动上一层。如果使用 `docker commit` 制作镜像，每一次修改都会让镜像更加臃肿一次，这会让镜像更加臃肿。

## 镜像导入和导出

### 导出镜像
```
$ docker save -o nginx.tar nginx:latest 
```
或
```
$ docker save > nginx.tar nginx:latest 
```


### 导入镜像
```
$ docker load -i nginx.tar
```
或
```
$ docker load < nginx.tar
```


---

> 作者: [chuxing](https://github.com/xzygis)  
> URL: https://xzygis.github.io/posts/20200130-usage-of-docker-image/  

