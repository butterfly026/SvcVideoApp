import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/models/live/live_cat.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/repository/live/live_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:get/get.dart';

class LiveController extends GetxController {

  RxList<AdsModel> adsList = RxList();
  RxString announcement = RxString('');

  List<String> get bannerList => adsList.map((e) => e.pic).toList();

  RxList<LiveCatModel> tabList = RxList();

  RxInt currentIndex = RxInt(0);

  LiveRepository get _repository => Global.getIt<LiveRepository>();

  Rx<AdsRsp?> adsRsp = Rx(null);

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onReady() async {
    super.onReady();
    _loadTabList();
    adsRsp.value = await GlobalController.to.getAdsData();
  }


  Future<void> reload() async {
    update();
    await _loadTabList();
  }

  Future<void> _loadTabList() async {

    List<LiveCatModel> tmpFavorCatList  = await _repository.getLiveCatList();
    if (tmpFavorCatList.isNotEmpty) {
      tabList.value = tmpFavorCatList;
    }
  }
}
