import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/data/models/api_bin.dart';
import 'package:flutter_video_community/data/models/ip.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/global/repository/global_api.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/http/http.dart';

class GlobalRepository {
  final GlobalApi _api = GlobalApi();

  Future<IpModel?> getIpAddress() async {
    FormData formData = FormData.fromMap(
      {
        'ip': Cache.getInstance().userInfo?.loginIp,
        'accessKey': 'alibaba-inc',
      },
    );

    final response = await _api.getIpAddress(formData);
    if (response.statusCode == 200 && null != response.data) {
      final dataMap = jsonDecode(response.data!)['data'] as Map<String, dynamic>;
      final ipModel = IpModel.fromJson(dataMap);
      AppConfig.cityId = ipModel.cityId;
      return ipModel;
    }
    return null;
  }

  Future<AdsRsp?> adsData(
    String appId,
  ) async {
    final response = await _api.adsData(appId);
    if (response.success) {
      return AdsRsp.fromJson(
        response.data as Map<String, dynamic>,
      );
    }
    return null;
  }

  Future<String?> createOrder(
    Map<String, dynamic> dataMap,
  ) async {
    final response = await _api.createOrder(dataMap);
    if (response.success) {
      return response.data as String;
    }
    return null;
  }

  Future<void> uploadClickEvent(
    String advId,
  ) async {
    final dataMap = <String, dynamic>{
      'advId': advId,
    };
    await _api.uploadClickEvent(dataMap);
  }

  Future<ApiBinData?> getFastestHost() async {
    final fastestBaseUrl = await _fastestHost(
      jsonEncode(AppConfig.apiBinDataMap),
    );
    if (null == fastestBaseUrl) {
      return null;
    } else {
      String? baseUrl = fastestBaseUrl;
      if (fastestBaseUrl.endsWith('.bin') == true) {
        baseUrl = fastestBaseUrl.substring(0, fastestBaseUrl.length - 4);
      }
      debugPrint('baseUrl =====> $baseUrl');
      try {
        final resp = await http.get('$baseUrl.bin');
        if (resp.statusCode == 200) {
          final value = utf8.decode(base64Decode(resp.data));
          return ApiBinData.fromJson(jsonDecode(value) as Map<String, dynamic>);
        } else {
          return null;
        }
      } on DioException {
        return null;
      }
    }
  }

  Future<String?> _fastestHost(String hosts) async {
    final hostMap = jsonDecode(hosts);
    final apis = hostMap['api'];

    String? fastestBaseUrl;

    int failedTime = 0;
    for (final host in apis) {
      try {
        final response = await http.get(host);
        if (response.statusCode == 200) {
          if (null == fastestBaseUrl) {
            fastestBaseUrl = host;
            return host;
          }
        } else {
          failedTime++;
          if (failedTime == apis.length) {
            return null;
          }
        }
      } on DioException {
        failedTime++;
        if (failedTime == apis.length) {
          return null;
        }
      }
    }
    return null;
  }
}
