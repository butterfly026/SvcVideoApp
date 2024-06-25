import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/modules/main/main_page.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

//可以内嵌到页面的webView--web端的实现
class WebWebView extends StatefulWidget {
  const WebWebView({Key? key, required this.url}) : super(key: key);

  final String url;
  @override
  State<WebWebView> createState() => _WebWebViewState();
}

class _WebWebViewState extends State<WebWebView> {
  final GlobalKey webViewKey = GlobalKey();
  // bool showContent = false; //是否显示加载完成的内容
  InAppWebViewController? webViewController;
  InAppWebViewSettings? webViewSettings;

  String url = '';
  String? htmlStr;
  String? deviceId;
  Map<String, String>? getDataMap;

  @override
  void initState() {
    super.initState();
    webViewSettings = InAppWebViewSettings(
      allowsInlineMediaPlayback: true,
      isInspectable: DeviceUtil.isDebug,
      useShouldInterceptRequest: true,
      allowContentAccess: true,
      allowsBackForwardNavigationGestures: true,
      allowUniversalAccessFromFileURLs: true,
      supportMultipleWindows: true,
      javaScriptEnabled: true,
      javaScriptCanOpenWindowsAutomatically: true,
    );
    replaceUrlPlaceholder();
    initData();
  }

  void replaceUrlPlaceholder() {
    url = CommonUtil.replaceUrlPlaceholder(widget.url);
  }

  @override
  void dispose() {
    super.dispose();
    MainPage.webViewController = null;
  }

  Future<void> initData() async {
    deviceId = await CommonUtil().deviceId();
    getDataMap = <String, String>{
      'clientId': AppUtil.getClientByPlatform(),
      'deviceId': deviceId ?? "NULL",
      'token': Cache.getInstance().token.toString()
    };
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 0) {
          MainPage.webViewController = null;
        } else {
          MainPage.webViewController = webViewController;
        }
      },
      child: InAppWebView(
        key: webViewKey,
        initialSettings: webViewSettings,
        initialUrlRequest: URLRequest(
          url: WebUri(url),
          headers: getDataMap,
        ),
        //         initialData: InAppWebViewInitialData(data: """
        // <!DOCTYPE html>
        // <html lang="en">

        // <head>
        //     <meta charset="UTF-8">
        //     <meta name="viewport"
        //         content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        // </head>

        // <body>
        //     <h1>JavaScript Handlers</h1>
        //     <button onclick="toFlutterPage()">toFlutterPage</button>
        //     <button onclick="getDataFromFlutter()">getDataFromFlutter</button>
        //     <button onclick="sendDataToFlutter()">sendDataToFlutter</button>
        //     <a href="https://www.baidu.com" target="_blank">新标签页</a>
        //     <script>
        //         window.addEventListener("flutterInAppWebViewPlatformReady", function (event) {
        //             // window.flutter_inappwebview.callHandler('getDataFromFlutter')
        //             //     .then(function (result) {
        //             //         // print to the console the data coming
        //             //         // from the Flutter side.
        //             //         console.log(JSON.stringify(result));
        //             //         window.flutter_inappwebview
        //             //             .callHandler('sendDataToFlutter', 1, true, ['bar', 5], { foo: 'baz' });
        //             //     });
        //         });

        //         function toFlutterPage() {
        //             window.flutter_inappwebview.callHandler('toFlutterPage', '/mine/settings');
        //         }

        //         function getDataFromFlutter() {
        //             window.flutter_inappwebview.callHandler('getDataFromFlutter')
        //                 .then(function (result) {
        //                     console.log(JSON.stringify(result));
        //                     alert(JSON.stringify(result));
        //                 });
        //         }

        //         function sendDataToFlutter() {
        //             window.flutter_inappwebview
        //                 .callHandler('sendDataToFlutter', 1, true, ['bar', 5], { foo: 'baz' });
        //         }
        //     </script>
        // </body>

        // </html>
        //                       """),
        onWebViewCreated: (InAppWebViewController controller) {
          webViewController = controller;
          // webViewController?.evaluateJavascript(
          //     source: "setToken('${getDataMap?['token']}');");
          // webViewController?.evaluateJavascript(
          //     source: "setDeviceId('$deviceId');");

          controller.addJavaScriptHandler(
            handlerName: 'getDataFromFlutter',
            callback: (args) {
              // return data to the JavaScript side!
              return getDataMap;
            },
          );

          controller.addJavaScriptHandler(
            handlerName: 'toFlutterPage',
            callback: (args) {
              Get.toNamed(args[0] as String);
            },
          );

          controller.addJavaScriptHandler(
            handlerName: 'sendDataToFlutter',
            callback: (args) {
              SmartDialog.show(
                builder: (_) {
                  return Text(jsonEncode(args));
                },
              );
              print(args);
              // it will print array data from js: [1, true, [bar, 5], {foo: baz}]
            },
          );
          MainPage.webViewController = webViewController;
        },
        onCreateWindow: (controller, createWindowRequest) async {
          print("onCreateWindow");

          launchUrl(
            createWindowRequest.request.url!,
            mode: LaunchMode.externalApplication,
          );

          return true;
        },
        onLoadStop: (controller, url) async {
          debugPrint('inappweb=>${url} controller=${controller}');
          // setState(() {
          //   showContent = true;
          // });
          print('Page end loading: $url');
        },
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT);
        },
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage);
        },
      ),
    );
  }
}
