---
layout: post
toc: true
categories:
  - 科学上网
tags:
  - Shadowsocks
---

> 听闻 Shadowsocks 也出了 Rust 版本了，~~我以后可能会更新 Rust 语言相关的文章~~。

## 前言
最近 Shadowsocks 又能用了，我觉得吧以后不行的时候再用 V2Ray，因为 V2Ray 的 Windows 客户端和网易 UU 加速器冲突，而我不想折腾。

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
