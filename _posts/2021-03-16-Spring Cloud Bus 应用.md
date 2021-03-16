---
layout: post
categories:
  - 程序开发
tags:
  - Spring Cloud Bus
  - Spring Cloud Stream
  - Spring AMQP
  - RabbitMQ
---

## 摘要

Spring Cloud Bus 将轻量级消息代理链接到分布式系统的结点，然后可以将其用于消息广播。其消息代理由 AMQP 和/或 Kafak 的实现，底层由 Spring Cloud Stream 实现。本文意在从应用的角度去调研其工作原理、应用场景及性能表现。

## 前言

新平台的部分架构是本文的来源背景，但我的内生驱动力来自于对 Spring Cloud 生态的兴趣。分布式的消息总线是整个体系中不可或缺的一部分，官方应用场景是通过消息总线透明地让配置中心更新其下辖节点的配置，这也是为什么被称为“轻量级”的原因。不过基于压力测试来看，其单机性能表现可以轻松应对万级并发。

## 关键字

Spring Cloud Bus、Spring Cloud Stream、Spring AMQP、RabbitMQ。

## 通信原理

![通信原理.png](https://cciradih.top/assets/post/通信原理.png)

## 应用配置

### 依赖

![依赖.png](https://cciradih.top/assets/post/依赖.png)

可以看到依赖树中包含了 Spring Cloud Stream 的依赖，这对接下来的应用很重要。

### application.yml

```yaml
server:
  port: 8281
eureka:
  client:
    service-url:
      defaultZone: http://eureka-server-alfa:8181/eureka/,http://eureka-server-bravo:8182/eureka/,http://eureka-server-charlie:8183/eureka/
  instance:
    appname: client-alfa
#    命名 destination。
    instance-id: client-alfa:8281
spring:
  application:
    name: client-alfa
  cloud:
    stream:
      rabbit:
        bindings:
#          Spring Cloud Stream 的输入 bindings。
#          可在 org.springframework.cloud.bus 的包里的 SpringCloudBusClient 定位到此配置。
          springCloudBusInput:
#            消费者配置。
            consumer:
#              最大并发数。
              maxConcurrency: 20
#              每一次通信的确认数。
              batchSize: 2000
#              命名队列。
              anonymousGroupPrefix: client-alfa.
          springCloudBusOutput:
            consumer:
              maxConcurrency: 20
              batchSize: 2000
              anonymousGroupPrefix: client-alfa.
#  RabbitMQ 连接配置。
#  rabbitmq:
#    port:
#    host:
#    username:
#    password:
```

由于 ```spring.cloud.stream.rabbit.bindings``` 的配置是 Map 映射键值对，所以必须得确认有效配置，经过源码分析，可以找到针对 Spring Cloud Bus 的专有 binding：springCloudBusInput、springCloudBusOutput。而默认的并发只有1，想要提高并发性能在 Spring AMQP 的官方文档里有定义。

![prefetch.png](https://cciradih.top/assets/post/prefetch.png)

并不建议直接提高 prefetch 值，文档有具体说明，所以我们只需要设置 maxConcurrency（默认值1）以便随着性能需求并发量逐步上升，具体上升公式在文档也是有，在此不再赘述，以及 batchSize（默认值100）提高每次通信的消费数量。

## 监听与推送

### 创建事件子类，继承自RemoteApplicationEvent

```java
package top.cciradih.lib.event;

import lombok.Getter;
import org.springframework.cloud.bus.event.RemoteApplicationEvent;

@Getter
public class Event extends RemoteApplicationEvent {
    private String message;

    private Event() {
    }

    public Event(String message, String originService, String destinationService) {
        super(message, originService, destinationService);
        this.message = message;
    }
}
```

### 配置监听器

```java
package top.cciradih.eurekaclientalfa.configuration;

import org.springframework.cloud.bus.jackson.RemoteApplicationEventScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import top.cciradih.lib.event.Event;

@Configuration
@RemoteApplicationEventScan(basePackageClasses = Event.class)
public class BusConfiguration {
    @EventListener
    public void listen(Event event) {
    }
}
```

### 推送事件

```java
package top.cciradih.eurekaclientalfa.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.bus.BusProperties;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import top.cciradih.lib.event.Event;

@Service
public class AlfaService {
    private final ApplicationEventPublisher applicationEventPublisher;
    private final BusProperties busProperties;

    @Autowired
    public AlfaService(ApplicationEventPublisher applicationEventPublisher, BusProperties busProperties) {
        this.applicationEventPublisher = applicationEventPublisher;
        this.busProperties = busProperties;
    }

    public void sendToAll(String message) {
        String originService = busProperties.getId();
        Event event = new Event(message, originService, "client-bravo:8282");
        applicationEventPublisher.publishEvent(event);
    }
}
```

```busProperties.getId()``` 对应的就是配置中的 ```instance-id```。构建 event 对象后，通过 applicationEventPublisher 就可以推送事件。

## 总结

由于我的电脑配置相比于极限压力测试的需求过低（8C/16G），并不能进行崩溃测试，但是预估性能表现能轻松应对万级并发。

## 附录

* [Spring Cloud Bus](https://docs.spring.io/spring-cloud-bus/docs/current/reference/html/)
* [Spring Cloud Stream](https://docs.spring.io/spring-cloud-stream/docs/current/reference/html/)
* [Spring AMQP](https://docs.spring.io/spring-amqp/docs/current/reference/html/)
* [RabbitMQ](https://www.rabbitmq.com/getstarted.html)
