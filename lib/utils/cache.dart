import 'package:flutter_video_community/data/models/index/login.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';
import 'package:flutter_video_community/data/models/main/main_app.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';

class Cache {
  Cache._({
    this.token,
    this.login,
    this.userInfo,
    this.appConfig,
    this.mainApp,
  });

  String? token;
  LoginModel? login;
  UserModel? userInfo;
  AppConfigModel? appConfig;
  MainAppModel? mainApp;

  bool get isLogin => null != token && token!.isNotEmpty;

  static Cache? _instance;

  static Cache getInstance() {
    return _instance!;
  }

  static Future<Cache> init() async {
    final indexRepository = IndexRepository();
    _instance ??= Cache._(
      token: await indexRepository.tokenFromCache(),
      login: await indexRepository.loginResultFromCache(),
      userInfo: await indexRepository.userInfoFromCache(),
      appConfig: await indexRepository.appConfigInfoFromCache(),
      mainApp: await indexRepository.mainAppInfoFromCache(),
    );
    return _instance!;
  }

  static Cache applyWith({
    String? token,
    LoginModel? login,
    UserModel? userInfo,
    AppConfigModel? appConfig,
    MainAppModel? mainApp,
  }) {
    _instance!.token = token ?? _instance!.token;
    _instance!.login = login ?? _instance!.login;
    _instance!.userInfo = userInfo ?? _instance!.userInfo;
    _instance!.appConfig = appConfig ?? _instance!.appConfig;
    _instance!.mainApp = mainApp ?? _instance!.mainApp;
    return _instance!;
  }

  static Future<void> clear() async {
    _instance!.token = null;
    _instance!.login = null;
    _instance!.userInfo = null;
    _instance!.appConfig = null;
    _instance!.mainApp = null;
  }
}
