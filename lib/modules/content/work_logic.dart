
import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/data/repository/content/work_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:get/get.dart';

class WorkLogic extends GetxController {

  WorkRepository get _workRepo => Global.getIt<WorkRepository>();

  Rx<AdsRsp?> adsRsp = Rx(null);
  Rx<AdsModel?> floatingAd = Rx(null);
  RxList<TabModel> tabList = RxList();
  String? type;
  @override
  void onReady() async {
    super.onReady();

  }

  void init(String? type) async {
    this.type = type;
    _loadTabList();
    adsRsp.value = await GlobalController.to.getAdsData();
    setFloatingAd();
  }
  //必须先设置type
  void  setFloatingAd() {
    if (adsRsp.value == null || AppTool.isEmpty(type)) {
      return;
    }
    if (ContentEnum.novel.type == type) {
      floatingAd.value = adsRsp.value!.novelFloatingBannerValue;
    } else if (ContentEnum.comic.type == type) {
      floatingAd.value = adsRsp.value!.cartoonFloatingBannerValue;
    }
  }


  Future<void> reload() async {
    update();
    await _loadTabList();
  }

  Future<void> _loadTabList() async {
    if (AppTool.isEmpty(type)) {
      tabList.value = List.empty();
      return;
    }
    List<TabModel> tmpWorkCatList  = await _workRepo.classifyList(
      moduleType: type!,
    );
    if (tmpWorkCatList.isNotEmpty) {
      tabList.value = tmpWorkCatList;
    }
  }
}