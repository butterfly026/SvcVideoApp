import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/event/update_download_progress.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/channel/channel.dart';
import 'package:flutter_video_community/utils/http/http.dart';
import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:r_upgrade/r_upgrade.dart';

class CrackPageController extends GetxController {
  static CrackPageController get to => Get.find();

  RxList<AdsModel> adsList = RxList();
  RxList<AdsModel> adsBannerList = RxList();
  RxString announcement = RxString('');

  Rx<LoadState> loadState = Rx(LoadState.successful);

  List<String> get bannerList => adsBannerList.map((e) => e.pic).toList();

  final ReceivePort _port = ReceivePort();

  Map<String, AppInfo> installedAppMap = <String, AppInfo>{};
  Map<String, File> installedAppFileMap = <String, File>{};

  Rx<AdsRsp?> adsRsp = Rx(null);

  @override
  void onReady() async {
    super.onReady();
    announcement.value = Cache.getInstance().appConfig?.rollAnnouncement ?? '';
    loadData();
    _bindBackgroundIsolate();
    adsRsp.value = await GlobalController.to.getAdsData();
  }

  Future<void> loadData() async {
    final adsRsp = GlobalController.to.adsRsp.value;
    adsList.value = adsRsp?.crackApps ?? [];
    adsBannerList.value = adsRsp?.crackBannerList ?? [];
  }

  Future<void> openApp(
    AdsModel adsModel,
  ) async {
    GlobalController.to.openApp(adsModel);
  }


  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final appId = (data as List<dynamic>)[0] as String;
      final progress = data[1] as int;

      debugPrint(
        'Callback on UI isolate: '
        'appId ($appId) download process ($progress)',
      );
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
}
