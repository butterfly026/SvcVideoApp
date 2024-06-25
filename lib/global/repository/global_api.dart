import 'package:dio/dio.dart';
import 'package:flutter_video_community/utils/http/http.dart';
import 'package:flutter_video_community/utils/http/src/service.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../utils/umeng_util.dart';

class GlobalApi {
  Future<Response<String>> getIpAddress(
    FormData formData,
  ) async {
    return await http.post<String>(
      'https://ip.taobao.com/outGetIpInfo',
      data: formData,
    );
  }

  Future<Response<String>> getUserAddressInfo(
    String ip,
  ) async {
    return await http.get<String>(
      'http://ip.taobao.com/service/getIpInfo.php?ip=$ip',
    );
  }

  /// 获取APP广告
  Future<HttpResponse> adsData(
    String appId,
  ) async {
    return await httpService.get(
      '/app/api/getAppAdvByAppId',
      data: <String, dynamic>{'appid': appId},
    );
  }

  Future<HttpResponse> createOrder(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.post(
      '/pay/api/create',
      data: dataMap,
    );
  }

  Future<HttpResponse> uploadClickEvent(
    Map<String, dynamic> dataMap,
  ) async {
    UmengUtil.upPoint(
        UMengType.buttonClick, {'name': UMengEvent.advPv, 'desc': '广告查看'});
    return await httpService.get(
      '/app/api/click',
      data: dataMap,
    );
  }
}
