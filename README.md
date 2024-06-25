# flutter_video_community

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


### 处理Mac由于证书无法启动
重新生成证书，将证书迁移到 android/app/key/pile-keystore.jks 路径去替换即可
keytool -genkey -v -keystore pile-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pile -storetype JKS