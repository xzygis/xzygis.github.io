# Consul入门手册



## Consul是什么？
Consul是一个服务发现和配置工具，它是分布式和高可用的，而且极易扩展。

Consul主要提供了以下特性：
1. 服务发现：Consul使得服务注册和服务发现（通过DNS或HTTP接口）变得非常简单。
2. 健康检查：健康检查使得Consul可以快速向管理员报告集群状况。将它与服务发现集成，可以防止流量路由到故障节点，实现服务熔断。
3. KV存储：灵活的KV存储，可用于尺寸出动态配置、功能特性、协调信息和选举信息等。简单的HTTP API使其易于在任何地方地方。
4. 多数据中心：Consul支持多数据中心，不需要负责的配置就可以支持任意数量的数据中心。
5. 服务鉴权（Service Segmentation）：Consul连接基于自动TLS加密和基于签名的鉴权实现安全的服务间通信。

Consul支持Linux, Mac OS X, FreeBSD, Solaris, Windows等操作系统。

<!-- more -->

### 基本架构
每个提供服务给Consul的节点都运行了一个Consul Agent。运行一个Agent并不需要对其他服务做发现或读写KV存储。Agent负责对该节点上的服务做健康检查。

Agent会与一个或多个Consul Server通信。Consul Server通常有多个实例，负责数据存储和备份、选举主节点等。虽然Consul支持在只有一个Server实例的情况下工具，但通常推荐使用3至5个实例，从而避免由于某些异常场景而导致数据丢失。同时，推荐在每个数据中心部署一个Consul集群。

每个数据中运行了一个Consul server集群。当一个跨数据中心的服务发现和配置请求创建时，本地Consul Server转发请求到远程的数据中心并返回结果.

## 安装Consul
Consul集群的每个节点都必须先安装Consul，安装非常简单。在Mac上安装Consul命令如下：
```
$ brew install consul
```
安装成功后执行consul命令输出如下结果：
```
$ consul
Usage: consul [--version] [--help] <command> [<args>]

Available commands are:
    acl            Interact with Consul's ACLs
    agent          Runs a Consul agent
    catalog        Interact with the catalog
    config         Interact with Consul's Centralized Configurations
    connect        Interact with Consul Connect
    debug          Records a debugging archive for operators
    event          Fire a new event
    exec           Executes a command on Consul nodes
    force-leave    Forces a member of the cluster to enter the "left" state
    info           Provides debugging information for operators.
    intention      Interact with Connect service intentions
    join           Tell Consul agent to join cluster
    keygen         Generates a new encryption key
    keyring        Manages gossip layer encryption keys
    kv             Interact with the key-value store
    leave          Gracefully leaves the Consul cluster and shuts down
    lock           Execute a command holding a lock
    login          Login to Consul using an auth method
    logout         Destroy a Consul token created with login
    maint          Controls node or service maintenance mode
    members        Lists the members of a Consul cluster
    monitor        Stream logs from a Consul agent
    operator       Provides cluster-level tools for Consul operators
    reload         Triggers the agent to reload configuration files
    rtt            Estimates network round trip time between nodes
    services       Interact with services
    snapshot       Saves, restores and inspects snapshots of Consul server state
    tls            Builtin helpers for creating CAs and certificates
    validate       Validate config files/directories
    version        Prints the Consul version
    watch          Watch for changes in Consul
```

## 运行Agent
完成Consul的安装后，可运行Agent。Agent可以运行为Server或Client模式。每个数据中心至少必须拥有一台server，建议在一个集群中部署或者3至5个Server。部署单一的Server，在出现失败时会不可避免的造成数据丢失.

其他的Agent运行为Client模式，一个Client是一个非常轻量级的进程，用于注册服务，运行健康检查和转发对Server的查询，Agent必须在集群中的每个主机上运行。

