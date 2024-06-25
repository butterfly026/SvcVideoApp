
import 'dart:async';

import 'package:flutter_video_community/data/event/favor_del_event.dart';
import 'package:flutter_video_community/data/models/favor/favor_item.dart';
import 'package:flutter_video_community/data/models/undress/undress_record.dart';
import 'package:flutter_video_community/data/repository/favor/favor_repository.dart';
import 'package:flutter_video_community/data/repository/main/main_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:get/get.dart';

class UndressRecordListLogic extends GetxController {

  int pageIndex = 1;
  int pageSize = 10;
  var dataList = <UndressRecordModel>[].obs;
  final MainRepository _mainRepo = Global.getIt<MainRepository>();

  int taskStatus = 1;

  loadMore() async {
    int tmpPageIndex = pageIndex + 1;
    List<UndressRecordModel> newItemList = await _mainRepo.undressHistory(taskStatus, tmpPageIndex, pageSize);
    if (newItemList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex += 1;
      List<UndressRecordModel> tmpList = <UndressRecordModel>[];
      tmpList.addAll(dataList);
      tmpList.addAll(newItemList);
      dataList.value = tmpList;
      print("size=${newItemList.length}");
    }
  }

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onClose() {
    super.onClose();
  }

  void init(int taskStatus) {
    this.taskStatus = taskStatus;
    pageIndex = 0;
    dataList.clear();
  }

  Future<List<UndressRecordModel>?> loadData() async {
    // update();
    pageIndex = 0;
    dataList.value = await _mainRepo.undressHistory(taskStatus, 1, pageSize);
    if (dataList.isNotEmpty) {
        //成功了才设置pageIndex
      pageIndex = 1;
    }
      // update();
    return dataList;
  }

}