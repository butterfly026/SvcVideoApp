import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommonUtil {
  factory CommonUtil() => _sharedInstance();

  CommonUtil._() {
    _init();
  }

  static CommonUtil? _instance;

  static CommonUtil _sharedInstance() {
    _instance ??= CommonUtil._();
    return _instance!;
  }

  late AndroidId _androidId;
  late DeviceInfoPlugin _deviceInfo;

  Future<void> _init() async {
    _androidId = const AndroidId();
    _deviceInfo = DeviceInfoPlugin();
  }

  Future<AndroidDeviceInfo> deviceInfo() async {
    final androidInfo = await _deviceInfo.androidInfo;
    return androidInfo;
  }

  Future<String> model() async {
    if (DeviceUtil.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    } else if (DeviceUtil.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return '${androidInfo.brand} ${androidInfo.model}';
    }
    return '';
  }

  Future<String> version() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> buildNumber() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<String> packageName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  Future<String?> deviceId() async {
    if (DeviceUtil.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else if (DeviceUtil.isAndroid) {
      final androidDeviceId = await _androidId.getId();
      return androidDeviceId;
    } else if (DeviceUtil.isWeb) {
      final WebBrowserInfo webBrowserInfo = await _deviceInfo.webBrowserInfo;
      return webBrowserInfo.userAgent;
    }
    return '';
  }

  static Future<bool> launchUrl(
    String urlString, {
    LaunchMode mode = LaunchMode.platformDefault,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    final url = replaceUrlPlaceholder(urlString);
    return launchUrlString(
      url,
      mode: mode,
      webViewConfiguration: webViewConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    );
  }

  static String replaceUrlPlaceholder(String origin) {
    var url = origin;
    final cache = Cache.getInstance();
    if (url.contains('{tenantId}') && cache.userInfo != null) {
      url = url.replaceAll('{tenantId}', cache.userInfo!.tenantId);
    }
    if (url.contains('{userId}') && cache.userInfo != null) {
      url = url.replaceAll('{userId}', cache.userInfo!.userId);
    }
    if (url.contains('{deviceId}') && cache.userInfo != null) {
      url = url.replaceAll('{deviceId}', cache.userInfo!.deviceId);
    }
    if (url.contains('{token}') && cache.token != null) {
      url = url.replaceAll('{token}', cache.token!);
    }
    if (url.contains('{clientId}')) {
      url = url.replaceAll('{clientId}', AppUtil.getClientByPlatform());
    }
    return url;
  }

  //检查字符串是否为有效的 JSON
  static bool isJson(String jsonStr) {
    try {
      json.decode(jsonStr);
      return true;
    } catch (e) {
      return false;
    }
  }
}