### 启动Agent
命令`consul agent -dev`可以启动一个开发模式的Agent，这种模式不能用于生产环境，因为它不持久化任何状态。
```
$ consul agent -dev
==> Starting Consul agent...
           Version: 'v1.6.1'
           Node ID: '2e524113-7caf-643a-80bb-a2fa00c2673b'
         Node name: 'C02Z35N9LVCF'
        Datacenter: 'dc1' (Segment: '<all>')
            Server: true (Bootstrap: false)
       Client Addr: [127.0.0.1] (HTTP: 8500, HTTPS: -1, gRPC: 8502, DNS: 8600)
      Cluster Addr: 127.0.0.1 (LAN: 8301, WAN: 8302)
           Encrypt: Gossip: false, TLS-Outgoing: false, TLS-Incoming: false, Auto-Encrypt-TLS: false

==> Log data will now stream in as it occurs:

    2019/11/20 21:56:09 [DEBUG] agent: Using random ID "2e524113-7caf-643a-80bb-a2fa00c2673b" as node ID
    2019/11/20 21:56:09 [DEBUG] tlsutil: Update with version 1
    2019/11/20 21:56:09 [DEBUG] tlsutil: OutgoingRPCWrapper with version 1
    2019/11/20 21:56:09 [INFO]  raft: Initial configuration (index=1): [{Suffrage:Voter ID:2e524113-7caf-643a-80bb-a2fa00c2673b Address:127.0.0.1:8300}]
    2019/11/20 21:56:09 [INFO]  raft: Node at 127.0.0.1:8300 [Follower] entering Follower state (Leader: "")
    2019/11/20 21:56:09 [INFO] serf: EventMemberJoin: C02Z35N9LVCF.dc1 127.0.0.1
    2019/11/20 21:56:09 [INFO] serf: EventMemberJoin: C02Z35N9LVCF 127.0.0.1
    2019/11/20 21:56:09 [INFO] consul: Adding LAN server C02Z35N9LVCF (Addr: tcp/127.0.0.1:8300) (DC: dc1)
    2019/11/20 21:56:09 [INFO] consul: Handled member-join event for server "C02Z35N9LVCF.dc1" in area "wan"
    2019/11/20 21:56:09 [INFO] agent: Started DNS server 127.0.0.1:8600 (tcp)
    2019/11/20 21:56:09 [INFO] agent: Started DNS server 127.0.0.1:8600 (udp)
    2019/11/20 21:56:09 [INFO] agent: Started HTTP server on 127.0.0.1:8500 (tcp)
    2019/11/20 21:56:09 [INFO] agent: Started gRPC server on 127.0.0.1:8502 (tcp)
    2019/11/20 21:56:09 [INFO] agent: started state syncer
==> Consul agent running!
    2019/11/20 21:56:09 [WARN]  raft: Heartbeat timeout from "" reached, starting election
    2019/11/20 21:56:09 [INFO]  raft: Node at 127.0.0.1:8300 [Candidate] entering Candidate state in term 2
    2019/11/20 21:56:09 [DEBUG] raft: Votes needed: 1
    2019/11/20 21:56:09 [DEBUG] raft: Vote granted from 2e524113-7caf-643a-80bb-a2fa00c2673b in term 2. Tally: 1
    2019/11/20 21:56:09 [INFO]  raft: Election won. Tally: 1
    2019/11/20 21:56:09 [INFO]  raft: Node at 127.0.0.1:8300 [Leader] entering Leader state
    2019/11/20 21:56:09 [INFO] consul: cluster leadership acquired
    2019/11/20 21:56:09 [INFO] consul: New leader elected: C02Z35N9LVCF
    2019/11/20 21:56:09 [INFO] connect: initialized primary datacenter CA with provider "consul"
    2019/11/20 21:56:09 [DEBUG] consul: Skipping self join check for "C02Z35N9LVCF" since the cluster is too small
    2019/11/20 21:56:09 [INFO] consul: member 'C02Z35N9LVCF' joined, marking health alive
    2019/11/20 21:56:09 [DEBUG] agent: Skipping remote check "serfHealth" since it is managed automatically
    2019/11/20 21:56:09 [INFO] agent: Synced node info
    2019/11/20 21:56:09 [DEBUG] agent: Node info in sync
    2019/11/20 21:56:09 [DEBUG] agent: Skipping remote check "serfHealth" since it is managed automatically
    2019/11/20 21:56:09 [DEBUG] agent: Node info in sync
    2019/11/20 21:56:11 [DEBUG] tlsutil: OutgoingRPCWrapper with version 1
```

