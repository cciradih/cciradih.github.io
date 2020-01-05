---
layout: post
---

# Cloudflare 与 V2Ray 让 VPS 重获新生

> * 事实上这是目前除肉身翻墙最后的法子了。

## 摘要
其实你要拯救 VPS，首先得有一个梯子。那么问题来了，如果有梯子，那还需要拯救这个 VPS 吗？

## 前言
从国庆到现在我的梯子还没恢复，不用谷歌感觉断了两条腿。偶然发现 Cloudflare 的 CDN 在国内能够直接访问，然后联想到 WebSocket 协议和最近一直在研究的 V2Ray，感觉有戏。遂实践了一下，遇到了些坑，不过总算是柳暗花明又一村。

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
```bash
bash <(curl -L -s https://install.direct/go.sh)
```
2. 配置
```bash
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
```bash
systemctl restart v2ray
```

### Caddy

1. 安装
```bash
curl https://getcaddy.com | bash -s personal
```
2. 配置
```bash
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
```bash
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

## 致谢

* [Cloudflare](https://www.cloudflare.com/zh-cn/)
* [V2Ray 白话文教程](https://toutyrater.github.io/)

## 附录

* [Project V · Project V 官方网站](https://www.v2ray.com/)
