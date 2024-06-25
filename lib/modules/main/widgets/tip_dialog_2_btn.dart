import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';

//title和两个按钮
class TipDialog2Buttons extends StatelessWidget {
  const TipDialog2Buttons({
    super.key,
    required this.title,
    required this.btnTitle1,
    required this.btnTitle2,
    this.onBtn1,
    this.onBtn2,
  });
  final String title;
  final String btnTitle1;
  final String btnTitle2;
  final Function()? onBtn1;
  final Function()? onBtn2;

  static Future<void> show(
    BuildContext context, {
        required String title,
        required String btnTitle1,
        required String btnTitle2,
        Function()? onBtn1,
        Function()? onBtn2,

  }) async {
    SmartDialog.show(
      tag: 'tip',
      builder: (_) {
        return TipDialog2Buttons(title: title, btnTitle1: btnTitle1, btnTitle2: btnTitle2, onBtn1: onBtn1, onBtn2: onBtn2,);
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
                  bottom: 84,
                  child: _buildButton(btnTitle1, onBtn1),
                ),
                Positioned(
                  left: 74,
                  right: 74,
                  bottom: 32,
                  child: _buildButton(btnTitle2, onBtn2),
                ),
                Positioned(
                  left: 56,
                  right: 56,
                  bottom: Dimens.gap_dp10 * 14.5,
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
