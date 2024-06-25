import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/data/models/video/classify_content_item.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/modules/main/comics/comics_page_controller.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ComicsClassifyListController extends GetxController {
  static ComicsClassifyListController to(String tag) => Get.find(tag: tag);

  late TabModel tabData;
  late RefreshController refreshController;

  int page = 1;
  bool hasNextPage = false;

  // final List<ClassifyContentModel> dataList = [];
  final Rx<LoadState> loadState = Rx(LoadState.loading);

  RxString announcement = RxString('有声漫画正式上线啦！至尊VIP六折起！');

  bool get isRefresh => page == 1;

  String get classifyId => tabData.id;

  AdsRsp? adsRsp;

  RxList<ClassifyContentItem> dataList = RxList();
  RxList<StairedGridTile> patternList = RxList();

  @override
  void onReady() {
    super.onReady();
    adsRsp = GlobalController.to.adsRsp.value;
  }

  Future<void> load(
    TabModel tabData,
    RefreshController refreshController, {
    bool first = false,
  }) async {
    this.tabData = tabData;
    this.refreshController = refreshController;

    page = 1;
    loadState.value = LoadState.loading;
    await _loadData();
  }

  Future<void> onRefresh() async {
    page = 1;
    await _loadData();
    refreshController.refreshCompleted(resetFooterState: true);
  }

  Future<void> onLoadMore() async {
    if (hasNextPage) {
      page += 1;
      await _loadData();
      refreshController.refreshCompleted();
    } else {
      refreshController.loadNoData();
    }
  }

  Future<void> _loadData() async {
    final dataMap = ComicsPageController.to.dataMap;
    final childrenDataMap = ComicsPageController.to.childrenDataMap;

    if (isRefresh) {
      dataList.clear();
      patternList.clear();

      final bannerList = adsRsp?.homeBannerList ?? [];

      if (bannerList.isNotEmpty) {
        dataList.add(ClassifyContentItem(banner: bannerList));
        patternList.add(const StairedGridTile(1.0, 2));
      }

      if (announcement.isNotEmpty) {
        dataList.add(
          ClassifyContentItem(announcement: announcement.value),
        );
        patternList.add(const StairedGridTile(1.0, 6));
      }
    }

    dataList.add(
      ClassifyContentItem(sectionData: tabData),
    );
    patternList.add(const StairedGridTile(1.0, 8));

    final tabDataList = dataMap[tabData.id] ?? [];
    if (tabDataList.isNotEmpty) {
      final value = tabDataList.length % 2 == 0;

      int index = 0;
      for (final item in tabDataList) {
        if (!value && index == tabDataList.length) {
          dataList.add(ClassifyContentItem(empty: true));
          patternList.add(const StairedGridTile(0.5, 0.65));
        }
        dataList.add(ClassifyContentItem(content: item));
        patternList.add(const StairedGridTile(0.5, 0.65));
        index++;
      }
    }

    final childrenDataList = childrenDataMap[tabData.id] ?? [];
    for (final item in childrenDataList) {
      dataList.add(
        ClassifyContentItem(sectionData: item),
      );
      patternList.add(const StairedGridTile(1.0, 8));

      final itemDataList = item.dataList;
      if (itemDataList.isNotEmpty) {
        final value = itemDataList.length % 2 == 0;

        int index = 0;
        for (final item in itemDataList) {
          if (!value && index == itemDataList.length) {
            dataList.add(ClassifyContentItem(empty: true));
            patternList.add(const StairedGridTile(0.5, 1.15));
          }

          dataList.add(ClassifyContentItem(content: item));
          patternList.add(const StairedGridTile(0.5, 1.15));
          index++;
        }
      }
    }

    if (isRefresh && dataList.isEmpty) {
      loadState.value = LoadState.empty;
    } else {
      loadState.value = LoadState.successful;
      if (hasNextPage) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    }

    update();
  }
}
