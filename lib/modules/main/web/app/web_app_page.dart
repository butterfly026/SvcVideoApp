import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_video_community/data/models/main/web.dart';
import 'package:flutter_video_community/modules/main/web/app/web_app_controller.dart';
import 'package:get/get.dart';

class WebAppPage extends StatefulWidget {
  const WebAppPage({
    super.key,
    required this.data,
  });

  final WebModel data;

  @override
  State<StatefulWidget> createState() => _WebAppPageState();
}

class _WebAppPageState extends State<WebAppPage> {
  final _controller = Get.put(WebAppController());

  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebAppController>(
      init: _controller,
      builder: (controller) {
        return InAppWebView(
          onWebViewCreated: (webViewController) {
            if (mounted) {
              this.webViewController = webViewController;
            }
          },
          gestureRecognizers: Set()
            ..add(
              Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
              ),
            ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              useOnDownloadStart: true,
            ),
          ),
          initialUrlRequest: URLRequest(
            url: WebUri(widget.data.url),
          ),
          onTitleChanged: (c, title) {
            /// void
          },
          onDownloadStartRequest: (
            controller,
            downloadStartRequest,
          ) {
            debugPrint('onDownloadStartRequest ${downloadStartRequest.url}');
            _controller.startDownload(
              context,
              downloadStartRequest.url.toString(),
            );
          },
        );
      },
    );
  }
}
