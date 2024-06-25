import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floating/floating/assist/floating_slide_type.dart';
import 'package:flutter_floating/floating/floating.dart';
import 'package:flutter_floating/floating/manager/floating_manager.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/event/main_page_visibility_event.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/data/repository/main/main_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:flutter_video_community/modules/main/widgets/announcement_dialog.dart';
import 'package:flutter_video_community/modules/main/widgets/open_vip_dialog.dart';
import 'package:flutter_video_community/modules/main/widgets/tip_dialog.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/widgets/bottom_navigation_bar/bottom_tab_model.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import 'widgets/unlock_menu_dialog.dart';

class MainController extends GetxController {
  static MainController get to => Get.find();

  /// 当前页面加载状态
  Rx<LoadState> loadState = Rx(LoadState.loading);

  Rx<AppConfigModel?> appConfigInfo = Rx(null);

  RxInt currentIndex = RxInt(0);
  RxList<BottomTabModel> bottomTabDataList = RxList();

  DateTime? lastPopTime;

  BuildContext? get context => Get.context;

  MainRepository get _repository => Global.getIt<MainRepository>();

  AdsRsp? adsRsp;

  final Map<String, Floating> floatingMap = <String, Floating>{};

  var userCoins = 0.obs;

  final tagList = [
    'mine',
    'home',
    'hot',
    'game',
    'live',
    'cartoon',
    'novel',
    'community',
    'crack',
    'aiUndress',
  ];

  @override
  void onReady() {
    super.onReady();
    adsRsp = GlobalController.to.adsRsp.value;
    // showFloatingButton();
    refreshUserInfo();
    _loadTabList();
    _showAnnouncementDialog();
    _showUnlockMenu();
  }

  void _showUnlockMenu() {
    if (bottomTabDataList.isEmpty) {
      return;
    }
    BottomTabModel bottomTabModel = bottomTabDataList.first;
    showUnlockMenuDialog(
      bottomTabModel,
      0,
      callback: () async {
        bottomTabModel.auth = true;
        update();

        // _controller.didPopNext();
        // _preIndex = index;
      },
    );
  }

  Future<void> refreshUserInfo() async {
    IndexRepository repository = Global.getIt<IndexRepository>();
    UserModel? user = await repository.userInfo();
    if (user != null) {
      userCoins.value = user.coins.toInt();
    }
    refresh();
  }

  Future<void> reload() async {
    await _loadTabList();
  }

  Future<void> _loadTabList() async {
    try {
      loadState.value = LoadState.loading;
      update();

      final dataList = await _repository.appMenu();
      // dataList.add(BottomTabModel(content: 'app://cartoon', name: '动漫', openType: '1'));
      // dataList.add(BottomTabModel(content: 'app://novel', name: '小说', openType: '1'));

      bottomTabDataList.value = dataList;
      loadState.value = LoadState.successful;

      // didPopNext();
    } catch (error) {
      loadState.value = LoadState.failed;
    }
    update();
  }

  Future<void> _showAnnouncementDialog() async {
    appConfigInfo.value = Cache.getInstance().appConfig;
    final appConfig = appConfigInfo.value;
    if (null == appConfig) {
      return;
    }
    if (appConfig.needShowAc && null != context) {
      AnnouncementDialog.show(
        context!,
        content: appConfig.announcement,
        onDismiss: () {
          _showNewUserActivityDialog();
        },
      );
    }
  }

  /// 判断是否展示新用户活动弹窗
  Future<void> _showNewUserActivityDialog() async {
    final newUserEquityTime = Cache.getInstance().login?.newUserEquityTime ?? 0;
    if (newUserEquityTime > 0) {
      OpenVipDialog.show(context!);
    }
  }

  Future<void> showUnlockMenuDialog(
    BottomTabModel tabData,
    int index, {
    Function()? callback,
  }) async {
    if (null != context) {
      IndexRepository indexRepository = Global.getIt<IndexRepository>();
      UserModel? userInfo = await indexRepository.userInfo();
      num userCoins = userInfo?.coins ?? 0;
      num coinsTobeConsumed = tabData.unlockPrice;
      if (userCoins >= coinsTobeConsumed) {
        final dataMap = <String, dynamic>{
          'coins': coinsTobeConsumed,
          'busType': 'appMemu',
          'busId': tabData.id,
          'busName': '解锁${tabData.name}菜单',
        };
        TipDialog.show(Get.context!,
            title: "当前需消费${coinsTobeConsumed}金币",
            btnTitle: "立即解锁", onOkBtn: () async {
          await _repository.buy(dataMap);
          // await reload();
          LoadingDialog.dismiss();
          if (null != callback) {
            callback();
          }
          showToast('解锁成功');
        });
      } else {
        //用户金币数小于解锁金币数时，弹窗提示，用户点击立即充值后去金币充值页面
        TipDialog.show(Get.context!,
            title: "余额不足, 当前需消费${coinsTobeConsumed}金币",
            btnTitle: "立即充值", onOkBtn: () {
          Get.toNamed(AppRouter.coinRecharge);
        });
      }

      // UnlockMenuDialog.show(
      //   context!,
      //   tabData,
      //   onMenuUnlock: () async {
      //     for (var element in bottomTabDataList) {
      //       if (element.name == tabData.name) {
      //         // element.lock = false;
      //         // if (null != callback) {
      //         //   callback();
      //         // }
      //
      //         //AppUtil.consumeCoin(coinsTobeConsumed, type, bizId, bizTitle);
      //         await unlockMenu(
      //           tabData,
      //           callback: callback,
      //         );
      //       }
      //     }
      //   },
      // );
    }
  }

