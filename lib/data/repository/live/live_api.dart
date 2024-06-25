import 'package:flutter_video_community/utils/http/http.dart';
import 'package:flutter_video_community/utils/http/src/service.dart';

class LiveApi {


  /// 获取直播分类
  Future<HttpResponse> liveCatList() async {
    return await httpService.get(
      '/live/api/getClassifyList',
    );
  }


  //获取主播列表
  Future<HttpResponse> liveAnchorList(
      String catId, int pageNum, int pageSize,
  ) async {
    return await httpService.get(
      '/live/api/getAnchorList',
      data: <String, dynamic>{
        'classifyId': catId,
        'pageNum': pageNum,
        'pageSize': pageSize
      },
    );
  }

}
