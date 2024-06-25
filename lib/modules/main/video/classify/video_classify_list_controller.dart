import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/data/models/video/classify_content_item.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/modules/main/home/home_page_controller.dart';
import 'package:flutter_video_community/modules/main/video/app/video_app_controller.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class VideoClassifyListController extends GetxController {
  static VideoClassifyListController to(String tag) => Get.find(tag: tag);

  VideoClassifyListController({
    this.adsModel,
  });

  AdsModel? adsModel;

  bool first = false;
  late TabModel tabData;
  late RefreshController refreshController;

  int page = 1;
  bool hasNextPage = false;

  // final List<ClassifyContentModel> dataList = [];
  final Rx<LoadState> loadState = Rx(LoadState.loading);

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
    this.first = first;
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
    Map<String, List<ClassifyContentModel>> dataMap;
    Map<String, List<TabModel>> childrenDataMap;
    if (null == adsModel) {
      dataMap = HomePageController.to.dataMap;
      childrenDataMap = HomePageController.to.childrenDataMap;
    } else {
      dataMap = VideoAppController.to.dataMap;
      childrenDataMap = VideoAppController.to.childrenDataMap;
    }

    if (isRefresh) {
      dataList.clear();
      patternList.clear();

      final bannerList = adsRsp?.homeBannerList ?? [];

      if (bannerList.isNotEmpty) {
        dataList.add(ClassifyContentItem(banner: bannerList));
        patternList.add(const StairedGridTile(1.0, 2));
      }

      if (first) {
        final newUserEquityTime =
            Cache.getInstance().login?.newUserEquityTime ?? 0;
        if (newUserEquityTime > 0) {
          dataList.add(
            ClassifyContentItem(
              equityBanner: true,
              newUserEquityTime: newUserEquityTime,
            ),
          );
          patternList.add(const StairedGridTile(1.0, 4.5));
        }
      }

      final miniBanner = adsRsp?.homeVideoBannerList ?? [];
      if (miniBanner.isNotEmpty) {
        final newUserEquityTime = GlobalController.to.newUserEquityTime.value;

        dataList.add(
          ClassifyContentItem(
            miniBanner: miniBanner,
            newUserEquityTime: newUserEquityTime,
          ),
        );
        patternList.add(const StairedGridTile(1.0, 3.5));
      }
    }

    dataList.add(
      ClassifyContentItem(sectionData: tabData),
    );
    patternList.add(const StairedGridTile(1.0, 8));

    if (null == adsModel || adsModel?.gridView == true) {
      final tabDataList = dataMap[tabData.id] ?? [];
      if (tabDataList.isNotEmpty) {
        final contentHorizontal = tabDataList.first;
        dataList.add(
          ClassifyContentItem(
            contentHorizontal: contentHorizontal,
          ),
        );
        patternList.add(const StairedGridTile(1.0, 1.5));

        final value = tabDataList.sublist(1).length % 2 == 0;

        int index = 0;
        for (final item in tabDataList.sublist(1)) {
          if (!value && index == tabDataList.sublist(1).length) {
            dataList.add(ClassifyContentItem(empty: true));
            patternList.add(const StairedGridTile(0.5, 0.65));
          }
          dataList.add(ClassifyContentItem(content: item));
          patternList.add(const StairedGridTile(0.5, 1.15));
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
          final contentHorizontal = itemDataList.first;
          dataList.add(
            ClassifyContentItem(
              contentHorizontal: contentHorizontal,
            ),
          );
          patternList.add(const StairedGridTile(1.0, 1.5));

          final value = itemDataList.sublist(1).length % 2 == 0;

          int index = 0;
          for (final item in itemDataList.sublist(1)) {
            if (!value && index == itemDataList.sublist(1).length) {
              dataList.add(ClassifyContentItem(empty: true));
              patternList.add(const StairedGridTile(0.5, 0.65));
            }

            dataList.add(ClassifyContentItem(content: item));
            patternList.add(const StairedGridTile(0.5, 1.15));
            index++;
          }
        }
      }
    } else {
      final tabDataList = dataMap[tabData.id] ?? [];
      for (final item in tabDataList) {
        dataList.add(
          ClassifyContentItem(
            contentHorizontal: item,
          ),
        );
        patternList.add(const StairedGridTile(1.0, 1.5));
      }

      final childrenDataList = childrenDataMap[tabData.id] ?? [];
      for (final item in childrenDataList) {
        dataList.add(
          ClassifyContentItem(sectionData: item),
        );
        patternList.add(const StairedGridTile(1.0, 8));

        final itemDataList = item.dataList;
        for (final item in itemDataList) {
          dataList.add(
            ClassifyContentItem(
              contentHorizontal: item,
            ),
          );
          patternList.add(const StairedGridTile(1.0, 1.5));
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

/*    try {
      final response = await _repository.classifyVideoList(
        tabData.id,
        page: page,
      );

      // final List<VideoItem> videoItems = [];
      // final List<StairedGridTile> patternList = [];

      if (response.success) {
        final list = response.list;
        if (isRefresh) {
          dataList.clear();
          patternList.clear();

          final bannerList = adsRsp?.homeBannerList ?? [];

          if (bannerList.isNotEmpty) {
            dataList.add(ClassifyContentItem(banner: bannerList));
            patternList.add(const StairedGridTile(1.0, 2));
          }

          if (first) {
            final newUserEquityTime =
                Cache.getInstance().login?.newUserEquityTime ?? 0;
            if (newUserEquityTime > 0) {
              dataList.add(
                ClassifyContentItem(
                  equityBanner: true,
                  newUserEquityTime: newUserEquityTime,
                ),
              );
              patternList.add(const StairedGridTile(1.0, 4.5));
            }
          }

          final miniBanner = adsRsp?.homeVideoBannerList ?? [];
          if (miniBanner.isNotEmpty) {
            final newUserEquityTime =
                Cache.getInstance().login?.newUserEquityTime ?? 0;

            dataList.add(
              ClassifyContentItem(
                miniBanner: miniBanner,
                newUserEquityTime: newUserEquityTime,
              ),
            );
            patternList.add(const StairedGridTile(1.0, 3.5));
          }
        }

        for (final item in list) {
          dataList.add(ClassifyContentItem(content: item));
          patternList.add(const StairedGridTile(0.5, 1.15));
        }

        // dataList.addAll(list);
        hasNextPage = list.length >= 10;

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
      } else {
        if (isRefresh) {
          refreshController.refreshFailed();
          if (dataList.isEmpty) {
            loadState.value = LoadState.failed;
          }
        } else {
          page -= 1;
          refreshController.loadFailed();
        }
      }
    } catch (error) {
      if (isRefresh) {
        refreshController.refreshFailed();
        if (dataList.isEmpty) {
          loadState.value = LoadState.failed;
        }
      } else {
        page -= 1;
        refreshController.loadFailed();
      }
    }
    update();*/
  }
}
