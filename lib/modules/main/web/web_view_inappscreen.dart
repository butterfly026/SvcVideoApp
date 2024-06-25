import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewInAppScreen extends StatefulWidget {
  const WebViewInAppScreen({
    Key? key,
    required this.url,
    this.onWebProgress,
    this.onWebResourceError,
    required this.onLoadFinished,
    required this.onWebTitleLoaded,
    this.onWebViewCreated,
  }) : super(key: key);

  final String url;
  final Function(int progress)? onWebProgress;
  final Function(String? errorMessage)? onWebResourceError;
  final Function(String? url) onLoadFinished;
  final Function(String? webTitle)? onWebTitleLoaded;
  final Function(InAppWebViewController controller)? onWebViewCreated;

  @override
  State<WebViewInAppScreen> createState() => _WebViewInAppScreenState();
}

class _WebViewInAppScreenState extends State<WebViewInAppScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewOptions viewOptions = InAppWebViewOptions(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: true,
    applicationNameForUserAgent: "dface-yjxdh-webview",
  );
  String? htmlStr;
  String? deviceId;
  Map<String, String>? getDataMap;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    webViewController?.clearCache();
    super.dispose();
  }

  initData() async {
    deviceId = await CommonUtil().deviceId();
    getDataMap = <String, String>{
      'clientId': AppUtil.getClientByPlatform(),
      'deviceId': deviceId ?? "NULL",
      'token': Cache.getInstance().token.toString()
    };
  }

  // 设置页面标题
  void setWebPageTitle(data) {
    if (widget.onWebTitleLoaded != null) {
      widget.onWebTitleLoaded!(data);
    }
  }

  // flutter调用H5方法
  void callJSMethod() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(
              url: WebUri(widget.url),
              headers: getDataMap,
            ),
            initialUserScripts: UnmodifiableListView<UserScript>([
              UserScript(
                  source:
                      "document.cookie='token=${Cache.getInstance().token};domain='.laileshuo.cb';path=/'",
                  injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
            ]),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: viewOptions,
              android: AndroidInAppWebViewOptions(
                useShouldInterceptRequest: true, // <--
              ),
            ),
            onWebViewCreated: (controller) async {
              webViewController = controller;

              if (widget.onWebViewCreated != null) {
                widget.onWebViewCreated!(controller);
              }
              htmlStr = await DefaultAssetBundle.of(context)
                  .loadString('assets/data/index.html');
              webViewController!.loadData(data: htmlStr!);
            },
            onTitleChanged: (controller, title) {
              if (widget.onWebTitleLoaded != null) {
                widget.onWebTitleLoaded!(title);
              }
            },
            onLoadStart: (controller, url) {
              print('Page started loadi1g1: $url');
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url;

              if (uri != null && uri.toString().isURL) {
                await launchUrl(uri);
                return NavigationActionPolicy.CANCEL;
              }
              // 允许路由替换
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) async {
              webViewController?.evaluateJavascript(
                  source: "setToken('${getDataMap?['token']}');");
              webViewController?.evaluateJavascript(
                  source: "setDeviceId('$deviceId');");
              print('Page end loading: $url');
              // 加载完成
              widget.onLoadFinished(url.toString());
            },
            onProgressChanged: (controller, progress) {
              if (widget.onWebProgress != null) {
                widget.onWebProgress!(progress);
              }
            },
            onLoadError: (controller, Uri? url, int code, String message) {
              if (widget.onWebResourceError != null) {
                widget.onWebResourceError!(message);
              }
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {},
            onConsoleMessage: (controller, consoleMessage) {
              print(consoleMessage);
            },
            androidShouldInterceptRequest: (controller, request) async {
              request.headers?.addAll(getDataMap!);
              print(
                'Page end request androidShouldInterceptRequest: $request',
              );
            },
            onLoadResource: (controller, resource) {
              // 打印响应头
              print('Response headers:');
            },
          ),
        ),
        Container(
          height: ScreenUtil().bottomBarHeight + 50.0,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      child: const Icon(Icons.arrow_back),
                      onPressed: () async {
                        bool canGoBack = await webViewController!.canGoBack();
                        if (canGoBack) {
                          webViewController?.goBack();
                        } else {
                          Get.back();
                        }
                      },
                    ),
                    const SizedBox(
                      width: 25.0,
                    ),
                    ElevatedButton(
                      child: Icon(Icons.arrow_forward),
                      onPressed: () {
                        webViewController?.goForward();
                      },
                    ),
                    const SizedBox(
                      width: 25.0,
                    ),
                    ElevatedButton(
                      child: Icon(Icons.refresh),
                      onPressed: () {
                        // callJSMethod();
                        webViewController?.reload();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: ScreenUtil().bottomBarHeight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Map<String, String> getDataMap() {
  //   // final deviceId = await CommonUtil().deviceId();
  //   final dataMap = <String, String>{
  //     'clientId': AppUtil.getClientByPlatform(),
  //     'deviceId': "11111",
  //     'token': Cache.getInstance().token.toString()
  //   };
  //   return dataMap;
  // }
}
