//
// import 'package:flutter/material.dart';
// import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
//
// //可以内嵌到页面的webView--web端的实现
// class WebWebView extends StatefulWidget {
//   const WebWebView({super.key, required this.url});
//
//   final String url;
//   @override
//   State<WebWebView> createState() => _WebWebViewState();
// }
//
// class _WebWebViewState extends State<WebWebView> {
//
//   bool showContent = false; //是否显示加载完成的内容
//   late PlatformWebViewController controller;
//   String url = '';
//   @override
//   void initState() {
//     super.initState();
//     url = widget.url;
//     controller = PlatformWebViewController(
//       const PlatformWebViewControllerCreationParams(),
//     )..loadRequest(
//       LoadRequestParams(
//         uri: Uri.parse(url),
//       ),
//     );
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  PlatformWebViewWidget(
//       PlatformWebViewWidgetCreationParams(controller: controller),
//     ).build(context);
//   }
// }
