import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/models/game/game.dart';
import 'package:flutter_video_community/data/repository/game/game_repository.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:get/get.dart';

class GameActivityController extends GetxController {
  final List<GameActivityModel> dataList = [];
  final Rx<LoadState> loadState = Rx(LoadState.loading);

  GameRepository get _repository => null == Get.context
      ? GameRepository()
      : RepositoryProvider.of<GameRepository>(Get.context!);

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final list = await _repository.gameActivityList();

      dataList.clear();
      dataList.addAll(list);

      if (dataList.isEmpty) {
        loadState.value = LoadState.empty;
      } else {
        loadState.value = LoadState.successful;
      }
    } catch (error) {
      loadState.value = LoadState.failed;
    }
    update();
  }
}
