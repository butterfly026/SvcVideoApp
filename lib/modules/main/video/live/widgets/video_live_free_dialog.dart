import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/event/unlock_menu_event.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/widgets/bottom_navigation_bar/bottom_tab_model.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';

class VideoLiveFreeDialog extends StatelessWidget {
  const VideoLiveFreeDialog({
    super.key,
  });

  static Future<void> show(
    BuildContext context,
  ) async {
    SmartDialog.show(
      tag: 'video_live_free',
      builder: (_) {
        return const VideoLiveFreeDialog();
      },
      alignment: Alignment.center,
      backDismiss: true,
      clickMaskDismiss: false,
      maskColor: const Color(0xCC000000),
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'video_live_free');
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
                  bottom: 40,
                  child: GradientButton(
                    width: Dimens.gap_dp10 * 13,
                    height: Dimens.gap_dp48,
                    text: '立即开通',
                    onTap: () {
                      dismiss();
                    },
                  ),
                ),
                Positioned(
                  left: 56,
                  right: 56,
                  bottom: Dimens.gap_dp10 * 13,
                  child: Text(
                    '开通会员免费看直播',
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
}
