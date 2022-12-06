# 云原生概述


## 云原生的定义
云原生技术有利于各组织在公有云、私有云和混合云等新型动态环境中，构建和运行可弹性扩展的应用。云原生的代表技术包括容器、服务网格、微服务、不可变基础设施和声明式API。

这些技术能够构建容错性好、易于管理和便于观察的松耦合系统。结合可靠的自动化手段，云原生技术使工程师能够轻松地对系统作出频繁和可预测的重大变更。

<!-- more -->

## 云原生的设计哲学
云原生本身甚至不能称为是一种架构，它首先是一种基础设施，运行在其上的应用称作云原生应用，只有符合云原生设计哲学的应用架构才叫云原生应用架构。

### 云原生的设计理念
云原生系统的设计理念如下:
- 面向分布式设计（Distribution）：容器、微服务、API 驱动的开发；
- 面向配置设计（Configuration）：一个镜像，多个环境配置；
- 面向韧性设计（Resistancy）：故障容忍和自愈；
- 面向弹性设计（Elasticity）：弹性扩展和对环境变化（负载）做出响应；
- 面向交付设计（Delivery）：自动拉起，缩短交付时间；
- 面向性能设计（Performance）：响应式，并发和资源高效利用；
- 面向自动化设计（Automation）：自动化的 DevOps；
- 面向诊断性设计（Diagnosability）：集群级别的日志、metric 和追踪；
- 面向安全性设计（Security）：安全端点、API Gateway、端到端加密；

### 云原生应用程序
云原生应用程序被设计为在平台上运行，并设计用于弹性，敏捷性，可操作性和可观察性。弹性包含失败而不是试图阻止它们；它利用了在平台上运行的动态特性。敏捷性允许快速部署和快速迭代。可操作性从应用程序内部控制应用程序生命周期，而不是依赖外部进程和监视器。可观察性提供信息来回答有关应用程序状态的问题。

实现云原生应用程序所需特性的常用方法：
- 微服务
- 健康报告
- 遥测数据
- 弹性
- 声明式的，而不是命令式的

#### 微服务
微服务 (Microservices) 是一种软件架构风格，它是以专注于单一责任与功能的小型功能区块 (Small Building Blocks) 为基础，利用模块化的方式组合出复杂的大型应用程序，各功能区块使用与语言无关 (Language-Independent/Language agnostic) 的 API 集相互通信。

微服务是一种以业务功能为主的服务设计概念，每一个服务都具有自主运行的业务功能，对外开放不受语言限制的 API (最常用的是 HTTP)，应用程序则是由一个或多个微服务组成。

#### 健康报告
为了提高云原生应用程序的可操作性，应用程序应该暴露健康检查。开发人员可以将其实施为命令或过程信号，以便应用程序在执行自我检查之后响应，或者更常见的是：通过应用程序提供Web服务，返回HTTP状态码来检查健康状态。

一个很好的例子就是当平台需要知道应用程序何时可以接收流量。在应用程序启动时，如果它不能正确处理流量，它就应该表现为未准备好。

#### 遥测数据
遥测数据是进行决策所需的信息。确实，遥测数据可能与健康报告重叠，但它们有不同的用途。健康报告通知我们应用程序生命周期状态，而遥测数据通知我们应用程序业务目标。

测量的指标有时称为服务级指标（SLI）或关键性能指标（KPI）。这些是特定于应用程序的数据，可以确保应用程序的性能处于服务级别目标（SLO）内。

#### 弹性
一旦你有遥测和监测数据，你需要确保你的应用程序对故障有适应能力。弹性是基础设施的责任，但云原生应用程序也需要承担部分工作。在云原生应用程序中考虑弹性的两个主要方面：为失败设计和优雅降级。

##### 为失败设计
设计一个以失败期望为目标的应用程序将比假定可用性的应用程序更具防御性。当故障不可避免时，将会有额外的检查，故障模式和日志内置到应用程序中。

##### 优雅降级
云原生应用程序处理过载的一种方式。

#### 声明式，非命令式
声明式编程是一种编程范式，与命令式编程相对立。它描述目标的性质，让电脑明白目标，而非流程。声明式编程不用告诉电脑问题领域，从而避免随之而来的副作用。而命令式编程则需要用算法来明确的指出每一步该怎么做。

声明式通信模型规范了通信模型，并且它将功能实现从应用程序转移到远程API或服务端点，从而实现某种状态到达期望状态。这有助于简化应用程序，并使它们彼此的行为更具可预测性。

例子：SQL数据库
其实你很早就接触过声明式编程语言， SQL语言就是很典型的例子：
```sql
SELECT * from user WHERE user_name = Ben
```
上面是一个很普通的SQL查询语句，我只只声明我想要找一个叫Ben的用户（What) , 就是不说SQL该怎么（How）去寻找怎么做。接下来我们看看如果用命令式语言写会是什么样的：
```js
//user=[{user_name:'ou',user_id=1},.....]
var user
for(var i = 0; i < user.length; i++){
    if(user.user_name == "Ben")
    {
         print("find");
         break;
    }
}
```
通过上面的对比你可以看出声明式语言的优势-短小精悍，你并不会知道程序的控制流（control flow）我们不需要告诉程序如何去寻找（How），而是只告诉程序我们想要的结果（What），让程序自己来解决过程（How）。当然SQL具体的细节还是用命令式的编程风格来实现的。


