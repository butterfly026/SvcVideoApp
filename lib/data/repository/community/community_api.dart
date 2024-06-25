import 'package:flutter_video_community/utils/http/http.dart';
import 'package:flutter_video_community/utils/http/src/service.dart';

class CommunityApi {
  Future<HttpResponse> getSocAttendantList(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/soc/api/getSocAttendantList',
      data: dataMap,
    );
  }

  Future<HttpResponse> getSocAttendantInfo(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/soc/api/getSocAttendantInfo',
      data: dataMap,
    );
  }

  Future<HttpResponse> classifyList(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/content/api/getWorkClassifyList',
      data: dataMap,
    );
  }

  Future<HttpResponse> classifyCartoonList(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.get(
      '/content/api/getWorkList',
      data: dataMap,
    );
  }

  Future<HttpResponse> addSocAttendant(
    Map<String, dynamic> dataMap,
  ) async {
    return await httpService.post(
      '/soc/api/addSocAttendant',
      data: dataMap,
    );
  }

  Future<HttpResponse> getSocClassifyList() async {
    return await httpService.get(
      '/soc/api/getSocClassifyList',
    );
  }
}
