import 'dart:convert';

import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';

class OpenInstallTool {
  late String log;
  static final OpeninstallFlutterPlugin _openinstallFlutterPlugin =
      OpeninstallFlutterPlugin();

  // op 唤起参数
  static Map<String, dynamic> evokeData = {};

  OpeninstallFlutterPlugin get openinstallFlutterPlugin =>
      _openinstallFlutterPlugin;

  // 初始化插件
  static Future<void> initPlatformState() async {
    _openinstallFlutterPlugin.init(wakeupHandler);
  }

  // 上传报告注册统计
  static void reportRegister() {
    _openinstallFlutterPlugin.reportRegister();
  }

  // 埋点统计
  static void reportEffectPoint(String key) {
    _openinstallFlutterPlugin.reportEffectPoint("shoucang", 1);
  }

  // 唤醒回调 （获取web端传过来的参数，根据参数打开特定并展示数据页面）
  static Future wakeupHandler(Map<String, dynamic> data) async {
    print('op newest evoke ${jsonEncode(data)}');
    evokeData = data;
    return data;
  }

  // 获取安装统计回调 （如邀请码、游戏房间号等动态参数）
  static Future installHandler(Map<String, dynamic> data) async {
    print('op newest install ${jsonEncode(data)}');
    return data;
  }
}
