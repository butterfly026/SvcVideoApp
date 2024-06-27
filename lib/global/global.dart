
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_video_community/data/repository/community/community_repository.dart';
import 'package:flutter_video_community/data/repository/content/work_repository.dart';
import 'package:flutter_video_community/data/repository/favor/favor_repository.dart';
import 'package:flutter_video_community/data/repository/game/game_repository.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/data/repository/live/live_repository.dart';
import 'package:flutter_video_community/data/repository/main/main_repository.dart';
import 'package:flutter_video_community/data/repository/mine/mine_repository.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/screen.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';


EventBus eventBus = EventBus();
class Global{
  //用GetIt来管理实例化
  static final getIt = GetIt.instance;
  static Future<void> init() async {
    //注入全局单例
    getIt.registerSingleton<IndexRepository>(IndexRepository());
    getIt.registerSingleton<MainRepository>(MainRepository());
    getIt.registerSingleton<WorkRepository>(WorkRepository());
    getIt.registerSingleton<MineRepository>(MineRepository());
    getIt.registerSingleton<FavorRepository>(FavorRepository());
    getIt.registerSingleton<CommunityRepository>(CommunityRepository());
    getIt.registerSingleton<LiveRepository>(LiveRepository());
    getIt.registerSingleton<GameRepository>(GameRepository());
    await initWebView();
    debugPrint('Screen=> width=${Screen.width}  height=${Screen.height}');
  }

  static Future<void> initWebView() async {
    // if (DeviceUtil.isWeb) {
    //   WebViewPlatform.instance = WebWebViewPlatform();
    // }
    if (!DeviceUtil.isWeb && DeviceUtil.isAndroid) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
    }

    if (DeviceUtil.isAndroid) {
      var swAvailable = await WebViewFeature.isFeatureSupported(
          WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      var swInterceptAvailable = await WebViewFeature.isFeatureSupported(
          WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        ServiceWorkerController serviceWorkerController =
        ServiceWorkerController.instance();

        await serviceWorkerController.setServiceWorkerClient(
          ServiceWorkerClient(
            shouldInterceptRequest: (request) async {
              return null;
            },
          ),
        );
      }
    }
  }

}