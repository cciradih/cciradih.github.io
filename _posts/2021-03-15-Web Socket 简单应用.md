---
layout: post
categories:
  - 程序开发
tags:
  - Web Socket
  - STOMP
---

## 摘要

Web Socket 是支持在浏览器与服务器之间进行全双工通信的协议，STOMP 是一种面向文本的消息传递协议。简单对比可以认为 WS 是 TCP，而 STOMP 对应的是 HTTP。

## 实现

### Spring Web Socket 服务端

Spring Web Socket 实现了 STOMP 协议，所以可以很轻松地与支持 STOMP 的客户端进行通信。

1. 引入包：

```groovy
implementation 'org.springframework.boot:spring-boot-starter-websocket'
```

2. 实现 WebSocketMessageBrokerConfigurer：

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketMessageBroker implements WebSocketMessageBrokerConfigurer {
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/web-socket/").setAllowedOrigins("*");
    }
}
```

3. 编写 WebSocketController：

```java
@CrossOrigin("*")
@RestController
public class WebSocketController {
    @MessageMapping("/sender/")
    @SendTo("/receiver/")
    public String send(String message) {
        return message;
    }
}
```

### STOMPJS 客户端

1. 安装包：

```bash
npm i @stomp/stompjs -S
```

2. 引入包：

```javascript
import { Client } from '@stomp/stompjs'
Vue.prototype.$stompjs = new Client()
```

3. 配置连接与接受消息：

```javascript
const stompConfig = {
  brokerURL: "ws://127.0.0.1:8081/web-socket/",
  reconnectDelay: 200,
  onConnect: () => {
    this.$stompjs.subscribe("/receiver/", (message) => {
      this.message.push(message.body);
    });
  },
};
this.$stompjs.configure(stompConfig);
this.$stompjs.activate();
```

4. 发送消息：

```javascript
sendMessage() {
  this.$stompjs.publish({
    destination: "/sender/",
    body: this.message,
  });
},
```