

import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/repository/content/work_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:get/get.dart';

class WorkListLogic extends GetxController {

  WorkRepository get _repository => Global.getIt<WorkRepository>();

  int pageIndex = 1;
  int pageSize = 20;
  var dataList = <ClassifyContentModel>[].obs;
  String catId = '';
  String type = '';

  RxString announcement = RxString('');
  RxList<AdsModel> adsList = RxList();

  void init(String catId, String type) {
    this.catId = catId;
    this.type = type;
    pageIndex = 0;
    dataList.clear();
    announcement.value = Cache.getInstance().appConfig?.rollAnnouncement ?? '';

    setAdList();
    loadData();
  }

  void setAdList() {
    final adsRsp = GlobalController.to.adsRsp.value;

    if (AppTool.isEmpty(type) || adsRsp == null) {
      return;
    }
    if (ContentEnum.novel.type == type) {
      adsList.value = adsRsp.novelFloatingBanner!;

    } else if (ContentEnum.comic.type == type) {
      adsList.value = adsRsp.cartoonFloatingBanner!;
    }
  }

  loadMore() async {
    int tmpPageIndex = pageIndex + 1;
    List<ClassifyContentModel> newItemList = await _repository.getWorkList(catId, tmpPageIndex, pageSize: pageSize);
    if (newItemList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex += 1;
      List<ClassifyContentModel> tmpList = <ClassifyContentModel>[];
      tmpList.addAll(dataList);
      tmpList.addAll(newItemList);
      dataList.value = tmpList;
      print("size=${newItemList.length}");
    }
  }

  Future<List<ClassifyContentModel>?> loadData() async{

    // update();
    pageIndex = 0;
    dataList.value = await _repository.getWorkList(catId, 1, pageSize: pageSize);
    if (dataList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex = 1;
    }
    // update();
    return dataList;
  }
}