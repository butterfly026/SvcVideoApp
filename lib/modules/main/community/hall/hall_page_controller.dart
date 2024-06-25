import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/models/community/community.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/data/repository/community/community_repository.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HallPageController extends GetxController {
  int page = 1;
  bool hasNextPage = false;

  late TabModel tabData;

  final List<CommunityModel> dataList = [];
  final Rx<LoadState> loadState = Rx(LoadState.successful);

  bool get isRefresh => page == 1;

  RefreshController refreshController = RefreshController();

  CommunityRepository get _repository => null == Get.context
      ? CommunityRepository()
      : RepositoryProvider.of<CommunityRepository>(Get.context!);

  @override
  void onReady() {
    super.onReady();
    // load();
  }

  Future<void> load(
    TabModel tabData,
  ) async {
    this.tabData = tabData;
    page = 1;
    loadState.value = LoadState.loading;
    update();
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
    try {
      final response = await _repository.getSocAttendantList(
        tabData.type,
        '',
        page: page,
      );
      if (response.success) {
        final list = response.list;
        if (isRefresh) {
          dataList.clear();
        }

        dataList.addAll(list);
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
    update();
  }
}
