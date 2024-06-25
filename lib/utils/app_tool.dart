

// 用于全局项目提效的方法
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:extended_image/extended_image.dart';

class AppTool{
  /// 适用于多个被逗号隔开的字符串
  static String getFirstStr(String data) {
    String result = '';
    if (data.isNotEmpty && data.contains(",")) {
      result = data.split(",")[0];
    }
    return result;
  }

  static bool isEmpty(String? str){
    if (str != null && str.isNotEmpty ) {
      return false;
    }
    return true;
  }

  static bool isNotEmpty(String? str){
    if (str != null && str.isNotEmpty ) {
      return true;
    }
    return false;
  }

  //避免url太长，截取一部分作为logic的tag
  static String getLogicTag(String url) {
    if (url.isEmpty) {
      return '';
    }
    if (url.length > 31) {
      return url.substring(0, 30);
    } else if (url.length > 21) {
      return url.substring(0, 20);
    }
    return url;
  }

  static String md5RandomStr() {
    final ranNum = Random().nextDouble();
    final randomStr = md5.convert(utf8.encode(ranNum.toString())).toString();
    return randomStr;
  }

}