### 集群成员
新开一个终端窗口运行`consul members`, 就可以看到Consul集群的成员。
```
$ consul members
Node          Address         Status  Type    Build  Protocol  DC   Segment
C02Z35N9LVCF  127.0.0.1:8301  alive   server  1.6.1  2         dc1  <all>
```
以上输出显示了我们自己的节点运行的节点、地址、健康状态、自己在集群中的角色、版本信息等。添加`-detailed`选项可以查看到额外的信息，如下：
```
$ consul members --detailed
Node          Address         Status  Tags
C02Z35N9LVCF  127.0.0.1:8301  alive   acls=0,build=1.6.1:9be6dfc+,dc=dc1,id=2e524113-7caf-643a-80bb-a2fa00c2673b,port=8300,raft_vsn=3,role=consul,segment=<all>,vsn=2,vsn_max=3,vsn_min=2,wan_join_port=8302
```
`members`命令的输出是基于gossip协议，它是最终一致的。这意味着，在任何时候，通过你本地Agent看到的结果可能不能准确匹配server的状态。为了查看到一致的信息，可使用HTTP API(将自动转发)到Consul Server上去进行查询：
```
$ curl localhost:8500/v1/catalog/nodes
[
    {
        "ID": "2e524113-7caf-643a-80bb-a2fa00c2673b",
        "Node": "C02Z35N9LVCF",
        "Address": "127.0.0.1",
        "Datacenter": "dc1",
        "TaggedAddresses": {
            "lan": "127.0.0.1",
            "wan": "127.0.0.1"
        },
        "Meta": {
            "consul-network-segment": ""
        },
        "CreateIndex": 9,
        "ModifyIndex": 10
    }
]
```

### 停止Agent
你可以使用 Ctrl-C 优雅的关闭Agent，中断Agent之后你可以看到它离开了集群并关闭.
退出后，Consul提醒其他集群成员，这个节点离开了。如果你强行杀掉进程，集群的其他成员应该能检测到这个节点失效了。当一个成员离开，他的服务和检测也会从目录中移除。当一个成员失效了，他的健康状况被简单的标记为危险，但是不会从目录中移除。Consul会自动尝试对失效的节点进行重连，允许他从某些网络条件下恢复过来。

## 注册服务
在之前的步骤我们运行了第一个agent，看到了集群的成员。现在我们将注册第一个服务并查询这些服务。

### 定义一个服务
可以通过提供服务定义或者调用HTTP API来注册一个服务，服务定义文件是注册服务的最通用的方式。

