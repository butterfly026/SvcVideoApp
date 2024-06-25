import 'package:flutter_video_community/utils/http/http.dart';
import 'package:flutter_video_community/utils/http/src/service.dart';

class WorkApi {
  Future<HttpResponse> getWorkCatList(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/content/api/getWorkClassifyList',
      data: dataMap,
    );
  }

  /// 获取直播分类
  Future<HttpResponse> liveClassifyList() async {
    return await httpService.get(
      '/live/api/getClassifyList',
    );
  }

  //根据分类id获取作品列表
  Future<HttpResponse> getWorkList(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/content/api/getWorkList',
      data: dataMap,
    );
  }

  Future<HttpResponse> classifyLiveList(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/live/api/getAnchorList',
      data: dataMap,
    );
  }

  Future<HttpResponse> getRecommendWorkList(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/content/api/getRecommend',
      data: dataMap,
    );
  }

  Future<HttpResponse> getWorkInfo(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/content/api/getWorkInfo',
      data: dataMap,
    );
  }

  Future<HttpResponse> getChapterInfo(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/content/api/getChapterInfo',
      data: dataMap,
    );
  }

  Future<HttpResponse> searchWork(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/content/api/search',
      data: dataMap,
    );
  }
}
