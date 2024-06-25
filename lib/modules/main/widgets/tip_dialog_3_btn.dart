import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';

//支持三个选项的通用提示
class TipDialog3Buttons extends StatelessWidget {
  const TipDialog3Buttons({
    super.key,
    required this.t1,
    required this.t2,
    required this.t3,
    this.onBtn1,
    this.onBtn2,
    this.onBtn3,
  });
  final String t1;
  final String t2;
  final String t3;
  final Function()? onBtn1;
  final Function()? onBtn2;
  final Function()? onBtn3;

  static Future<void> show(
    BuildContext context, {
        required String t1,
        required String t2,
        required String t3,
        Function()? onBtn1,
        Function()? onBtn2,
        Function()? onBtn3,

  }) async {
    SmartDialog.show(
      tag: 'tip',
      builder: (_) {
        return TipDialog3Buttons(t1: t1, t2: t2, t3: t3, onBtn1: onBtn1, onBtn2: onBtn2, onBtn3: onBtn3,);
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
    return Container(
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
                  bottom: 26,
                  child: Column(
                    children: [
                      _buildButton(t1, onBtn1),
                      Gaps.vGap14,
                      _buildButton(t2, onBtn2),
                      Gaps.vGap14,
                      _buildButton(t3, onBtn3),
                    ],
                  ),
                )
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
    );
  }

  Widget _buildButton(title, Function? onBtn) {
    return GradientButton(
                      width: Dimens.gap_dp10 * 20,
                      height: Dimens.gap_dp40,
                      text: title,
                      onTap: () {
                        if (null != onBtn) {
                          onBtn();
                        }
                        dismiss();
                      },
                    );
  }
}
