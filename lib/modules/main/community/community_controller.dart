import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/models/ip.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/data/repository/community/community_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController {
  // final RxList<TabModel> tabList = RxList([
  //   TabModel(name: '全国', id: '0', type: 'loufeng'),
  //   TabModel(name: '楼凤大厅', id: '1', type: 'loufeng'),
  //   TabModel(name: '认证外围', id: '2', type: 'waiwei'),
  //   TabModel(name: '伴游包养', id: '3', type: 'banyou'),
  // ]);

  Rx<AdsRsp?> adsRsp = Rx(null);

  /// 当前页面加载状态
  Rx<LoadState> loadState = Rx(LoadState.loading);

  RxList<TabModel> tabList = RxList();
  RxString cityName = RxString('全国');

  CommunityRepository get _repository => null == Get.context
      ? CommunityRepository()
      : RepositoryProvider.of<CommunityRepository>(Get.context!);

  @override
  void onReady() async {
    super.onReady();
    _loadTabList();
    adsRsp.value = await GlobalController.to.getAdsData();
    parseIpInfo();
  }

  void parseIpInfo() async {
    IpModel? ipModel = await GlobalController.to.getIpAddressInfo();
    debugPrint('parseIpInfo ipModel-> community entry- ${ ipModel.toString()}');

    if (ipModel != null && !AppTool.isEmpty(ipModel.city)) {
      cityName.value = ipModel.city;
    }

  }

  Future<void> _loadTabList() async {
    try {
      loadState.value = LoadState.loading;
      final dataList = await _repository.getSocClassifyList();
      tabList.clear();
      tabList.value = dataList;
      loadState.value = LoadState.successful;
    } catch (error) {
      loadState.value = LoadState.failed;
    }
    update();
  }

  void selectCity(BuildContext context) async {
    Result? result =  await AppUtil.selectCity(context);
    if (result != null && !AppTool.isEmpty(result.cityName )) {
      cityName.value = result.cityName!;
    }
  }

}
