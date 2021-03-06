---
layout: post
categories:
  - 科学上网
tags:
  - V2Ray
  - Cloudflare
  - Caddy
---

## 准备

* 一个域名
* 一个 CloudFlare 账号
* 一台 SSH 能连接的境外 VPS

## 配置

### CloudFlare

1. DNS 中使用 A 记录将域名指向 VPS 的 IP 地址。
2. SSL/TLS 中模式选择 FULL。

* 首先关闭 CDN 功能，变灰黄云图标。在后面 VPS 操作中当 Caddy 成功申请证书后再打开。

### V2Ray

1. 安装
```shell
bash <(curl -L -s https://install.direct/go.sh)
```
2. 配置
```shell
nano /etc/v2ray/config.json 
```
```json
{
  "inbounds": [{
    "port": "${port}", // 端口，Caddy 需要监听此端口。
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "${UUID}", // 用户 UUID，客户端需要一致。
          "level": 1,
          "alterId": 64
        }
      ]
    },
    "streamSettings": {
        "network": "ws" // 协议，客户端需要一致。
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  },{
    "protocol": "blackhole",
    "settings": {},
    "tag": "blocked"
  }],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": ["geoip:private"],
        "outboundTag": "blocked"
      }
    ]
  }
}
```
3. 启动
```shell
systemctl restart v2ray
```

### Caddy

1. 安装
```shell
curl https://getcaddy.com | bash -s personal
```
2. 配置
```shell
nano Caddyfile
```
```
${host} { // 域名，客户端需要一致。
    tls ${email} // 自动配置 TLS 证书，用于加密传输。
    proxy / localhost:${port} { // 端口，V2Ray 需要监听此端口。
        websocket // 协议，客户端需要一致。
    }
}
```
3. 启动
```shell
caddy -conf Caddyfile
```

### 客户端
以 Windows 10 系统为例。

属性 | 值
-- | --
地址 | ${host}
端口 | ${port}
用户 ID | ${UUID}
额外 ID | 64
加密方式 | auto
传输协议 | ws
别名 | ${host}
伪装类型 | none
伪装域名 | ${host}
路径 | /
底层传输安全 | tls

## 附录

* [Cloudflare](https://www.cloudflare.com/zh-cn/)
* [Project V · Project V 官方网站](https://www.v2ray.com/)
* [V2Ray 白话文教程](https://toutyrater.github.io/)