首先，为Consul配置创建一个目录：
```
$ sudo mkdir /etc/consul.d
```
然后，编写服务定义配置文件。假设我们有一个名叫web的服务运行在 80端口。另外，我们将给他设置一个标签，这样我们可以使用它作为额外的查询方式：
```
echo '{"service": {"name": "web", "tags": ["rails"], "port": 80}}' > /etc/consul.d/web.json
```
重新启动Agent，设置配置目录：
```
$ sudo consul agent -dev -config-dir /etc/consul.d/web.json
==> Starting Consul agent...
           Version: 'v1.6.1'
           Node ID: 'feba8d74-4a3a-9b42-305f-eea7da207c9c'
         Node name: 'C02Z35N9LVCF'
        Datacenter: 'dc1' (Segment: '<all>')
            Server: true (Bootstrap: false)
       Client Addr: [127.0.0.1] (HTTP: 8500, HTTPS: -1, gRPC: 8502, DNS: 8600)
      Cluster Addr: 127.0.0.1 (LAN: 8301, WAN: 8302)
           Encrypt: Gossip: false, TLS-Outgoing: false, TLS-Incoming: false, Auto-Encrypt-TLS: false

==> Log data will now stream in as it occurs:

    2019/11/20 22:17:29 [DEBUG] agent: Using random ID "feba8d74-4a3a-9b42-305f-eea7da207c9c" as node ID
    2019/11/20 22:17:29 [DEBUG] tlsutil: Update with version 1
    2019/11/20 22:17:29 [DEBUG] tlsutil: OutgoingRPCWrapper with version 1
    2019/11/20 22:17:29 [INFO]  raft: Initial configuration (index=1): [{Suffrage:Voter ID:feba8d74-4a3a-9b42-305f-eea7da207c9c Address:127.0.0.1:8300}]
    2019/11/20 22:17:29 [INFO]  raft: Node at 127.0.0.1:8300 [Follower] entering Follower state (Leader: "")
    2019/11/20 22:17:29 [INFO] serf: EventMemberJoin: C02Z35N9LVCF.dc1 127.0.0.1
    2019/11/20 22:17:29 [INFO] serf: EventMemberJoin: C02Z35N9LVCF 127.0.0.1
    2019/11/20 22:17:29 [INFO] consul: Adding LAN server C02Z35N9LVCF (Addr: tcp/127.0.0.1:8300) (DC: dc1)
    2019/11/20 22:17:29 [INFO] consul: Handled member-join event for server "C02Z35N9LVCF.dc1" in area "wan"
    2019/11/20 22:17:29 [INFO] agent: Started DNS server 127.0.0.1:8600 (tcp)
    2019/11/20 22:17:29 [INFO] agent: Started DNS server 127.0.0.1:8600 (udp)
    2019/11/20 22:17:29 [INFO] agent: Started HTTP server on 127.0.0.1:8500 (tcp)
    2019/11/20 22:17:29 [INFO] agent: Started gRPC server on 127.0.0.1:8502 (tcp)
    2019/11/20 22:17:29 [INFO] agent: started state syncer
==> Consul agent running!
    2019/11/20 22:17:30 [WARN]  raft: Heartbeat timeout from "" reached, starting election
    2019/11/20 22:17:30 [INFO]  raft: Node at 127.0.0.1:8300 [Candidate] entering Candidate state in term 2
    2019/11/20 22:17:30 [DEBUG] raft: Votes needed: 1
    2019/11/20 22:17:30 [DEBUG] raft: Vote granted from feba8d74-4a3a-9b42-305f-eea7da207c9c in term 2. Tally: 1
    2019/11/20 22:17:30 [INFO]  raft: Election won. Tally: 1
    2019/11/20 22:17:30 [INFO]  raft: Node at 127.0.0.1:8300 [Leader] entering Leader state
    2019/11/20 22:17:30 [INFO] consul: cluster leadership acquired
    2019/11/20 22:17:30 [INFO] consul: New leader elected: C02Z35N9LVCF
    2019/11/20 22:17:30 [INFO] connect: initialized primary datacenter CA with provider "consul"
    2019/11/20 22:17:30 [DEBUG] consul: Skipping self join check for "C02Z35N9LVCF" since the cluster is too small
    2019/11/20 22:17:30 [INFO] consul: member 'C02Z35N9LVCF' joined, marking health alive
    2019/11/20 22:17:30 [DEBUG] agent: Skipping remote check "serfHealth" since it is managed automatically
    2019/11/20 22:17:30 [INFO] agent: Synced service "web"
    2019/11/20 22:17:30 [DEBUG] agent: Node info in sync
    2019/11/20 22:17:32 [DEBUG] tlsutil: OutgoingRPCWrapper with version 1
    2019/11/20 22:17:32 [DEBUG] agent: Skipping remote check "serfHealth" since it is managed automatically
    2019/11/20 22:17:32 [DEBUG] agent: Service "web" in sync
    2019/11/20 22:17:32 [DEBUG] agent: Node info in sync
    2019/11/20 22:17:32 [DEBUG] agent: Service "web" in sync
    2019/11/20 22:17:32 [DEBUG] agent: Node info in sync
```
日志中的`Synced service 'web'`表示Agent从配置文件中载入了服务定义，并且成功注册到服务目录。

如果想注册多个服务，就可以在Consul配置目录创建多个服务定义文件。

### 查询服务
一旦Agent启动并且服务同步了，我们可就以通过DNS或者HTTP API来查询服务。

#### DNS API
我们首先使用DNS API来查询。在DNS API中，服务的DNS名字是 `NAME.service.consul`。虽然是可配置的，但默认的所有DNS名字会都在consul命名空间下，这个子域告诉Consul，我们在查询服务，`NAME`则是服务的名称.


