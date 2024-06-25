
//收藏数据层
import 'package:flutter_video_community/data/models/favor/favor_cat.dart';
import 'package:flutter_video_community/data/models/favor/favor_item.dart';
import 'package:flutter_video_community/data/repository/favor/favor_api.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/cache_util.dart';

class FavorRepository {
  final FavorApi _api = FavorApi();

  Future<List<FavorCatModel>> getFavorCatList() async {
    final dataMap = <String, dynamic>{};
    final response = await _api.getFavorCatList(dataMap);
    final dataList = <FavorCatModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          FavorCatModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return dataList;
  }

  //通过type获取收藏列表
  Future<List<FavorItemModel>> getFavorList(String type, int pageNum, int pageSize) async {
    final response = await _api.getFavorList(type, pageNum, pageSize);
    final dataList = <FavorItemModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          FavorItemModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return dataList;
  }

  Future<void> favor(String contentId, String contentTitle, String contentImageUrl, String contentType) async {
    String? userId = CacheUtil.getUserInfoFromCache()?.userId;
    if (AppTool.isEmpty(userId)) {
      return;
    }
    final dataMap = <String, dynamic>{
      'userId': userId,
      'contentId': contentId,
      'contentTitle': contentTitle,
      'contentImageUrl': contentImageUrl,
      'contentType': contentType,
    };
    final response = await _api.favor(dataMap);
    final dataList = <FavorCatModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          FavorCatModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return;
  }

  Future<List<FavorCatModel>> cancelFavor(String contentIds) async {
    final dataMap = <String, dynamic>{
      'contentIds' : contentIds
    };
    final response = await _api.cancelFavor(dataMap);
    final dataList = <FavorCatModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          FavorCatModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return dataList;
  }


}