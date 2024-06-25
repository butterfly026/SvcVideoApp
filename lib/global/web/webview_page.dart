import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/event/android_webview_redirect_event.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/web/app_webview.dart';
import 'package:flutter_video_community/global/web/webview_option.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'android_ios_webview.dart';
import 'web_logic.dart';

//内置浏览器页
class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<StatefulWidget> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  String? title;
  //String? title;
  String url = '';
  late WebViewController controller;
  late WebLogic webLogic;
  late String tag; // tag用于保证每个webview有自己的logic

  final androidIosKey = GlobalKey<AndroidIosWebViewState>();
  late WebViewOption option;
  late final StreamSubscription androidWebViewRedirectSubscription;

  @override
  void initState() {
    super.initState();
    title = Get.parameters['title'];
    url = Get.parameters['url'] ?? '';
    //因为内嵌浏览器需要用到浏览器获取html title的能力,所以需要定义tag
    if (AppTool.isEmpty(url)) {
      tag = AppTool.md5RandomStr();
    } else {
      tag = AppTool.getLogicTag(url);
    }
    webLogic = Get.put(WebLogic(), tag: tag);
    option = WebViewOption();
    option.getTitle = true; //默认所有能力开关都是false,用到什么需要打开
    androidWebViewRedirectSubscription =
        eventBus.on<AndroidWebViewRedirectEvent>().listen((event) {
      if (context.mounted) {
        Get.back();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    androidWebViewRedirectSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //       leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () { Get.back(); },),
    //       title:  Text(title ?? '欢迎')),
    //   body: AppWebView(url: url),
    // );
    return Obx(() {
      String title = webLogic.title.value;
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(title),
          actions: [
            IconButton(
              onPressed: () {
                _reload();
              },
              icon: const Icon(Icons.refresh_rounded, size: 25),
            ),
          ],
        ),
        body: AppWebView(
            url: url, androidIosKey: androidIosKey, option: option, tag: tag),
      );
    });
  }

  _reload() {
    if (DeviceUtil.isWeb) {
    } else {
      androidIosKey.currentState?.reload();
    }
  }
}
