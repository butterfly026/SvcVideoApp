
import 'package:flutter_video_community/data/models/live/live_anchor.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/repository/live/live_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:get/get.dart';

class LiveListController extends GetxController {

  int pageIndex = 1;
  int pageSize = 20;
  var dataList = <LiveAnchorModel>[].obs;
  LiveRepository get _repository => Global.getIt<LiveRepository>();
  String catId = '';
  RxString announcement = RxString('');
  RxList<AdsModel> adsList = RxList();

  void init(String catId) {
    this.catId = catId;
    pageIndex = 0;
    dataList.clear();
    announcement.value = Cache.getInstance().appConfig?.rollAnnouncement ?? '';

    final adsRsp = GlobalController.to.adsRsp.value;
    adsList.value = adsRsp?.videoLiveBannerList ?? [];
    loadData();
  }

  loadMore() async {
    int tmpPageIndex = pageIndex + 1;
    List<LiveAnchorModel> newItemList = await _repository.getLiveAnchorList(catId, tmpPageIndex, pageSize);
    if (newItemList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex += 1;
      List<LiveAnchorModel> tmpList = <LiveAnchorModel>[];
      tmpList.addAll(dataList);
      tmpList.addAll(newItemList);
      dataList.value = tmpList;
      print("size=${newItemList.length}");
    }
  }

  Future<List<LiveAnchorModel>?> loadData() async{

    // update();
    pageIndex = 0;
    dataList.value = await _repository.getLiveAnchorList(catId, 1, pageSize);
    if (dataList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex = 1;
    }
    // update();
    return dataList;
  }

}