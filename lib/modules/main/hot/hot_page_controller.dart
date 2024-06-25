import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:get/get.dart';

class HotPageController extends GetxController {
  RxString announcement = RxString('');

  RxList<AdsModel> hotBannerList = RxList();
  RxList<AdsModel> hotAppList = RxList();
  RxList<AdsModel> hotRecommendApps = RxList();

  Rx<AdsRsp?> adsRsp = Rx(null);

  @override
  void onReady() async {
    super.onReady();
    adsRsp.value = await GlobalController.to.getAdsData();
    hotBannerList.value = adsRsp.value?.hotBannerList ?? [];
    hotAppList.value = adsRsp.value?.hotApps ?? [];
    hotRecommendApps.value = adsRsp.value?.hotRecommendApps ?? [];

    announcement.value = Cache.getInstance().appConfig?.rollAnnouncement ?? '';
  }
}