对于我们上面注册的Web服务.它的域名是 `web.service.consul`:
```
$ dig @127.0.0.1 -p 8600 web.service.consul

; <<>> DiG 9.10.6 <<>> @127.0.0.1 -p 8600 web.service.consul
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 27222
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 2
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;web.service.consul.                IN        A

;; ANSWER SECTION:
web.service.consul.        0        IN        A        127.0.0.1

;; ADDITIONAL SECTION:
web.service.consul.        0        IN        TXT        "consul-network-segment="

;; Query time: 8 msec
;; SERVER: 127.0.0.1#8600(127.0.0.1)
;; WHEN: Wed Nov 20 22:26:14 CST 2019
;; MSG SIZE  rcvd: 99
```
如你所见,一个A记录返回了一个可用的服务所在的节点的IP地址。A记录只能设置为IP地址，有也可用使用 DNS API 来接收包含地址和端口的 `SRV` 记录：
```
$ dig @127.0.0.1 -p 8600 web.service.consul SRV

; <<>> DiG 9.10.6 <<>> @127.0.0.1 -p 8600 web.service.consul SRV
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 49043
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 3
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;web.service.consul.                IN        SRV

;; ANSWER SECTION:
web.service.consul.        0        IN        SRV        1 1 80 C02Z35N9LVCF.node.dc1.consul.

;; ADDITIONAL SECTION:
C02Z35N9LVCF.node.dc1.consul. 0        IN        A        127.0.0.1
C02Z35N9LVCF.node.dc1.consul. 0        IN        TXT        "consul-network-segment="

;; Query time: 1 msec
;; SERVER: 127.0.0.1#8600(127.0.0.1)
;; WHEN: Wed Nov 20 22:28:14 CST 2019
;; MSG SIZE  rcvd: 147
```
`SRV`记录告诉我们 web 这个服务运行于节点`C02Z35N9LVCF.node.dc1.consul` 的80端口，DNS额外返回了节点的A记录。

最后，我们也可以用 DNS API 通过标签来过滤服务，基于标签的服务查询格式为`TAG.NAME.service.consul`。在下面的例子中，我们请求Consul返回有 rails标签的 web服务：
```
$ dig @127.0.0.1 -p 8600 rails.web.service.consul SRV
# 输出信息略
```

#### HTTP API
除了DNS API之外，也可以使用HTTP API查询所有服务实例：
```
$ curl http://localhost:8500/v1/catalog/service/web
[
    {
        "ID": "feba8d74-4a3a-9b42-305f-eea7da207c9c",
        "Node": "C02Z35N9LVCF",
        "Address": "127.0.0.1",
        "Datacenter": "dc1",
        "TaggedAddresses": {
            "lan": "127.0.0.1",
            "wan": "127.0.0.1"
        },
        "NodeMeta": {
            "consul-network-segment": ""
        },
        "ServiceKind": "",
        "ServiceID": "web",
        "ServiceName": "web",
        "ServiceTags": [
            "rails"
        ],
        "ServiceAddress": "",
        "ServiceWeights": {
            "Passing": 1,
            "Warning": 1
        },
        "ServiceMeta": {},
        "ServicePort": 80,
        "ServiceEnableTagOverride": false,
        "ServiceProxy": {
            "MeshGateway": {}
        },
        "ServiceConnect": {},
        "CreateIndex": 10,
        "ModifyIndex": 10
    }
]
```
只查看健康服务实例的方法：
```
$ curl http://localhost:8500/v1/catalog/service/web?passing
# 输出信息略
```

### 更新服务
服务定义可以通过修改配置文件并发送`SIGHUP`给Agent来进行更新，这样可以在不关闭服务或者保持服务请求可用的情况下进行更新。

参考来源：
1. https://github.com/hashicorp/consul
2. https://www.consul.io/intro/getting-started.html
3. https://book-consul-guide.vnzmi.com/01_what_is_consul.html


---

> 作者: [chuxing](https://github.com/xzygis)  
> URL: https://xzygis.github.io/posts/manual-of-consul/  

