import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/data/models/community/community.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/models/page_data.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/data/repository/community/community_api.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/cache.dart';

class CommunityRepository {
  final CommunityApi _api = CommunityApi();

  Future<PageData<CommunityModel>> getSocAttendantList(
    String type,
    String areaCode, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final dataMap = <String, dynamic>{
      'type': type,
      'areaCode': areaCode,
      'pageNum': page,
      'pageSize': pageSize,
    };
    if (!AppTool.isEmpty(AppConfig.cityId)) {
      dataMap['areaCode'] = AppConfig.cityId;
    }
    final pageData = PageData<CommunityModel>(
      list: [],
    );
    final response = await _api.getSocAttendantList(dataMap);
    pageData.success = response.success;
    final dataList = <CommunityModel>[];
    if (response.list is List) {
      for (final item in response.list) {
        dataList.add(
          CommunityModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    pageData.list = dataList;
    return pageData;
  }

  Future<CommunityModel> getSocAttendantInfo(
    String id,
  ) async {
    final dataMap = <String, dynamic>{
      'id': id,
    };
    final response = await _api.getSocAttendantInfo(dataMap);
    final data = CommunityModel.fromJson(
      response.data as Map<String, dynamic>,
    );
    return data;
  }

  Future<List<TabModel>> classifyList({
    String moduleType = 'tv',
  }) async {
    final appId = Cache.getInstance().mainApp?.id;
    final dataMap = <String, dynamic>{
      'moduleType': moduleType,
      'appId': appId,
    };
    final response = await _api.classifyList(dataMap);
    final dataList = <TabModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          TabModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return dataList;
  }

  Future<PageData<ClassifyContentModel>> classifyVideoList(
    String classifyId, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final dataMap = <String, dynamic>{
      'classifyId': classifyId,
      'pageNum': page,
      'pageSize': pageSize,
    };
    final pageData = PageData<ClassifyContentModel>(
      list: [],
    );
    final response = await _api.classifyCartoonList(dataMap);
    pageData.success = response.success;
    final dataList = <ClassifyContentModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          ClassifyContentModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    pageData.list = dataList;
    return pageData;
  }

  Future<void> addSocAttendant(
    Map<String, dynamic> dataMap,
  ) async {
    final response = await _api.addSocAttendant(dataMap);
  }

  Future<List<TabModel>> getSocClassifyList() async {
    final response = await _api.getSocClassifyList();
    final dataList = <TabModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          TabModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return dataList;
  }
}