  Future<void> unlockMenu(
    BottomTabModel tabData, {
    Function()? callback,
  }) async {
    try {
      if (null != Get.context) {
        LoadingDialog.show(Get.context!);
      }
      IndexRepository indexRepository = Global.getIt<IndexRepository>();
      UserModel? userInfo = await indexRepository.userInfo();
      num userCoins = userInfo?.coins ?? 0;
      num coinsTobeConsumed = tabData.unlockPrice;
      if (userCoins >= coinsTobeConsumed) {
        final dataMap = <String, dynamic>{
          'coins': coinsTobeConsumed,
          'busType': 'appMemu',
          'busId': tabData.id,
          'busName': '解锁${tabData.name}菜单',
        };
        await _repository.buy(dataMap);
        LoadingDialog.dismiss();
        if (null != callback) {
          callback();
        }
        showToast('解锁成功');
      } else {
        //用户金币数小于解锁金币数时，弹窗提示，用户点击立即充值后去金币充值页面
        TipDialog.show(Get.context!,
            title: "金币余额不足, 当前余额为${coinsTobeConsumed}金币",
            btnTitle: "立即充值", onOkBtn: () {
          Get.toNamed(AppRouter.coinRecharge);
        });
      }
    } catch (error) {
      LoadingDialog.dismiss();
    }
  }

  Future<void> hideFloatingButton(
    int index,
  ) async {
    final tabData = bottomTabDataList[index];
    final tag = tagList
        .where(
          (element) => tabData.url.endsWith(element),
        )
        .first;
    for (final item in tagList) {
      if (!tabData.url.endsWith(item)) {
        final floating = floatingMap[item];
        floating?.hideFloating();
      }
    }
    final currentFloating = floatingMap[tag];
    if (null != currentFloating && currentFloating.isShowing == false) {
      currentFloating.showFloating();
    }
  }

  Future<Floating?> showFloatingButton(
    BuildContext context,
    String tag,
  ) async {
    try {
      adsRsp ??= await GlobalController.to.getAdsData();
      if (null != adsRsp) {
        AdsModel? floatingBanner;
        if (tag == 'mine') {
          floatingBanner = adsRsp!.mineFloatingBannerValue;
        } else if (tag == 'home') {
          floatingBanner = adsRsp!.homeFloatingBannerValue;
        } else if (tag == 'hot') {
          floatingBanner = adsRsp!.hotFloatingBannerValue;
        } else if (tag == 'game') {
          floatingBanner = adsRsp!.gameFloatingBannerValue;
        } else if (tag == 'live') {
          floatingBanner = adsRsp!.liveFloatingBannerValue;
        } else if (tag == 'cartoon') {
          floatingBanner = adsRsp!.cartoonFloatingBannerValue;
        } else if (tag == 'novel') {
          floatingBanner = adsRsp!.novelFloatingBannerValue;
        } else if (tag == 'community') {
          floatingBanner = adsRsp!.communityFloatingBannerValue;
        } else if (tag == 'crack') {
          floatingBanner = adsRsp!.crackFloatingBannerValue;
        } else if (tag == 'aiUndress') {
          floatingBanner = adsRsp!.aiUndressFloatingBannerValue;
        }
        if (null != floatingBanner && context.mounted) {
          final floating = Floating(
            GestureDetector(
              onTap: () {
                GlobalController.to.launch(floatingBanner!);
              },
              child: RHExtendedImage.network(
                floatingBanner.pic,
                width: Dimens.gap_dp100,
                height: Dimens.gap_dp100,
                borderRadius: BorderRadius.circular(
                  Dimens.gap_dp10,
                ),
              ),
            ),
            slideType: FloatingSlideType.onRightAndBottom,
            right: 0,
            isShowLog: false,
            isPosCache: true,
            moveOpacity: 0.8,
            bottom: 80,
          );
          // floating.open(context);
          floatingMap[tag] = floating;
          return floating;
        }
      }
    } catch (error) {
      debugPrint('showFloatingButton error: $error');
    }
    return null;
  }

  // Future<void> didPushNext() async {
  //   final visibilityEvent = MainPageVisibilityEvent(
  //     visible: false,
  //     data: bottomTabDataList[currentIndex.value],
  //   );
  //   eventBus.fire(visibilityEvent);
  // }
  //
  // Future<void> didPopNext() async {
  //   final visibilityEvent = MainPageVisibilityEvent(
  //     visible: true,
  //     data: bottomTabDataList[currentIndex.value],
  //   );
  //   eventBus.fire(visibilityEvent);
  // }

  bool canPop() {
    return !(null == lastPopTime ||
        DateTime.now().difference(lastPopTime!) > const Duration(seconds: 2));
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
