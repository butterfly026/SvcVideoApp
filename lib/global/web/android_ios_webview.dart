import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/event/android_webview_redirect_event.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/web/web_logic.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'webview_option.dart';

//可以内嵌到页面的webView-android和ios的实现
class AndroidIosWebView extends StatefulWidget {
  const AndroidIosWebView(
      {super.key, required this.url, this.option, required this.tag});

  final String url;
  final WebViewOption? option;
  final String tag;

  @override
  State<AndroidIosWebView> createState() => AndroidIosWebViewState();
}

class AndroidIosWebViewState extends State<AndroidIosWebView> {
  late WebViewController controller;
  bool showContent = false; //是否显示加载完成的内容
  String url = '';
  late WebViewOption option;
  bool isAndroid = false; //在android的实现, 有些网址首次进入A会重定向到B,当B回退到A又会重定向到B, 回退会死循环
  //用于解决Android平台重定向的url, 当点回退的时候, 记录当前要回退的url B,
  // 如果onPageStarted有新的页面url等于要回退的url B, 说明回退到之前的A又被重定向了B
  String backUrl = '';
  @override
  void initState() {
    super.initState();
    url = widget.url;
    option = widget.option ?? WebViewOption();
    isAndroid = DeviceUtil.isAndroid;
    debugPrint('webview--initState--url=$url');

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            debugPrint(
                'webview--onPageStarted---mounted=${context.mounted}--url=$url');
            if (isAndroid) {
              if (backUrl == url) {
                eventBus.fire(AndroidWebViewRedirectEvent());
              }
            }
          },
          onPageFinished: (String url) {
            debugPrint('webview--pageFinish--url=$url');
            setState(() {
              showContent = true;
            });
            if (option.getTitle) {
              _getTitle();
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('webview--WebResourceError--error=$error');
          },
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }

            debugPrint('webview---onNavigationRequest---req=${request.url}');

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    bool showLoading = option.showLoading;
    debugPrint('webopt-> showLoading=$showLoading');
    if (showLoading) {
      return showContent
          ? WebViewWidget(controller: controller)
          : AppUtil.buildLoadingAnimation();
    }
    return WebViewWidget(controller: controller);
  }

  void reload() {
    controller.reload();
  }

  //webview是否代理系统返回事件, 如果true, webview有回退历史,则在返回webview里的页面
  //比如native-> webA -> webB, 如果为true, 点手机返回则从webB ->  webA -> native
  //如果为false, 点手机返回则从webB -> native
  Future<bool> backProxy() async {
    if (isAndroid) {
      backUrl = await controller.currentUrl() ?? '';
      debugPrint('webview---backProxy---url=$backUrl');
    }

    if (await controller.canGoBack()) {
      await controller.goBack();
      debugPrint('webview---backProxy--canGoBack-true');
      return false;
    }
    // 代理事件结束, 当前没有可返回的web页面
    return true;
  }

  void _getTitle() async {
    controller.runJavaScriptReturningResult("document.title").then((result) {
      String title = result.toString();
      if (title.isNotEmpty && title.contains("\"")) {
        title = title.replaceAll("\"", "");
      }
      if (title.isNotEmpty) {
        WebLogic webLogic = Get.find(tag: widget.tag);
        webLogic.title.value = title;
      }
    });
  }
}
