import 'dart:io';

import 'package:flutter_video_community/data/event/purchase_occurred_event.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/page_data.dart';
import 'package:flutter_video_community/data/models/undress/undress_record.dart';
import 'package:flutter_video_community/data/models/upload.dart';
import 'package:flutter_video_community/data/repository/main/main_api.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/utils/cache_util.dart';
import 'package:flutter_video_community/widgets/bottom_navigation_bar/bottom_tab_model.dart';

class MainRepository {
  final MainApi _api = MainApi();

  Future<List<BottomTabModel>> appMenu() async {
    final response = await _api.appMenu();
    final menuList = <BottomTabModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        menuList.add(
          BottomTabModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return menuList;
  }

  Future<UploadModel> uploadImage(
    File file,
  ) async {
    final response = await _api.uploadImage(file);
    return UploadModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> undress(
    Map<String, dynamic> dataMap,
  ) async {
    await _api.undress(dataMap);
  }

  Future<List<UndressRecordModel>> undressHistory(
    int status, int page, int pageSize,
  ) async {
    final dataMap = <String, dynamic>{
      'taskStatus': status,
      'pageNum': page,
      'pageSize': pageSize,
    };
    final response = await _api.undressHistory(dataMap);
    final dataList = <UndressRecordModel>[];
    if (response.data is List) {
      for (final item in response.data) {
        dataList.add(
          UndressRecordModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return dataList;
  }

  Future<void> buy(
    Map<String, dynamic> dataMap,
  ) async {
    await _api.buy(dataMap);
    CacheUtil.setNeedUpdateUserInfo(true);
    eventBus.fire(PurchaseOccurredEvent());
  }
}
