import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/models/game/game.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/repository/game/game_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class GamePageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static GamePageController get to => Get.find();

  Rx<LoadState> loadState = Rx(LoadState.loading);

  RxList<AdsModel> adsList = RxList();
  RxString announcement = RxString('');
  RxString gameBalance = RxString('0.0');

  Rx<GameModel?> gameInfo = Rx(null);
  Rx<UserModel?> userInfo = Rx(null);

  final Rx<GameClassify?> currentGameClassify = Rx(null);
  final RxList<GameClassify> gameClassifyList = RxList();
  final RxMap<String, List<GameClassifyItem>> dataMap = RxMap();

  List<String> get bannerList => adsList.map((e) => e.pic).toList();

  GameRepository get _repository => Global.getIt<GameRepository>();

  late Animation<double> animation;
  late AnimationController animationController;

  Rx<AdsRsp?> adsRsp = Rx(null);

  @override
  void onInit() {
    super.onInit();
    announcement.value = Cache.getInstance().appConfig?.rollAnnouncement ?? '';
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      animationController,
    );
  }

  @override
  void onReady() async {
    super.onReady();
    userInfo.value = Cache.getInstance().userInfo;

    loadData();

    adsRsp.value = await GlobalController.to.getAdsData();
    adsList.value = adsRsp.value?.gameBannerList ?? [];
    update();
  }

  Future<void> switchGameMenu(
    GameClassify gameClassify,
  ) async {
    currentGameClassify.value = gameClassify;
    update();
  }

  void loadData() async{
    await loadGameInfo();
    getGameBalance();
  }


  Future<void> loadGameInfo() async {
    try {
      final gameInfo = await _repository.gameInfo();

      /// 公告
      announcement.value = gameInfo.announcement;

      final dataList = gameInfo.gameClassifyVos ?? [];
      gameClassifyList.value = dataList;

      for (final gameClassify in dataList) {
        dataMap[gameClassify.id] = gameClassify.items ?? [];
      }

      /// 默认选中第一个
      if (dataList.isNotEmpty) {
        currentGameClassify.value = dataList.first;
      }

      this.gameInfo.value = gameInfo;
      loadState.value = LoadState.successful;
    } catch (error) {
      /// void
      loadState.value = LoadState.failed;
    }

    update();
  }

  Future<void> getGameBalance() async {
    try {
      final balance = await _repository.gameBalance();
      gameBalance.value = balance;
    } catch (error) {
      /// void
    }
  }

  Future<void> refreshGameBalance() async {
    animationController.repeat();
    try {
      final balance = await _repository.gameBalance();
      gameBalance.value = balance;
      animationController.stop();
    } catch (error) {
      animationController.stop();
    }
  }

  Future<void> copy() async {
    if (null != userInfo.value) {
      await Clipboard.setData(
        ClipboardData(
          text: userInfo.value?.nickName ?? '',
        ),
      );
      showToast('已复制');
    }
  }
}
