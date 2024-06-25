import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_video_community/utils/http/http.dart';
import 'package:flutter_video_community/utils/http/src/service.dart';

class MainApi {
  /// 获取APP菜单
  Future<HttpResponse> appMenu() async {
    return await httpService.get(
      '/app/api/getAppMemu',
    );
  }


  Future<HttpResponse> uploadImage(File file) async {
    final name = file.path.substring(
      file.path.lastIndexOf("/") + 1,
      file.path.length,
    );
    final multipartFile = await MultipartFile.fromFile(
      file.path,
      filename: name,
    );

    FormData formData = FormData.fromMap({
      'file': multipartFile,
    });
    return await httpService.post(
      '/resource/oss/api/upload',
      data: formData,
    );
  }

  Future<HttpResponse> undress(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.post(
      '/ai/api/createUndress',
      data: dataMap,
    );
  }

  Future<HttpResponse> undressHistory(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/ai/api/getUndressRecord',
      data: dataMap,
    );
  }

  Future<HttpResponse> buy(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.post(
      '/system/api/consumCoins',
      data: dataMap,
    );
  }
}
