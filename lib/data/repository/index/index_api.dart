import 'package:flutter_video_community/utils/http/http.dart';
import 'package:flutter_video_community/utils/http/src/service.dart';

class IndexApi {
  /// 登录
  Future<HttpResponse> login(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.post(
      '/auth/api/login',
      data: dataMap,
    );
  }

  /// 更换设备
  Future<HttpResponse> changeDevice(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.put(
      '/system/api/changeDeviceId',
      data: dataMap,
    );
  }

  /// 获取用户信息
  Future<HttpResponse> userInfo() async {
    return await httpService.get(
      '/system/api/getUserInfo',
    );
  }

  /// 获取APP配置信息
  Future<HttpResponse> appConfigInfo() async {
    return await httpService.get(
      '/app/api/getAppConfig',
    );
  }

  /// 获取主应用信息
  Future<HttpResponse> mainAppInfo() async {
    return await httpService.get(
      '/app/api/getMainApp',
    );
  }
}
