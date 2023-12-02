# Service Mesh概述



## 什么是服务网格？
服务网格是用于处理服务间通信的专用基础设施层。它负责通过包含现代云原生应用程序的复杂服务拓扑来可靠地传递请求。实际上，服务网格通常通过一组轻量级网络代理来实现，这些代理与应用程序代码一起部署，而不需要感知应用程序本身。

### 服务网格的特点
服务网格有如下几个特点：

- 应用程序间通讯的中间层
- 轻量级网络代理
- 应用程序无感知
- 解耦应用程序的重试/超时、监控、追踪和服务发现


### 理解服务网格
如果用一句话来解释什么是服务网格，可以将它比作是应用程序或者说微服务间的 TCP/IP，负责服务之间的网络调用、限流、熔断和监控。

服务网格的架构如下图所示：
![Service Mesh架构图](https://img-blog.csdnimg.cn/20191116230107526.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9jaHV4aW5nLmJsb2cuY3Nkbi5uZXQ=,size_16,color_FFFFFF,t_70)

### 为何使用服务网格？
服务网格并没有给我们带来新功能，它是用于解决其他工具已经解决过的问题，只不过这次是在云原生的 Kubernetes 环境下的实现。

在传统的 MVC 三层 Web 应用程序架构下，服务之间的通讯并不复杂，在应用程序内部自己管理即可，但是在现今的复杂的大型网站情况下，单体应用被分解为众多的微服务，服务之间的依赖和通讯十分复杂，出现了 twitter 开发的 Finagle、Netflix 开发的 Hystrix 和 Google 的 Stubby 这样的 “胖客户端” 库，这些就是早期的服务网格，但是它们都仅适用于特定的环境和特定的开发语言，并不能作为平台级的服务网格支持。

在云原生架构下，容器的使用给予了异构应用程序的更多可行性，Kubernetes 增强的应用的横向扩容能力，用户可以快速的编排出复杂环境、复杂依赖关系的应用程序，同时开发者又无须过多关心应用程序的监控、扩展性、服务发现和分布式追踪这些繁琐的事情而专注于程序开发，赋予开发者更多的创造性。


## 服务网格架构
服务网格中分为控制平面和数据平面，当前流行的两款开源的服务网格 Istio 和 Linkerd 实际上都是这种架构，只不过 Istio 的划分更清晰，而且部署更零散，很多组件都被拆分，控制平面中包括 Mixer、Pilot、Citadel，数据平面默认是用 Envoy；而 Linkerd 中只分为 Linkerd 做数据平面，namerd 作为控制平面。

**控制平面的特点**

- 不直接解析数据包
- 与数据平面中的代理通信，下发策略和配置
- 负责网络行为的可视化
- 通常提供 API 或者命令行工具可用于配置版本化管理，便于持续集成和部署

**数据平面的特点**

- 通常是按照无状态目标设计的，但实际上为了提高流量转发性能，需要缓存一些数据，因此无状态也是有争议的
- 直接处理入站和出站数据包，转发、路由、健康检查、负载均衡、认证、鉴权、产生监控数据等
- 对应用来说透明，即可以做到无感知部署

### 服务网格的实现模式
Service Mesh 架构示意图：
![Service Mesh架构示意图](https://img-blog.csdnimg.cn/20191116231047738.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9jaHV4aW5nLmJsb2cuY3Nkbi5uZXQ=,size_16,color_FFFFFF,t_70)
### Istio 架构解析
![在这里插入图片描述](https://img-blog.csdnimg.cn/20191116231618741.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9jaHV4aW5nLmJsb2cuY3Nkbi5uZXQ=,size_16,color_FFFFFF,t_70)
- Istio 是独立于平台的，可以在 Kubernetes 、 Consul 、虚拟机上部署的服务
- Istio 的组成
	- Envoy：智能代理、流量控制
	- Pilot：服务发现、流量管理
	- Mixer：访问控制、遥测
	- Citadel：终端用户认证、流量加密
	- Galley（1.1新增）：验证、处理和分配配置
- Service mesh 关注的方面
	- 可观察性
	- 安全性
	- 可运维性
	- 可拓展性
- Istio 的策略执行组件可以扩展和定制，同时也是可拔插的
- Istio 在数据平面为每个服务中注入一个 Envoy 代理以 Sidecar 形式运行来劫持所有进出服务的流量，同时对流量加以控制，通俗的讲就是应用程序你只管处理你的业务逻辑，其他的事情 Sidecar 会汇报给 Istio 控制平面处理
- 应用程序只需关注于业务逻辑（这才能生钱）即可，非功能性需求交给 Istio

**设计目标**
- 最大化透明度
- 可扩展性
- 可移植性
- 策略一致性

### 从边车模式到 Service Mesh

#### 什么是边车模式
>Deploy components of an application into a separate process or container to provide isolation and encapsulation.
--- Sidecar pattern

![SideCar](https://img-blog.csdnimg.cn/2019111623235962.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9jaHV4aW5nLmJsb2cuY3Nkbi5uZXQ=,size_16,color_FFFFFF,t_70)
#### 边车模式设计
有两种方法来实现边车模式：

- 通过 SDK、Lib 等软件包的形式，在开发时引入该软件包依赖，使其与业务服务集成起来。
- 以 Sidecar 的形式，在运维的时候与应用服务集成在一起。

#### 边车模式解决了什么问题
- 控制与逻辑分离的问题
	- 	业务代码只需要关心其复杂的业务逻辑
	-  日志记录、监控、流量控制、服务注册、服务发现、服务限流、服务熔断、鉴权、访问控制等交给边车
- 解决服务之间调用越来越复杂的问题
	- 随着分布式架构越来越复杂和微服务越拆越细，我们越来越迫切的希望有一个统一的控制面来管理我们的微服务，来帮助我们维护和管理所有微服务

#### 从边车模式到 Service Mesh
遵循边车模式进行实践从很早以前就开始了，开发人员一直试图将服务治理等通用功能提取成一个标准化的 Sidecar ，通过 Sidecar 代理来与其他系统进行交互，这样可以大大简化业务开发和运维。而随着分布式架构和微服务被越来越多的公司和开发者接受并使用，这一需求日益凸显。这就是 Service Mesh 服务网格诞生的契机，它是 CNCF（Cloud Native Computing Foundation，云原生基金会）目前主推的新一代微服务架构。

Service Mesh 将底层那些难以控制的网络通讯统一管理，诸如：流量管控，丢包重试，访问控制等。而上层的应用层协议只需关心业务逻辑即可。Service Mesh 是一个用于处理服务间通信的基础设施层，它负责为构建复杂的云原生应用传递可靠的网络请求。

## Kubernetes vs Service Mesh
> Kubernetes 管理的对象是 Pod，Service Mesh 中管理的对象是 Service。
- Kubernetes 的本质是应用的生命周期管理，具体来说就是部署和管理（扩缩容、自动恢复、发布）。
- Kubernetes 为微服务提供了可扩展、高弹性的部署和管理平台。
- Service Mesh 的基础是透明代理，通过 sidecar proxy 拦截到微服务间流量后再通过控制平面配置管理微服务的行为。
- Service Mesh 将流量管理从 Kubernetes 中解耦，Service Mesh 内部的流量无需 kube-proxy 组件的支持，通过为更接近微服务应用层的抽象，管理服务间的流量、安全性和可观察性。
- Service Mesh 是对 Kubernetes 中的 service 更上层的抽象，它的下一步是 serverless。

---

本文是针对ServiceMesher社区系列文章而整理的学习笔记，文章地址：https://www.servicemesher.com/istio-handbook/intro/service-mesh-the-microservices-in-post-kubernetes-era.html


---

> 作者:   
> URL: https://xzygis.github.io/posts/introduction-of-service-mesh/  

