import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/models/mine/coupon_model.dart';
import 'package:flutter_video_community/data/repository/mine/mine_repository.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CouponController extends GetxController {
  final Rx<LoadState> loadState = Rx(LoadState.loading);
  final RefreshController refreshController = RefreshController();

  MineRepository get _repository => null == Get.context
      ? MineRepository()
      : RepositoryProvider.of<MineRepository>(Get.context!);

  int page = 1;
  bool hasNextPage = false;

  bool get isRefresh => page == 1;

  RxList<CouponModel> dataList = RxList();

  Future<void> load() async {
    _loadData();
  }

  Future<void> reload() async {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final list = await _repository.getCouponList();
      dataList.clear();
      dataList.addAll(list);
      if (dataList.isEmpty) {
        loadState.value = LoadState.empty;
      } else {
        loadState.value = LoadState.successful;
      }
    } catch (error) {
      refreshController.loadFailed();
    }
    update();
  }
}
