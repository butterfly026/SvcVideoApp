
import 'dart:async';

import 'package:flutter_video_community/data/event/favor_del_event.dart';
import 'package:flutter_video_community/data/models/favor/favor_item.dart';
import 'package:flutter_video_community/data/repository/favor/favor_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:get/get.dart';

class FavorListController extends GetxController {

  int pageIndex = 1;
  int pageSize = 20;
  var dataList = <FavorItemModel>[].obs;
  FavorRepository get _repository => Global.getIt<FavorRepository>();
  String type = '';
  late final StreamSubscription favorDelSubscription;

  loadMore() async {
    int tmpPageIndex = pageIndex + 1;
    List<FavorItemModel> newItemList = await _repository.getFavorList(type, tmpPageIndex, pageSize);
    if (newItemList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex += 1;
      List<FavorItemModel> tmpList = <FavorItemModel>[];
      tmpList.addAll(dataList);
      tmpList.addAll(newItemList);
      dataList.value = tmpList;
      print("size=${newItemList.length}");
    }
  }

  @override
  void onInit() {
    super.onInit();
    favorDelSubscription = eventBus.on<FavorDelEvent>().listen((event) {
      loadData();
    });
  }

  @override
  void onClose() {
    favorDelSubscription.cancel();
    super.onClose();
  }

  void init() {
    pageIndex = 0;
    dataList.clear();
  }

  Future<List<FavorItemModel>?> loadData() async{

    // update();
    pageIndex = 0;
    dataList.value = await _repository.getFavorList(type, 1, pageSize);
    if (dataList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex = 1;
    }
    // update();
    return dataList;
  }

}