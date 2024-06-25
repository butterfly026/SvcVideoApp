import 'package:flutter/material.dart';
import 'package:flutter_video_community/global/web/app_webview.dart';
import 'package:flutter_video_community/global/web/webview_option.dart';
import 'package:flutter_video_community/global/widgets/state/loading_view.dart';
import 'package:flutter_video_community/modules/game/game_menu_dialog.dart';
import 'package:flutter_video_community/modules/game/game_play_logic.dart';
import 'package:flutter_video_community/modules/main/game/game_page_controller.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/widgets/dialog.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'game_drag_btn.dart';

class GamePlayPage extends StatefulWidget {
  const GamePlayPage({super.key});

  @override
  State<GamePlayPage> createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage> {
  String? code;
  late GamePlayLogic _logic;
  Offset _dragMenuPos = const Offset(30, 100);

  @override
  void initState() {
    super.initState();
    AppUtil.setFullScreen();
    _logic = Get.put(GamePlayLogic());
    code = Get.parameters['code'] ?? '0';
    _logic.requestGameUrl(code);
  }

  @override
  Widget build(BuildContext context) {
    // bool noData = AppTool.isEmpty(code);
    debugPrint('play game');
    final webOpt = WebViewOption();
    webOpt.showLoading = false;
    Widget menu = GameDragBtn(
      onTap: () {
        GameMenuDialog.show(
          context,
          (int index) async {
            if (index == 1) {
              GameMenuDialog.dismiss();
              AppUtil.setPortraitScreen();
              Get.back();
            } else if (index == 3) {
              GameMenuDialog.dismiss();
              String? url =
                  GamePageController.to.gameInfo.value?.customerService;
              AppUtil.showCustomer(url);
            }
          },
        );
      },
    );

    return Obx(
      () {
        String gameUrl = _logic.gameUrl.value;
        return MediaQuery.removePadding(
          removeTop: true,
          removeLeft: true,
          removeRight: true,
          removeBottom: true,
          context: context,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: AppTool.isEmpty(gameUrl)
                ? const LoadingView()
                : Stack(
                    children: [
                      PopScope(
                        canPop: false,
                        onPopInvoked: (bool didPop) {
                          if (didPop) {
                            return;
                          }
                          goBack();
                        },
                        child: AppWebView(
                          url: gameUrl,
                          option: webOpt,
                        ),
                      ),

                      Positioned(
                        top: _dragMenuPos.dy,
                        left: _dragMenuPos.dx,
                        child: DeviceUtil.isWeb
                            ? PointerInterceptor(child: menu)
                            : Draggable(
                                childWhenDragging: Container(
                                  color: Colors.transparent,
                                ),
                                feedback: menu,
                                onDragEnd: (pos) {
                                  setState(() {
                                    _dragMenuPos = pos.offset;
                                  });
                                },
                                child: menu,
                              ),
                      ),

                      // DragMove(child: GameDragBtn(onTap: () {
                      //   GameMenuDialog.show(context, (int index) async{
                      //     if (index == 1) {
                      //       GameMenuDialog.dismiss();
                      //       await SystemChrome.setPreferredOrientations(
                      //         [
                      //           DeviceOrientation.portraitUp,
                      //           DeviceOrientation.portraitDown,
                      //         ],
                      //       );
                      //       Get.back();
                      //     }
                      //   });
                      // },),)
                      // GameDragMenu(),
                    ],
                  ),
          ),
        );
      },
    );
  }

  goBack() {
    CustomActionDialog.show(
      context,
      text: '是否退出游戏？',
      actionCancelText: '确认退出',
      actionConfirmText: '再玩一会',
      onCancel: () async {
        AppUtil.setPortraitScreen();
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
