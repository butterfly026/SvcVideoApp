import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/data/repository/content/work_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:get/get.dart';

class TvSeriesController extends GetxController {
  static TvSeriesController get to => Get.find();

  final TextEditingController editingController = TextEditingController();

  /// 当前页面加载状态
  Rx<LoadState> loadState = Rx(LoadState.loading);

  RxList<TabModel> tabDataList = RxList();

  TabController? tabController;

  final Map<String, List<ClassifyContentModel>> dataMap =
      <String, List<ClassifyContentModel>>{};
  final Map<String, List<TabModel>> childrenDataMap =
      <String, List<TabModel>>{};

  WorkRepository get _repository => Global.getIt<WorkRepository>();

  Rx<AdsRsp?> adsRsp = Rx(null);

  @override
  void onReady() async {
    super.onReady();
    _loadTabList();
    adsRsp.value = await GlobalController.to.getAdsData();
  }

  void initTabController(
    TabController tabController,
  ) {
    this.tabController = tabController;
  }

  @override
  void onClose() {
    editingController.dispose();
    super.onClose();
  }

  Future<void> hideKeyboard(
    BuildContext context,
  ) async {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> reload() async {
    loadState.value = LoadState.loading;
    update();
    await _loadTabList();
  }

  Future<void> _loadTabList() async {
    try {
      loadState.value = LoadState.loading;
      final dataList = await _repository.classifyList(
        moduleType: ContentEnum.tv.type,
      );

      tabDataList.clear();

      for (final tabData in dataList) {
        dataMap[tabData.id] = tabData.dataList;
        childrenDataMap[tabData.id] = tabData.childrenList;
      }

      tabDataList.value = dataList;
      loadState.value = LoadState.successful;
    } catch (error) {
      loadState.value = LoadState.failed;
    }
    update();
  }
}
