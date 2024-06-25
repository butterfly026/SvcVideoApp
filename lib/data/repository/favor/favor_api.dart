

import 'package:flutter_video_community/utils/http/http.dart';
import 'package:flutter_video_community/utils/http/src/service.dart';

class FavorApi {


  Future<HttpResponse> getFavorCatList(
      Map<String, dynamic> dataMap,
      ) async {
    return await httpService.get(
      '/app/api/getCollectClassify',
      data: dataMap,
    );
  }


  Future<HttpResponse> getFavorList(
      String type, int pageNum, int pageSize) async {
    return await httpService.get(
      '/app/api/getCollectList',
      data: <String, dynamic>{
        'contentType': type,
        'pageNum': pageNum,
        'pageSize': pageSize
      },
    );
  }


  Future<HttpResponse> favor(
      Map<String, dynamic> dataMap,
      ) async {
    return await httpService.post(
      '/app/api/addCollect',
      data: dataMap,
    );
  }

  Future<HttpResponse> cancelFavor(
      Map<String, dynamic> dataMap,
      ) async {
    return await httpService.delete(
      '/app/api/deleteCollect',
      data: {},
      queryParameters: dataMap
    );
  }

}