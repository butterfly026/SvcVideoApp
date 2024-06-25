import 'dart:async';
import 'dart:io';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/event/update_download_progress.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/models/ip.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';
import 'package:flutter_video_community/data/models/main/web.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/global/enum/launch.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/repository/global_repository.dart';
import 'package:flutter_video_community/modules/main/main_controller.dart';
import 'package:flutter_video_community/modules/main/main_page.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/channel/channel.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/http/http.dart';
import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:path_provider/path_provider.dart';

class GlobalController extends GetxController {
  static GlobalController get to => Get.find();

  Rx<AppConfigModel?> appConfigInfo = Rx(null);
  Rx<AdsRsp?> adsRsp = Rx(null);

  RxMap<String, AppInfo> installedAppMap = RxMap();
  RxMap<String, File> installedAppFileMap = RxMap();

  RxInt newUserEquityTime = RxInt(0);

  GlobalRepository get _repository => null == Get.context
      ? GlobalRepository()
      : RepositoryProvider.of<GlobalRepository>(Get.context!);

  IndexRepository get _indexRepository => null == Get.context
      ? IndexRepository()
      : RepositoryProvider.of<IndexRepository>(Get.context!);

  @override
  void onReady() {
    super.onReady();
    //检查仅适用于 Android 的已安装应用程序 iOS not supported
    if (DeviceUtil.isAndroid) {
      getInstalledApps();
    }
    // _getIpAddressInfo();
    // getFastestHost();
  }

  Future<void> getFastestHost() async {
    final fastestHost = await _repository.getFastestHost();
    debugPrint('fastestHost ======> $fastestHost');
  }

  Future<Map<String, AppInfo>> getInstalledApps() async {
    final installedAppList =
        DeviceUtil.isAndroid ? await InstalledApps.getInstalledApps(true) : [];
    for (final item in installedAppList) {
      if (null != item.packageName) {
        installedAppMap[item.packageName!] = item;
      }
    }
    return installedAppMap;
  }

  Future<IpModel?> getIpAddressInfo() async {
    //先获取UserInfo对象的loginIp
    await _indexRepository.userInfo();
    return await _repository.getIpAddress();
  }

  Future<AdsRsp?> getAdsData() async {
    if (null != adsRsp.value) {
      return adsRsp.value;
    }
    try {
      final mainAppInfo = Cache.getInstance().mainApp;
      if (null != mainAppInfo) {
        final adsData = await _repository.adsData(mainAppInfo.id);
        adsRsp.value = adsData;
        return adsData;
      }
    } catch (error) {
      return null;
    }
    return null;
  }

  Future<void> launch(
    AdsModel data,
  ) async {
    if (data.isAdv) {
      /// 如果是广告，则需要上传点击事件
      uploadClickEvent(data.id);
    }

    final openWay = data.openWay;
    final urlValue = data.url;

    // if (urlValue.startsWith('app://')) {
    //   if (urlValue == 'app://aiUndress') {
    //     Get.toNamed(AppRouter.undress);
    //   } else if (urlValue == 'app://community') {
    //     Get.toNamed(AppRouter.louFeng);
    //   }
    //   return;
    // }
    if (openWay == LaunchType.web.value) {
      /// app 内打开浏览器
      AppUtil.toAppWebPage(urlValue);
    } else if (openWay == LaunchType.third.value) {
      /// 三方浏览器打开
      CommonUtil.launchUrl(
        data.url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (urlValue.startsWith('app://')) {
        if (urlValue == 'app://aiUndress') {
          Get.toNamed(AppRouter.undress);
        } else if (urlValue == 'app://home' ||
            urlValue == 'app://mine' ||
            urlValue == 'app://game' ||
            urlValue == 'app://live' ||
            urlValue == 'app://hot' ||
            urlValue == 'app://crack' ||
            urlValue == 'app://tv' ||
            urlValue == 'app://novel') {
          gotoMainPage(urlValue);
        } else if (urlValue == 'app://community') {
          Get.toNamed(AppRouter.louFeng);
        } else if (urlValue == 'app://video_listView') {
          data.direction = 'list_view';
          Get.toNamed(
            AppRouter.videoApp,
            arguments: data,
          );
        }
      }
    }
  }

  Future<void> gotoMainPage(String url) async {
    late MainController controller = MainController.to;
    int index =
        controller.bottomTabDataList.indexWhere((tab) => tab.url == url);
    index = index == -1 ? 0 : index;
    if (Get.isRegistered<MainController>()) {
      Get.find<MainController>().changeIndex(index);
    } else {
      Get.to(() => MainPage(curIndex: index));
    }
  }

  Future<void> uploadClickEvent(
    String advId,
  ) async {
    await _repository.uploadClickEvent(advId);
  }

  Future<void> updateAppConfig(
    AppConfigModel model,
  ) async {
    appConfigInfo.value = model;
  }

  StreamSubscription<int>? _streamSubscription;

  Future<void> startCountdown(int newUserEquityTime) async {
    final countdownSeconds = newUserEquityTime;
    _streamSubscription?.cancel();
    _streamSubscription = Stream.periodic(
      const Duration(seconds: 1),
      (x) {
        return countdownSeconds - x - 1;
      },
    ).take(countdownSeconds).listen(
      (value) {
        final loginModel = Cache.getInstance().login;
        if (null != loginModel) {
          loginModel.newUserEquityTime = value;
          _indexRepository.persistLoginResult(loginModel);
        }
        this.newUserEquityTime.value = value;
      },
    );
  }

  Future<void> cancel() async {
    _streamSubscription?.cancel();
  }

  Future<void> openApp(
    AdsModel adsModel,
  ) async {
    if (installedAppMap.isEmpty) {
      await getInstalledApps();
    }
    if (installedAppMap.containsKey(adsModel.packageName)) {
      await InstalledApps.startApp(adsModel.packageName);
    } else if (adsModel.url.endsWith('.apk')) {
      downloadApp(adsModel);
    } else {
      GlobalController.to.launch(adsModel);
    }
  }

  Future<void> downloadApp(
    AdsModel adsModel,
  ) async {
    File? apkFile = installedAppFileMap[adsModel.packageName];
    if (null != apkFile) {
      installApk(apkFile.path);
      return;
    }
    showToast('应用正在后台下载中，请稍候...');
    final appDir = await getApplicationDocumentsDirectory();
    apkFile = await File(
      '${appDir.path}/apk/crack_${adsModel.name}.apk',
    ).create(recursive: true);
    bool downloadCompleted = false;
    http.download(
      adsModel.url,
      apkFile.path,
      deleteOnError: true,
      onReceiveProgress: (count, total) async {
        if (total != -1) {
          final double ratio = count / total;
          debugPrint('${(ratio * 100).toStringAsFixed(0)}%');

          final event = UpdateDownloadProgress(
            progress: ratio,
            appId: adsModel.id,
          );
          eventBus.fire(event);

          if (ratio >= 1.0 && !downloadCompleted) {
            installedAppFileMap[adsModel.packageName] = apkFile!;
            downloadCompleted = true;
            installApk(apkFile.path);
          }
        }
      },
      options: Options(
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
    cancel();
  }
}
