# CentOS安装docker



### 1. 移除旧的版本
```shell
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
```

### 2. 安装一些必要的系统工具
```shell
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

### 3. 添加软件源信息
```shell
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

### 4. 更新 yum 缓存
```shell
sudo yum makecache fast
```

### 5. 安装 Docker-ce
```shell
sudo yum -y install docker-ce
```


### 6. 启动 Docker 后台服务
```shell
sudo systemctl start docker
```

### 7. 测试运行 hello-world

初次运行可能会报如下的错误信息：
```shell
[root@VM_0_6_centos ~]# docker run hello-world
Unable to find image 'hello-world:latest' locally
docker: Error response from daemon: Get https://registry-1.docker.io/v2/library/hello-world/manifests/latest: Get https://auth.docker.io/token?scope=repository%3Alibrary%2Fhello-world%3Apull&service=registry.docker.io: net/http: TLS handshake timeout.
See 'docker run --help'.
```
解决方式是使用国内的镜像地址，新建`/etc/docker/daemon.json`文件，填写如下配置信息：
```
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
```

之后运行正常，如下：
```
[root@VM_0_6_centos docker]# docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
d1725b59e92d: Pull complete
Digest: sha256:0add3ace90ecb4adbf7777e9aacf18357296e799f81cabc9fde470971e499788
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

---

> 作者:   
> URL: https://xzygis.github.io/posts/centos-install-docker/  

