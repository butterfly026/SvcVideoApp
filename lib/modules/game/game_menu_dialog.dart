import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class GameMenuDialog extends StatelessWidget {
  const GameMenuDialog({super.key, required this.onClick});
  final Function(int index) onClick;

  static Future<void> show(
      BuildContext context, Function(int index) onClick) async {
    AppUtil.setFullScreen();
    SmartDialog.show(
      tag: 'gameMenu',
      builder: (_) {
        return GameMenuDialog(
          onClick: onClick,
        );
      },
      usePenetrate: false,
      alignment: Alignment.center,
      backDismiss: false,
      clickMaskDismiss: false,
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'gameMenu');
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      intercepting: DeviceUtil.isWeb,
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          color: const Color(0xFF2E2E2E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                onClick(1);
              },
              child: SizedBox(
                width: 80,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RHExtendedImage.asset(
                      Images.iconGameMenuHome.assetName,
                      width: 24,
                      height: 24,
                    ),
                    Text(
                      '返回大厅',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 1,
              height: 44,
              color: const Color(0xFFD9D9D9),
            ),
            GestureDetector(
              onTap: () {
                dismiss();
                Get.toNamed(AppRouter.gameDeposit);
              },
              child: SizedBox(
                width: 80,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RHExtendedImage.asset(
                      Images.iconGameMenuDeposit.assetName,
                      width: 24,
                      height: 24,
                    ),
                    Text(
                      '存款',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onClick(3);
              },
              child: SizedBox(
                width: 80,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RHExtendedImage.asset(
                      Images.iconGameMenuService.assetName,
                      width: 24,
                      height: 24,
                    ),
                    Text(
                      '客服',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                dismiss();
              },
              child: SizedBox(
                width: 80,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RHExtendedImage.asset(
                      Images.iconGameMenuClose.assetName,
                      width: 24,
                      height: 24,
                    ),
                    Text(
                      '关闭',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
