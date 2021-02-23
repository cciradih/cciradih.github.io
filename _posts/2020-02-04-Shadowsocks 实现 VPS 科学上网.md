---
layout: post
categories:
  - 科学上网
tags:
  - Shadowsocks
---

## 准备

* 一台 SSH 能连接的境外 VPS

## 配置

### Shadowsocks

1. 安装
```shell 
apt-get install shadowsocks-libev
```
2. 配置
```shell 
nano /etc/shadowsocks-libev/config.json
```
```json
{
    "server":"${host}", // 地址，客户端需要一致。
    "server_port":"${port}", // 端口，客户端需要一致。
    "local_port":1080,
    "password":"${password}", // 密码，客户端需要一致。
    "timeout":60,
    "method":"chacha20-ietf-poly1305"
}
```
3. 启动
```shell
systemctl restart shadowsocks-libev
```

### 客户端
以 Windows 10 系统为例。

属性 | 值
-- | --
服务器地址 | ${host}
服务器端口端口 | ${port}
密码 | ${password}
加密 | chacha20-ietf-poly1305

## 附录

* [Shadowsocks - A secure socks5 proxy](https://shadowsocks.org/en/index.html)
* [Shadowsocks - Quick Guide](https://shadowsocks.org/en/config/quick-guide.html)
