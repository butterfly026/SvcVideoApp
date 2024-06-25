import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class UnlockDialog extends StatelessWidget {
  const UnlockDialog({
    super.key,
    required this.text,
    this.buttonText,
    this.onMenuUnlock,
  });

  final String text;
  final String? buttonText;
  final Function()? onMenuUnlock;

  static Future<void> show(
    BuildContext context,
    String text, {
    String? buttonText,
    Function()? onMenuUnlock,
  }) async {
    SmartDialog.show(
      tag: 'unlock',
      builder: (_) {
        return UnlockDialog(
          text: text,
          buttonText: buttonText,
          onMenuUnlock: onMenuUnlock,
        );
      },
      alignment: Alignment.center,
      backDismiss: true,
      clickMaskDismiss: false,
      maskColor: const Color(0xCC000000),
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'unlock');
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      intercepting: DeviceUtil.isWeb,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimens.gap_dp40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: Dimens.gap_dp1 * 450,
              child: Stack(
                children: [
                  RHExtendedImage.asset(
                    Images.imgBgUnlockMenu.assetName,
                    width: double.infinity,
                    height: Dimens.gap_dp1 * 450,
                  ),
                  Positioned(
                    left: 74,
                    right: 74,
                    bottom: 40,
                    child: GradientButton(
                      width: Dimens.gap_dp10 * 13,
                      height: Dimens.gap_dp48,
                      text: buttonText ?? '立即解锁',
                      onTap: () {
                        if (null != onMenuUnlock) {
                          onMenuUnlock!();
                        }
                        dismiss();
                      },
                    ),
                  ),
                  Positioned(
                    left: 56,
                    right: 56,
                    bottom: Dimens.gap_dp10 * 13,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFE7D4BA),
                        fontSize: Dimens.font_sp16,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gaps.vGap12,
            GestureDetector(
              onTap: () {
                dismiss();
              },
              child: RHExtendedImage.asset(
                Images.iconCloseCircle.assetName,
                width: Dimens.gap_dp30,
                height: Dimens.gap_dp30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