## Play with Kubernetes
### 创建Kubernetes集群
登陆Play with Kubernetes，启动第一个实例作为Master节点，在web终端上执行：
1. 初始化master节点：
```shell
kubeadm init --apiserver-advertise-address $(hostname -i)
```
输出如下：
```
[node1 ~]$ kubeadm init --apiserver-advertise-address $(hostname -i)
Initializing machine ID from random generator.
[init] using Kubernetes version: v1.11.10
[preflight] running pre-flight checks
        [WARNING Service-Docker]: docker service is not active, please run 'systemctl start docker.service'
        [WARNING FileContent--proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables does not exist
I1117 13:53:18.409493     885 kernel_validator.go:81] Validating kernel version
I1117 13:53:18.409685     885 kernel_validator.go:96] Validating kernel config
[preflight] The system verification failed. Printing the output from the verification:
KERNEL_VERSION: 4.4.0-148-generic
DOCKER_VERSION: 18.06.1-ce
OS: Linux
CGROUPS_CPU: enabled
CGROUPS_CPUACCT: enabled
CGROUPS_CPUSET: enabled
CGROUPS_DEVICES: enabled
CGROUPS_FREEZER: enabled
CGROUPS_MEMORY: enabled
        [WARNING SystemVerification]: docker version is greater than the most recently validated version. Docker version: 18.06.1-ce. Max validated version: 17.03
        [WARNING SystemVerification]: failed to parse kernel config: unable to load kernel module "configs": output - "", err - exit status 1

[preflight/images] Pulling images required for setting up a Kubernetes cluster
[preflight/images] This might take a minute or two, depending on the speed of your internet connection
[preflight/images] You can also perform this action in beforehand using 'kubeadm config images pull'
[kubelet] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[preflight] Activating the kubelet service
[certificates] Generated ca certificate and key.
[certificates] Generated apiserver certificate and key.
[certificates] apiserver serving cert is signed for DNS names [node1 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.0.18]
[certificates] Generated apiserver-kubelet-client certificate and key.
[certificates] Generated sa key and public key.
[certificates] Generated front-proxy-ca certificate and key.
[certificates] Generated front-proxy-client certificate and key.
[certificates] Generated etcd/ca certificate and key.
[certificates] Generated etcd/server certificate and key.
[certificates] etcd/server serving cert is signed for DNS names [node1 localhost] and IPs [127.0.0.1 ::1]
[certificates] Generated etcd/peer certificate and key.
[certificates] etcd/peer serving cert is signed for DNS names [node1 localhost] and IPs [192.168.0.18 127.0.0.1 ::1]
[certificates] Generated etcd/healthcheck-client certificate and key.
[certificates] Generated apiserver-etcd-client certificate and key.
[certificates] valid certificates and keys now exist in "/etc/kubernetes/pki"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/admin.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/kubelet.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/controller-manager.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/scheduler.conf"
[controlplane] wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/manifests/kube-apiserver.yaml"
[controlplane] wrote Static Pod manifest for component kube-controller-manager to "/etc/kubernetes/manifests/kube-controller-manager.yaml"
[controlplane] wrote Static Pod manifest for component kube-scheduler to "/etc/kubernetes/manifests/kube-scheduler.yaml"
[etcd] Wrote Static Pod manifest for a local etcd instance to "/etc/kubernetes/manifests/etcd.yaml"
[init] waiting for the kubelet to boot up the control plane as Static Pods from directory "/etc/kubernetes/manifests"
[init] this might take a minute or longer if the control plane images have to be pulled
[apiclient] All control plane components are healthy after 51.503514 seconds
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.11" in namespace kube-system with the configuration for the kubelets in the cluster
[markmaster] Marking the node node1 as master by adding the label "node-role.kubernetes.io/master=''"
[markmaster] Marking the node node1 as master by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "node1" as an annotation
[bootstraptoken] using token: 5f1nyz.351cet8vt4g2ix78
[bootstraptoken] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstraptoken] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstraptoken] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstraptoken] creating the "cluster-info" ConfigMap in the "kube-public" namespace
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join 192.168.0.18:6443 --token 5f1nyz.351cet8vt4g2ix78 --discovery-token-ca-cert-hash sha256:d105d049cf090f7814473e5554b79e09cd13e4acfd8a56b09754ba9181d08fd8

Waiting for api server to startup
Warning: kubectl apply should be used on resource created by either kubectl create --save-config or kubectl apply
daemonset.extensions/kube-proxy configured
No resources found
```

