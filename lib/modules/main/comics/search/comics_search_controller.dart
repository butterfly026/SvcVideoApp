import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/models/search.dart';
import 'package:flutter_video_community/data/repository/content/work_repository.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ComicsSearchController extends GetxController {
  late RefreshController refreshController;

  int page = 1;
  bool hasNextPage = false;

  Rx<SearchModel> searchModel = Rx(SearchModel());

  final Rx<LoadState> loadState = Rx(LoadState.loading);
  final RxList<ClassifyContentModel> dataList = RxList();

  bool get isRefresh => page == 1;

  WorkRepository get _repository => Global.getIt<WorkRepository>();

  @override
  void onReady() {
    super.onReady();
    final arguments = Get.arguments;
    if (null != arguments && arguments is SearchModel) {
      searchModel.value = Get.arguments as SearchModel;
    }
  }

  Future<void> load(
    RefreshController refreshController,
  ) async {
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
    try {
      final dataMap = <String, dynamic>{
        'appId': searchModel.value.appId,
        'title': searchModel.value.keywords,
        'moduleType': searchModel.value.moduleType,
        'pageNum': page,
        'pageSize': 10,
      };
      final response = await _repository.searchWork(dataMap);

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
