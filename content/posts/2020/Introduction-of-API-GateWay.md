---
title: API网关概述
date: 2020-01-27 22:51:43
tags: ["API网关"]
categories: ["后台开发"]
---

## 1 背景
- 由于后端的微服务拆分，客户端通常需要请求多个服务获取所需数据。
- 不同客户端所需要的数据不一样。例如，PC需要的数据通常比移动端更加详细。
- 不同客户端网络环境差异大。例如，WAN vs LAN，移动网络 vs 非移动网络。
- 服务端实例的地址信息（IP + port）会动态更新。
- 微服务的拆分逻辑会变化，这种变化应该应该对客户端透明。
- 不同的服务可能采用不同的协议，有些协议是非web的。

## 2 什么是API网关？
API网关接收客户端的所有请求，并将请求路由到相应的后端服务，并提供接口聚合和协议转换。通常来说，API网关通过调用多个后端服务，并聚合结果的方式处理请求。它可将web协议转化为非web的内部后台协议。

<!-- more -->

核心功能：
- 服务发现：
- 负载均衡：以某种算法分摊系统压力。
- 服务熔断：直接返回失败或者执行降价逻辑，防止雪崩。
- 流量控制：防止短时间内大量请求转发到后台压垮服务器。
- 认证鉴权：验证客户端的请求是否被授权。
- 灰度发布：

其他功能：
- 协议转换：web协议转非Web协议。
- 参数校验：对入参设置校验规则，由网关根据规则对无效请求进行过滤。
- API管理：包括 API 的创建、测试、发布、下线、版本切换等。
- 监控告警：监控API请求次数、API调用延迟和API错误信息。
- SDK生成：

## 3 实现方式
将API网关作为客户端的唯一接入点。API网关主要有两种类型：
- one-size-fits-all网关
- Backends for frontends网关

### 3.1 One-size-fits-all网关
简单地将请求路由到相应服务。将请求扇出到多个后端服务。
![OSFA API Gateway](https://img-blog.csdnimg.cn/20191013124932708.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9jaHV4aW5nLmJsb2cuY3Nkbi5uZXQ=,size_16,color_FFFFFF,t_70)

### 3.2 Backends for fronts网关
为每种客户端暴露不同的API。为每种客户端设计一个API网关，每个API网关为其客户端提供一种API。
![Backends fro frontends API Gateway](https://img-blog.csdnimg.cn/20191013125314703.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9jaHV4aW5nLmJsb2cuY3Nkbi5uZXQ=,size_16,color_FFFFFF,t_70)

## 4 优点
- 使后端的微服务拆分对客户端透明。
- 客户端无需关心后端服务的实例地址（IP + port）。
- 可为每个客户端提供最优API。
- 减少请求次数。
- 简化客户端的逻辑（由调用多个后台服务变为只调用API网关）。
- 可将标准的Web API协议转化为任意的后端协议。

## 5 缺点
- 增加复杂性。增加了API网关模块，带来了额外的开发、部署、管理成本。
- 增加响应时间。调用链路多了一跳（API网关）。

> **Issues:**
> 
> How implement the API gateway?
> 
> event-driven/reactive approach is the best if it must scale to handle high loads.

参考来源：
- https://microservices.io/patterns/apigateway.html
- https://www.nginx.com/learn/api-gateway/
- https://aws.amazon.com/cn/api-gateway/features/
- https://cloud.tencent.com/document/product/628/11755
