import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';
import 'package:flutter_video_community/data/models/index/login.dart';
import 'package:flutter_video_community/data/models/main/main_app.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/repository/index/index_api.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/utils/storage/index.dart';

class IndexRepository {
  final IndexApi _api = IndexApi();

  Future<LoginModel> login(
    Map<String, dynamic> dataMap,
  ) async {
    String deviceType = AppUtil.getPlatform();
    String clientId = AppUtil.getClientByPlatform();
    String? deviceId = await CommonUtil().deviceId();
    debugPrint('login deviceId=${deviceId}');
    dataMap.putIfAbsent('grantType', () => 'deviceId');
    dataMap.putIfAbsent('tenantId', () => AppConfig.tenantId);
    dataMap.putIfAbsent('userType', () => 'app_user');
    dataMap.putIfAbsent('deviceType', () => deviceType);
    dataMap.putIfAbsent('clientId', () => clientId);
    dataMap.putIfAbsent('deviceId', () => deviceId );
    final response = await _api.login(dataMap);
    final data = LoginModel.fromJson(
      response.data as Map<String, dynamic>,
    );
    await persistLoginResult(data);
    await persistToken(data.accessToken);
    return data;
  }

  Future<bool> changeDevice(
    Map<String, dynamic> dataMap,
  ) async {
    final response = await _api.changeDevice(dataMap);
    if (response.success) {
      return response.data as bool;
    } else {
      return false;
    }
  }

  Future<UserModel?> userInfo() async {
    final response = await _api.userInfo();
    final data = UserInfoRsp.fromJson(
      response.data as Map<String, dynamic>,
    );
    await persistUserInfo(data.user);
    return data.user;
  }

  Future<AppConfigModel?> appConfigInfo() async {
    try {
      final response = await _api.appConfigInfo();
      if (response.success) {
        final data = AppConfigModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        await persistAppConfigInfo(data);
        return data;
      } else {
        return await appConfigInfoFromCache();
      }
    } catch (error) {
      return await appConfigInfoFromCache();
    }
  }

  Future<MainAppModel?> mainAppInfo() async {
    try {
      final response = await _api.mainAppInfo();
      if (response.success) {
        final data = MainAppModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        await persistMainAppInfo(data);
        return data;
      } else {
        final data = await mainAppInfoFromCache();
        return data;
      }
    } catch (error) {
      final data = await mainAppInfoFromCache();
      return data;
    }
  }

  /// 存储主应用信息到本地
  Future<bool> persistMainAppInfo(MainAppModel? mainApp) async {
    if (null == mainApp) {
      return false;
    }
    try {
      Cache.applyWith(mainApp: mainApp);
      return Storage.instance.setString(
        StorageKey.mainApp,
        jsonEncode(mainApp),
      );
    } catch (error) {
      Zone.current.handleUncaughtError(error, StackTrace.current);
      return false;
    }
  }

  /// 从本地存储获取主应用信息
  Future<MainAppModel?> mainAppInfoFromCache() async {
    final data = Storage.instance.getString(StorageKey.mainApp);
    if (data.isEmpty) {
      return null;
    }
    return MainAppModel.fromJson(
      jsonDecode(data) as Map<String, dynamic>,
    );
  }

  /// 存储App信息到本地
  Future<bool> persistAppConfigInfo(AppConfigModel? appConfig) async {
    if (null == appConfig) {
      return false;
    }
    try {
      Cache.applyWith(appConfig: appConfig);
      return Storage.instance.setString(
        StorageKey.appConfig,
        jsonEncode(appConfig),
      );
    } catch (error) {
      Zone.current.handleUncaughtError(error, StackTrace.current);
      return false;
    }
  }

  /// 从本地存储获取App信息
  Future<AppConfigModel?> appConfigInfoFromCache() async {
    final data = Storage.instance.getString(StorageKey.appConfig);
    if (data.isEmpty) {
      return null;
    }
    return AppConfigModel.fromJson(
      jsonDecode(data) as Map<String, dynamic>,
    );
  }

  /// 存储用户信息到本地
  Future<bool> persistUserInfo(UserModel? userInfo) async {
    if (null == userInfo) {
      return false;
    }
    try {
      Cache.applyWith(userInfo: userInfo);
      return Storage.instance.setString(
        StorageKey.userInfo,
        jsonEncode(userInfo),
      );
    } catch (error) {
      Zone.current.handleUncaughtError(error, StackTrace.current);
      return false;
    }
  }

  Future<void> clearToken() async {
    Cache.applyWith(token: '');
    Storage.instance.remove(StorageKey.token);
  }

  /// 存储 token 信息到本地
  Future<bool> persistLoginResult(LoginModel? result) async {
    if (null == result) {
      return false;
    }
    try {
      Cache.applyWith(login: result);
      return Storage.instance.setString(
        StorageKey.login,
        jsonEncode(result),
      );
    } catch (error) {
      Zone.current.handleUncaughtError(error, StackTrace.current);
      return false;
    }
  }

  /// 从本地存储获取用户信息
  Future<LoginModel?> loginResultFromCache() async {
    final data = Storage.instance.getString(StorageKey.login);
    if (data.isEmpty) {
      return null;
    }
    return LoginModel.fromJson(
      jsonDecode(data) as Map<String, dynamic>,
    );
  }

  /// 存储 token 信息到本地
  Future<bool> persistToken(String? token) async {
    if (null == token) {
      return false;
    }
    try {
      Cache.applyWith(token: token);
      return Storage.instance.setString(
        StorageKey.token,
        token,
      );
    } catch (error) {
      Zone.current.handleUncaughtError(error, StackTrace.current);
      return false;
    }
  }

  /// 从本地存储获取用户信息
  Future<UserModel?> userInfoFromCache() async {
    final data = Storage.instance.getString(StorageKey.userInfo);
    if (data.isEmpty) {
      return null;
    }
    return UserModel.fromJson(
      jsonDecode(data) as Map<String, dynamic>,
    );
  }

  /// 从本地存储获取 token
  Future<String?> tokenFromCache() async {
    final data = Storage.instance.getString(StorageKey.token);
    if (data.isEmpty) {
      return null;
    }
    return data;
  }
}
