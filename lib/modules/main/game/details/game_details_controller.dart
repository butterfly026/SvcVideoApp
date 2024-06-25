import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_video_community/data/repository/game/game_repository.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:get/get.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GameDetailsController extends GetxController {
  static GameDetailsController get to => Get.find();

  final RxString gameUrl = RxString('');

  final RxBool showFloatingButton = false.obs;

  InAppWebViewController? webViewController;

  double refreshX = 0;
  double refreshY = 0;
  double payX = 0;
  double payY = 0;
  double kfX = 0;
  double kfY = 0;
  double exitX = 0;
  double exitY = 0;
  Offset offset = Offset(0, 0);

  late AnimationController animController;
  late Animation animation;

  GameRepository get _repository => null == Get.context
      ? GameRepository()
      : RepositoryProvider.of<GameRepository>(Get.context!);

  @override
  void onInit() async {
    super.onInit();
    if (DeviceUtil.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
      var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE,
      );
      var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST,
      );
      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController =
            AndroidServiceWorkerController.instance();
        serviceWorkerController.setServiceWorkerClient(
          AndroidServiceWorkerClient(
            shouldInterceptRequest: (request) async {
              return null;
            },
          ),
        );
      }
    }
    setEnterOrientation();
  }

  widgetInit(widget, mounted) {
    animController = AnimationController(
      vsync: widget,
      duration: const Duration(milliseconds: 200),
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: Curves.easeOut,
      ),
    );
    animController.addListener(() {
      if (mounted) {
        update();
      }
    });
  }

  /// 设置横屏
  void setEnterOrientation() async {
    // if (orientation == "portrait") {
    //   await SystemChrome.setPreferredOrientations(
    //       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // } else {
    //   await SystemChrome.setPreferredOrientations(
    //       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    // }
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    update();

    Future.delayed(const Duration(seconds: 1), () {
      showFloatingButton.value = true;
      update();
    });
  }

  @override
  void onReady() {
    super.onReady();
    final gameCode = Get.arguments as String;
    _getGameUrl(gameCode);
  }

  Future<void> _getGameUrl(String gameCode) async {
    try {
      // final userId = Cache.getInstance().userInfo?.userId;
      final dataMap = <String, dynamic>{
        'code': gameCode,
        // 'userId': userId,
      };
      final value = await _repository.gameUrl(dataMap);
      gameUrl.value = value;
      update();
      // gameUrl.value =
      //     'https://wc-h5-g.zvkkj570.com?account=61982_5d74c8cc11084c5c94a6cc7d043d7105&token=eyJkYXRhIjoie1wiYWNjb3VudFwiOlwiNjE5ODJfNWQ3NGM4Y2MxMTA4NGM1Yzk0YTZjYzdkMDQzZDcxMDVcIixcIm1hY2hpbmVOYW1lXCI6XCJncmVlblwifSIsImNyZWF0ZWQiOjE3MDI2ODM3NjMsImV4cCI6MzAwfQ==.uY7hJd6csUnObe55nVmWr8GDmBFmBZH7Kd/Lua7Hrpo=&lang=zh_cn&moneyType=1&route=wc-wss-g.zvkkj570.com&loudou=https://wc-loud.zvkkj570.com/statisticsHandle&gameId=8650&defaultSkin=[4]&orientation=landscape&returnUrl=http://154.84.7.74:5004/video/gameManagement/game/redirect/8650/5d74c8cc11084c5c94a6cc7d043d7105';
    } catch (error) {
      ///
    }
  }

  void onWebViewCreated(
    InAppWebViewController webViewController,
  ) {
    this.webViewController = webViewController;
    this.webViewController?.addJavaScriptHandler(
          handlerName: "openPage",
          callback: (argument) {
            // if (argument.isNotEmpty) {
            //   Map<String, dynamic> map = argument.first;
            //   openPage(map["url"], "0", params: map["params"]);
            // }
          },
        );
    this.webViewController?.addJavaScriptHandler(
          handlerName: 'getToken',
          callback: (argument) {
            // return Cache.getInstance().token ?? '';
            return 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MDI5OTIwOTIsInVzZXJuYW1lIjoiNjIwMDQ0NjJkMSJ9.NimQ5POj2Ktptz1LFc1jLsLUfeiqpNSQZdRFdjaId34';
          },
        );
  }

  /// url 加载中
  urlLoading(ctrl, navigationAction) async {
    var uri = navigationAction.request.url!;
    if (uri.scheme == 'apps' || uri.scheme == 'app') {
      CommonUtil.launchUrl(
        uri.toString().replaceFirst('app', 'http'),
        mode: LaunchMode.externalApplication,
      );
      return NavigationActionPolicy.CANCEL;
    }
    if (!['http', 'https'].contains(uri.scheme)) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return NavigationActionPolicy.CANCEL;
    }
    // String token = Cache.getInstance().token ?? '';
    String token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MDI5OTIwOTIsInVzZXJuYW1lIjoiNjIwMDQ0NjJkMSJ9.NimQ5POj2Ktptz1LFc1jLsLUfeiqpNSQZdRFdjaId34';
    if (DeviceUtil.isAndroid ||
        navigationAction.iosWKNavigationType ==
            IOSWKNavigationType.LINK_ACTIVATED) {
      ctrl.loadUrl(
        urlRequest: URLRequest(
          url: uri,
          headers: {
            'token': token,
          },
        ),
      );
      return NavigationActionPolicy.CANCEL;
    }
    return NavigationActionPolicy.ALLOW;
  }

  /// url 开始加载
  void onLoadStart(uri) async {
    if (uri?.scheme == 'apps' || uri?.scheme == 'app') {
      CommonUtil.launchUrl(
        uri.toString().replaceFirst('app', 'http'),
        mode: LaunchMode.externalApplication,
      );
      return;
    }
    if (!['http', 'https'].contains(uri?.scheme)) {
      if (await canLaunchUrl(uri!)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void onLoadStop() {
    update();
  }

  void initMenuLocation(context, c) {
    offset = Offset(30, c.maxHeight / 2 - 22.5);
    setOffset(offset, context);
    if (offset.dy > c.maxHeight - 45) {
      offset = Offset(offset.dx, c.maxHeight / 2 - 22.5);
    }
    if (offset.dx > c.maxWidth - 45) {
      offset = Offset(30, offset.dy);
    }
  }

  setOffset(
    Offset offset,
    BuildContext context,
  ) {
    if (offset.dx > MediaQuery.of(context).size.width - 105) {
      if (offset.dy < 70) {
        refreshX = -100;
        refreshY = 0;
        payX = -85;
        payY = 50;
        kfX = -50;
        kfY = 85;
        exitX = 0;
        exitY = 100;
      } else if (offset.dy > MediaQuery.of(context).size.height - 115) {
        refreshX = 0;
        refreshY = -100;
        payX = -50;
        payY = -85;
        kfX = -85;
        kfY = -50;
        exitX = -100;
        exitY = 0;
      } else {
        refreshX = 0;
        refreshY = -70;
        payX = -60;
        payY = -30;
        kfX = -60;
        kfY = 30;
        exitX = 0;
        exitY = 70;
      }
    } else if (offset.dx < 105) {
      if (offset.dy < 70) {
        refreshX = 100;
        refreshY = 0;
        payX = 85;
        payY = 50;
        kfX = 50;
        kfY = 85;
        exitX = 0;
        exitY = 100;
      } else if (offset.dy > MediaQuery.of(context).size.height - 115) {
        refreshX = 0;
        refreshY = -100;
        payX = 50;
        payY = -85;
        kfX = 85;
        kfY = -50;
        exitX = 100;
        exitY = 0;
      } else {
        refreshX = 0;
        refreshY = -70;
        payX = 60;
        payY = -30;
        kfX = 60;
        kfY = 30;
        exitX = 0;
        exitY = 70;
      }
    } else {
      if (offset.dy < 70) {
        if (offset.dx > MediaQuery.of(context).size.width - 145) {
          refreshX = -100;
          refreshY = 0;
          payX = -85;
          payY = 50;
          kfX = -50;
          kfY = 85;
          exitX = 0;
          exitY = 100;
        } else {
          refreshX = 100;
          refreshY = 0;
          payX = 85;
          payY = 50;
          kfX = 50;
          kfY = 85;
          exitX = 0;
          exitY = 100;
        }
      } else if (offset.dy > MediaQuery.of(context).size.height - 115) {
        if (offset.dx > MediaQuery.of(context).size.width - 145) {
          refreshX = -100;
          refreshY = 0;
          payX = -85;
          payY = 50;
          kfX = -50;
          kfY = 85;
          exitX = 0;
          exitY = 100;
        } else {
          refreshX = 0;
          refreshY = -100;
          payX = 50;
          payY = -85;
          kfX = 85;
          kfY = -50;
          exitX = 100;
          exitY = 0;
        }
      } else {
        refreshX = 0;
        refreshY = -70;
        payX = 60;
        payY = -30;
        kfX = 60;
        kfY = 30;
        exitX = 0;
        exitY = 70;
      }
    }
  }
}
