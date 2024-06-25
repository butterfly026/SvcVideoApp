import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/models/page_data.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/data/models/video/video_search_result.dart';
import 'package:flutter_video_community/data/repository/content/work_api.dart';
import 'package:flutter_video_community/utils/cache.dart';

class WorkRepository {
  final WorkApi _api = WorkApi();

  Future<List<TabModel>> classifyList({
    String? appId,
    String moduleType = 'video',
  }) async {
    final appIdValue = appId ?? Cache.getInstance().mainApp?.id;
    final dataMap = <String, dynamic>{
      'moduleType': moduleType,
      'appId': appIdValue,
    };
    final response = await _api.getWorkCatList(dataMap);
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

  Future<List<TabModel>> liveClassifyList() async {
    final response = await _api.liveClassifyList();
    final dataList = <TabModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          TabModel.fromJson(
            item as Map<String, dynamic>,
            live: true,
          ),
        );
      }
    }
    return dataList;
  }


  //根据分类id获取作品列表
  Future<List<ClassifyContentModel>> getWorkList(
    String classifyId, int pageIndex, {
    int pageSize = 10,
  }) async {
    final dataMap = <String, dynamic>{
      'classifyId': classifyId,
      'pageNum': pageIndex,
      'pageSize': pageSize,
    };

    final response = await _api.getWorkList(dataMap);
    List<ClassifyContentModel> workList = [];
    final jsonList = response.data as List;
    for (final item in jsonList) {
      workList.add(
        ClassifyContentModel.fromJson(item as Map<String, dynamic>),
      );
    }
    return workList;
  }

  //根据分类获取作品搜索结果
  Future<List<ClassifyContentModel>> getWorkSearchList(String type,
      String keyword, int pageIndex, int pageSize) async {
    String? appId = Cache.getInstance().mainApp?.id;
    final dataMap = <String, dynamic>{
      'appId': appId,
      'title': keyword,
      'moduleType': type,
      'pageNum': pageIndex,
      'pageSize': pageSize,
    };

    final response = await _api.searchWork(dataMap);
    List<ClassifyContentModel> workList = [];
    final jsonList = response.data as List;
    for (final item in jsonList) {
      workList.add(
        ClassifyContentModel.fromJson(item as Map<String, dynamic>),
      );
    }
    return workList;
  }

  Future<PageData<ClassifyContentModel>> classifyLiveList(
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
    final response = await _api.classifyLiveList(dataMap);
    pageData.success = response.success;
    final dataList = <ClassifyContentModel>[];
    if (response.list is List) {
      for (final item in response.list) {
        dataList.add(
          ClassifyContentModel.fromJson(
            item as Map<String, dynamic>,
            live: true,
          ),
        );
      }
    }
    pageData.list = dataList;
    return pageData;
  }

  Future<List<ClassifyContentModel>> getRecommendWorkList(
    Map<String, dynamic> dataMap,
  ) async {
    final response = await _api.getRecommendWorkList(dataMap);
    final dataList = <ClassifyContentModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          ClassifyContentModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return dataList;
  }

  Future<ClassifyContentModel?> getWorkInfo(
    Map<String, dynamic> dataMap,
  ) async {
    final response = await _api.getWorkInfo(dataMap);
    if (response.data != null) {
      final data = ClassifyContentModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    }
    return null;
  }

  Future<ChapterModel?> getChapterInfo(
    String chapterId,
  ) async {
    final response = await _api.getChapterInfo(
      <String, dynamic>{
        'chapterId': chapterId,
      },
    );
    if (response.success && null != response.data) {
      final data = ChapterModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    }
    return null;
  }

  Future<PageData<ClassifyContentModel>> searchWork(
    Map<String, dynamic> dataMap,
  ) async {
    final response = await _api.searchWork(dataMap);

    final pageData = PageData<ClassifyContentModel>(
      list: [],
    );

    if (response.success) {
      pageData.success = true;
      final VideoSearchResult videoSearchResult = VideoSearchResult.fromJson(
        response.data as Map<String, dynamic>,
      );
      if (videoSearchResult.success) {
        pageData.list = videoSearchResult.list ?? [];
      } else {
        pageData.success = false;
      }
    } else {
      pageData.success = false;
    }

    return pageData;
  }
}
