import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/global/widgets/state/loading_view.dart';
import 'package:flutter_video_community/modules/main/game/details/game_details_controller.dart';
import 'package:flutter_video_community/modules/main/game/widgets/dragbutton.dart';
import 'package:flutter_video_community/modules/main/game/widgets/game_floating_button.dart';
import 'package:flutter_video_community/modules/main/game/widgets/game_menu_dialog.dart';
import 'package:flutter_video_community/widgets/dialog.dart';
import 'package:get/get.dart';

class GameDetailsPage extends StatefulWidget {
  const GameDetailsPage({super.key});

  @override
  State<StatefulWidget> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage>
    with RouteAware, TickerProviderStateMixin {
  final controller = Get.put(GameDetailsController());

  @override
  void initState() {
    controller.widgetInit(this, mounted);
    super.initState();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    controller.setEnterOrientation();
  }

  @override
  void dispose() {
    controller.animController.stop();
    controller.animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String url = 'https://nqb.sq1010.cn/lobby/?uid=129828613&token=MTI5ODI4NjEzXzE3MDY3OTI0MTEzMzg6Mnl4YzlBS3NNTEw5bUFTOQ';

    return Scaffold(
      body: WillPopScope(
        child: GetBuilder<GameDetailsController>(
          init: controller,
          builder: (controller) {
           // final gameUrl = controller.gameUrl.value;
            final gameUrl = url;
            return gameUrl.isEmpty
                ? const LoadingView()
                : Stack(
                    children: [
                      InAppWebView(
                        onWebViewCreated: (webViewController) {
                          controller.onWebViewCreated(webViewController);
                        },
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            useShouldOverrideUrlLoading: true,
                          ),
                        ),
                        initialUrlRequest: URLRequest(
                          url: WebUri(gameUrl),
                        ),
                        shouldOverrideUrlLoading:
                            (ctrl, navigationAction) async {
                          return controller.urlLoading(ctrl, navigationAction);
                        },
                        onProgressChanged: (controller, progress) {},
                        onLoadStart: (ctrl, uri) {
                          controller.onLoadStart(uri);
                        },
                        onLoadStop: (ctrl, uri) {
                          controller.onLoadStop();
                        },
                      ),
                      controller.showFloatingButton.value
                          ? LayoutBuilder(
                              builder: (context, c) {
                                controller.initMenuLocation(context, c);
                                debugPrint(
                                  'maxWidth: ${c.maxWidth} maxHeight: ${c.maxHeight} offset: ${controller.offset}',
                                );
                                return Stack(
                                  children: [
                                    DraggableFloatingActionButton(
                                      child: GameFloatingButton(
                                        onTap: () {
                                          GameMenuDialog.show(context);
                                        },
                                      ),
                                      initialOffset: Offset(
                                        controller.offset.dx,
                                        controller.offset.dy,
                                      ),
                                      dragEnable: true,
                                      offsetChange: (offset) {
                                        controller.offset = offset;
                                        // SpUtil.putDouble("offsetX", offset.dx);
                                        // SpUtil.putDouble("offsetY", offset.dy);
                                        controller.setOffset(
                                          controller.offset,
                                          context,
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                          : Gaps.empty,
                    ],
                  );
          },
        ),
/*        child: Obx(
          () {
            final gameUrl = controller.gameUrl.value;
            if (gameUrl.isEmpty) {
              return const LoadingView();
            }
            return Stack(
              children: [
                Align(
                  child: InAppWebView(
                    onWebViewCreated: (webViewController) {
                      controller.onWebViewCreated(webViewController);
                    },
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                      ),
                    ),
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(gameUrl),
                    ),
                    shouldOverrideUrlLoading: (ctrl, navigationAction) async {
                      return controller.urlLoading(ctrl, navigationAction);
                    },
                    onProgressChanged: (controller, progress) {},
                    onLoadStart: (ctrl, uri) {
                      controller.onLoadStart(uri);
                    },
                    onLoadStop: (ctrl, uri) {},
                  ),
                ),
                LayoutBuilder(
                  builder: (context, c) {
                    controller.initMenuLocation(context, c);
                    return Stack(
                      children: [
                        SizedBox(width: c.maxWidth, height: c.maxHeight),
                        DraggableFloatingActionButton(
                          child: buildMainMenu(),
                          initialOffset: Offset(
                            controller.offset.dx,
                            controller.offset.dy,
                          ),
                          dragEnable: true,
                          offsetChange: (offset) {
                            controller.offset = offset;
                            // SpUtil.putDouble("offsetX", offset.dx);
                            // SpUtil.putDouble("offsetY", offset.dy);
                            controller.setOffset(
                              controller.offset,
                              context,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),*/
        onWillPop: () async {
          goBack();
          return Future(() => false);
        },
      ),
    );
  }

  goBack() {
    CustomActionDialog.show(
      context,
      text: '是否退出游戏？',
      actionCancelText: '确认退出',
      actionConfirmText: '再玩一会',
      onCancel: () async {
        await SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
        );
        Get.back();
        // Future.delayed(const Duration(milliseconds: 500)).then(
        //   (value) {
        //     Get.until((route) => route.settings.name == AppRouter.main);
        //     // eventBus.fire(RefreshBalance());
        //   },
        // );
      },
      onConfirm: () {
       // Get.back();
      },
    );
  }
}
