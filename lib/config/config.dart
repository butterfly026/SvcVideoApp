import 'dart:math';

import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';

class AppConfig {
  static const String defaultBaseUrl = 'http://43.139.52.190:100/api';
  static String baseUrl = '';

  /// 接口code对应字段名字
  static const String codeFiledName = "code";

  /// 接口message字段名
  static const String messageFiledName = "msg";

  static String cityId = '';
  static String privateKey = '';
  static String publicKey = '';
  static const bool isEncEnabled = true;
  static const int aesKeyLength = 32;

  /// TenantId
  static const String tenantId = '000000';
  static const String androidClientId = '428a8310cd442757ae699df5d894f051';
  static const String iosClientId = '428a8310cd442757ae699df5d894f051';
  static const String webClientId = '428a8310cd442757ae699df5d894f051';

  static String randomImage({
    int width = 100,
    int height = 200,
    int index = 0,
  }) {
    return 'https://picsum.photos/$width/$height?random=${Random().nextInt(100)}';
  }

  static final List<AppIconModel> deskIconList = [
    const AppIconModel(
        name: 'app-icon1.png',
        title: '手机管家',
        icon: 'assets/images/app_icon1.png'),
    const AppIconModel(
        name: 'app-icon2.png',
        title: '天气',
        icon: 'assets/images/app_icon2.png'),
    const AppIconModel(
        name: 'app-icon3.png',
        title: '安全卫士',
        icon: 'assets/images/app_icon3.png'),
    const AppIconModel(
        name: 'app-icon4.png',
        title: '清理大师',
        icon: 'assets/images/app_icon4.png'),
  ];

  static List<String> apiBinList = [
    'https://new-crmf.oss-accelerate.aliyuncs.com/api-dev.bin',
    'https://d3ij1ija1zfyox.cloudfront.net/api-dev.bin',
    'https://newcrmf.new10000.icu/api-dev.bin',
  ];

  static final apiBinDataMap = <String, List<String>>{
    'api': [
      'https://new-crmf.oss-accelerate.aliyuncs.com/api-dev.bin',
      'https://d3ij1ija1zfyox.cloudfront.net/api-dev.bin',
      'https://newcrmf.new10000.icu/api-dev.bin',
    ],
  };
}
