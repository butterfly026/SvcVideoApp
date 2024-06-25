import 'package:flutter/material.dart';
import 'package:flutter_video_community/global/web/android_ios_webview.dart';
import 'package:flutter_video_community/global/web/web_webview.dart';
import 'package:flutter_video_community/global/web/webview_option.dart';

//可以内嵌到页面的webView的封装
class AppWebView extends StatefulWidget {
  const AppWebView(
      {super.key,
      required this.url,
      this.androidIosKey,
      this.tag,
      this.option});

  final String url;
  final GlobalKey<AndroidIosWebViewState>? androidIosKey;
  final String? tag; //如果需要和浏览器交互,需要调用者定义tag
  final WebViewOption? option;
  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  //late WebViewController controller;
  String url = '';
  @override
  void initState() {
    super.initState();
    url = widget.url;
    if (!url.contains("http")) {
      url = 'http://$url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // return showContent ? WebViewWidget(controller: controller) : AppUtil.buildLoadingAnimation();
    // return DeviceUtil.isWeb ? WebWebView(url: url) : AndroidIosWebView(key: widget.androidIosKey, url: url,
    //   option: widget.option, tag: widget.tag ?? '');
    return WebWebView(key: widget.androidIosKey, url: url);
  }
}
