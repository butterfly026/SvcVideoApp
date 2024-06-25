
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';
import 'package:flutter_video_community/utils/storage/index.dart';

class CacheUtil{

  static UserModel? getUserInfoFromCache() {
    final data = Storage.instance.getString(StorageKey.userInfo);
    if (data.isEmpty) {
      return null;
    }
    return UserModel.fromJson(
      jsonDecode(data) as Map<String, dynamic>,
    );
  }

  static AppConfigModel? getAppConfigInfoFromCache() {
    final data = Storage.instance.getString(StorageKey.appConfig);
    if (data.isEmpty) {
      return null;
    }
    return AppConfigModel.fromJson(
      jsonDecode(data) as Map<String, dynamic>,
    );
  }

  static void setNeedUpdateUserInfo(bool needUpdate) {
     Storage.instance.setBool(
      StorageKey.needUpdateUserInfo, needUpdate,
    );
  }

  static bool getNeedUpdateUserInfo(){
    return Storage.instance.getBool(
      StorageKey.needUpdateUserInfo
    );
  }


}