2. 初始化集群网络：
```shell
kubectl apply -n kube-system -f  "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
输出如下：
```
serviceaccount/weave-net created
clusterrole.rbac.authorization.k8s.io/weave-net created
clusterrolebinding.rbac.authorization.k8s.io/weave-net created
role.rbac.authorization.k8s.io/weave-net created
rolebinding.rbac.authorization.k8s.io/weave-net created
daemonset.apps/weave-net created
```

3.  执行下列初始化命令：
```shell
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
```
4. 根据master节点上的提示，在新的web终端上执行：
```shell
kubeadm join 192.168.0.18:6443 --token 5f1nyz.351cet8vt4g2ix78 --discovery-token-ca-cert-hash sha256:d105d049cf090f7814473e5554b79e09cd13e4acfd8a56b09754ba9181d08fd8
```
输出如下：
```
[preflight] running pre-flight checks
        [WARNING DirAvailable--etc-kubernetes-manifests]: /etc/kubernetes/manifests is not empty
        [WARNING FileAvailable--etc-kubernetes-pki-ca.crt]: /etc/kubernetes/pki/ca.crt already exists
        [WARNING FileAvailable--etc-kubernetes-kubelet.conf]: /etc/kubernetes/kubelet.conf already exists
        [WARNING RequiredIPVSKernelModulesAvailable]: error getting required builtin kernel modules: exit status 1(cut: /lib/modules/4.4.0-166-generic/modules.builtin: No such file or directory
)
        [WARNING Service-Docker]: docker service is not active, please run 'systemctl start docker.service'
        [WARNING FileContent--proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables does not exist
I1117 14:09:02.416363    7243 kernel_validator.go:81] Validating kernel version
I1117 14:09:02.419283    7243 kernel_validator.go:96] Validating kernel config
[preflight] The system verification failed. Printing the output from the verification:
KERNEL_VERSION: 4.4.0-166-generic
DOCKER_VERSION: 18.06.1-ce
OS: Linux
CGROUPS_CPU: enabled
CGROUPS_CPUACCT: enabled
CGROUPS_CPUSET: enabled
CGROUPS_DEVICES: enabled
CGROUPS_FREEZER: enabled
CGROUPS_MEMORY: enabled
        [WARNING SystemVerification]: docker version is greater than the most recently validated version. Docker version: 18.06.1-ce. Max validated version: 17.03
        [WARNING SystemVerification]: failed to parse kernel config: unable to load kernel module "configs": output - "", err - exit status 1
        [WARNING Port-10250]: Port 10250 is in use
[discovery] Trying to connect to API Server "192.168.0.28:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.0.28:6443"
[discovery] Requesting info from "https://192.168.0.28:6443" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.0.28:6443"
[discovery] Successfully established connection with API Server "192.168.0.28:6443"
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.11" ConfigMap in the kube-system namespace
[kubelet] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[preflight] Activating the kubelet service
[tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "node1" as an annotation

This node has joined the cluster:
* Certificate signing request was sent to master and a response
  was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the master to see this node join the cluster.
```
多开几个实例，重复执行第四步，即可向Kubernetes集群中增加节点。

此时在master节点上执行`kubectl get nodes`查看节点所有节点状态：
```
[node1 ~]$ kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
node1     Ready     master    19m       v1.11.3
node2     Ready     <none>    2m        v1.11.3
node3     Ready     <none>    1m        v1.11.3
```

### 创建nginx deployment
```shell
[node1 ~]$ curl https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/nginx-app.yaml > nginx-app.yaml
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   497  100   497    0     0   1252      0 --:--:-- --:--:-- --:--:--  1255
[node1 ~]$
[node1 ~]$ kubectl apply -f nginx-app.yaml
service/my-nginx-svc created
deployment.apps/my-nginx created
```
此时查看nodes和pods：
```shell
[node1 ~]$ kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
node1     Ready     master    29m       v1.11.3
node2     Ready     <none>    11m       v1.11.3
node3     Ready     <none>    11m       v1.11.3
[node1 ~]$
[node1 ~]$ kubectl get pods
NAME                        READY     STATUS    RESTARTS   AGE
my-nginx-67594d6bf6-2cbbz   1/1       Running   0          1m
my-nginx-67594d6bf6-r2p6w   1/1       Running   0          1m
my-nginx-67594d6bf6-vjqn4   1/1       Running   0          1m
```


参考来源：
1. https://github.com/cncf/toc/blob/master/DEFINITION.md
2. https://zh.wikipedia.org/wiki/%E5%BE%AE%E6%9C%8D%E5%8B%99
3. https://zh.wikipedia.org/zh-cn/%E5%AE%A3%E5%91%8A%E5%BC%8F%E7%B7%A8%E7%A8%8B
4. https://zhuanlan.zhihu.com/p/34445114
5. https://labs.play-with-k8s.com/


---

> 作者: [chuxing](https://github.com/xzygis)  
> URL: https://xzygis.github.io/posts/20200128-introduction-of-cloud-native/  

