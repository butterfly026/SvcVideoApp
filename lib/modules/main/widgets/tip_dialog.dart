import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class TipDialog extends StatelessWidget {
  const TipDialog({
    super.key,
    required this.title,
    required this.btnTitle,
    this.onOkBtn,
  });
  final String title;
  final String btnTitle;
  final Function()? onOkBtn;

  static Future<void> show(
    BuildContext context, {
    Function()? onOkBtn,
    required String title,
    required String btnTitle,
  }) async {
    SmartDialog.show(
      tag: 'tip',
      builder: (_) {
        return TipDialog(onOkBtn: onOkBtn, title: title, btnTitle: btnTitle);
      },
      alignment: Alignment.center,
      backDismiss: true,
      clickMaskDismiss: false,
      maskColor: const Color(0xCC000000),
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'tip');
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
                      text: btnTitle,
                      onTap: () {
                        if (null != onOkBtn) {
                          onOkBtn!();
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
                      title,
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
