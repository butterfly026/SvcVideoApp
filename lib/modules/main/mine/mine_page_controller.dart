import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_icons/flutter_app_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/data/event/main_page_visibility_event.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/tab.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:flutter_video_community/modules/index/widgets/update.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/storage/index.dart';
import 'package:flutter_video_community/utils/version.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class MinePageController extends GetxController {
  static MinePageController get to => Get.find();

  Rx<UserModel?> userInfo = Rx(null);

  RxList<AdsModel> mineApps = RxList();
  Rx<AdsModel?> mineBanner1 = Rx(null);
  Rx<AdsModel?> mineBanner2 = Rx(null);
  
  RxList<AppIconModel> appIcons = RxList(AppConfig.deskIconList);

  IndexRepository get _repository => null == Get.context
      ? IndexRepository()
      : RepositoryProvider.of<IndexRepository>(Get.context!);

  Timer? _timer;
  AdsRsp? adsRsp;

  @override
  void onReady() {
    super.onReady();
    adsRsp = GlobalController.to.adsRsp.value;
    mineApps.value = adsRsp?.mineAppList ?? [];
    final mineBanner1List = adsRsp?.mineBanner1List ?? [];
    mineBanner1.value = mineBanner1List.isEmpty
        ? null
        : mineBanner1List[Random().nextInt(mineBanner1List.length)];
    final mineBanner2List = adsRsp?.mineBanner2List ?? [];
    mineBanner2.value = mineBanner2List.isEmpty
        ? null
        : mineBanner2List[Random().nextInt(mineBanner2List.length)];

    // eventBus.on<MainPageVisibilityEvent>().listen((event) {
    //   if (event.visible && event.routeName == TabEnum.mine.type) {
    //     _timer = Timer.periodic(
    //       const Duration(seconds: 2),
    //       (_) {
    //         _fetchUserInfo();
    //       },
    //     );
    //   } else {
    //     _timer?.cancel();
    //     _timer = null;
    //   }
    // });

    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      final userInfo = await _repository.userInfo();
      this.userInfo.value = userInfo;
    } catch (error) {}
  }

  /// 检查更新
  Future<void> checkUpdate(
    BuildContext context,
  ) async {
    try {
      LoadingDialog.show(context);
      final appConfigInfo = await _repository.appConfigInfo();
      LoadingDialog.dismiss();
      if (null != appConfigInfo && null != Get.context) {
        final curVer = await CommonUtil().version();
        String serverVer = appConfigInfo.version;
        String clientVer = curVer;
        bool hasNewVer = VersionUtil.isGt(serverVer, clientVer);
        print(
            "vv3=>${serverVer}  ${clientVer}  ${hasNewVer}  ${appConfigInfo.needUpdate}");
        if (appConfigInfo.needUpdate) {
          //如果needUpdate字段为true，隐藏暂时更新按钮,强制更新。如果needUpdate字段不为true，服务端版本号大于客户端，显示更新弹窗，
          AppUpdateDialog.show(
            Get.context!,
            data: appConfigInfo.updateInfo,
            onCancel: null,
          );
        } else if (hasNewVer) {
          AppUpdateDialog.show(
            Get.context!,
            data: appConfigInfo.updateInfo,
            onCancel: () {
              //Get.offAndToNamed(AppRouter.main);
            },
          );
        } else {
          showToast('已经是最新版本');
        }
        // if (appConfigInfo.needUpdate) {
        //   AppUpdateDialog.show(
        //     Get.context!,
        //     data: appConfigInfo.updateInfo,
        //   );
        // }
      }
    } catch (error) {
      LoadingDialog.dismiss();
    }
  }

  Future<void> clearCache() async {
    Storage.instance.clear();
    Cache.clear();
    showToast('缓存清理成功');
  }

  Future<void> changeAppIcon(AppIconModel iconModel) async {
    if (DeviceUtil.isAndroid) {
      String oldIconName = "app-default";
      String cacheOldIconName = Storage.instance.getString("iconName");
      if (cacheOldIconName.isNotEmpty) {
        oldIconName = cacheOldIconName;
      }
      final flutterAppIconsPlugin = FlutterAppIcons();
      flutterAppIconsPlugin.setIcon(icon: iconModel.name, oldIcon: oldIconName);
      Storage.instance.setString("iconName", iconModel.name);
      showToast('设置桌面图标成功');
    }
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
    _timer = null;
  }
}
