---
layout: post
categories:
  - 应用程序
tags:
  - Visual Studio Code
  - Windows Subsystem for Linux
---

## 准备

* [Windows 10 Build 高于 19041（2020 年 5 月更新）](https://www.microsoft.com/zh-cn/software-download/windows10)
* 下载 [Linux 内核更新包](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
* 下载 [Ubuntu 18.04 发行版](https://aka.ms/wsl-ubuntu-1804)
* 安装 [VS Code for Windows](https://aka.ms/win32-x64-user-stable)

## WSL

以下命令都在具有**管理员**权限的 Power Shell 中运行。

### 配置

1. 启用“适用于 Linux 的 Windows 子系统”可选功能
```batchfile
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```
2. 启用“虚拟机平台”可选组件
```batchfile
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
3. 重新启动计算机
4. 安装 Linux 内核更新包
5. 将 WSL 2 设置为默认版本
```batchfile
wsl --set-default-version 2
```

### 安装
1. 安装发行版（distro 是发行版文件的名称。）
```batchfile
Add-AppxPackage distro.appx
```
2. 在开始菜单中运行一次 Ubuntu 18.04 LTS

## VS Code

### 配置

1. 安装 [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) 扩展
2. 单击左下角并选择“Remote-WSL: New Window”
3. 选择默认 Shell 为 Bash

## 提示

* 开启 Windows 网络发现以通过 Windows 主机进行网络访问。
* 使用 `code -r .` 在 WSL 中打开当前目录。
* 替换默认源。
* 安装 Privoxy 转发 Shadowsocks 的 Socks5 协议科学上网。
* 直接使用 V2Ray 的 HTTP 代理端口科学上网。

## 附录

* [在 Windows 10 上安装适用于 Linux 的 Windows 子系统 (WSL)](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10)
