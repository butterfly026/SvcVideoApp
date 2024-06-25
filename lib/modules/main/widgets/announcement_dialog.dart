import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

/// 首页公告弹窗
class AnnouncementDialog extends StatelessWidget {
  const AnnouncementDialog({
    super.key,
    this.content,
  });

  final String? content;

  static Future<void> show(
    BuildContext context, {
    String? content,
    VoidCallback? onDismiss,
  }) async {
    SmartDialog.show(
      tag: 'announcement',
      builder: (_) {
        return AnnouncementDialog(content: content);
      },
      alignment: Alignment.center,
      backDismiss: false,
      clickMaskDismiss: false,
      onDismiss: onDismiss,
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'announcement');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.gap_dp10 * 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Dimens.gap_dp10 * 37,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: Dimens.gap_dp10 * 8,
                    child: Stack(
                      children: [
                        RHExtendedImage.asset(
                          Images.imgBgAnnounceHeader.assetName,
                          width: double.infinity,
                          height: Dimens.gap_dp10 * 8,
                          fit: BoxFit.fill,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: Dimens.gap_dp24),
                            child: Text(
                              '最新公告',
                              style: TextStyle(
                                color: const Color(0xFFB63002),
                                fontWeight: FontWeight.bold,
                                fontSize: Dimens.font_sp18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: Dimens.gap_dp60),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0x00FFFFFF),
                          Color(0xFFFFFFFF),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.infinity,
                    height: Dimens.gap_dp10 * 29,
                    margin: EdgeInsets.only(top: Dimens.gap_dp80),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(Dimens.gap_dp8),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: HtmlWidget(content ?? ''),
                          ),
                        ),
                        GradientButton(
                          text: '知道了',
                          width: Dimens.gap_dp10 * 11,
                          height: Dimens.gap_dp36,
                          onTap: () {
                            dismiss();
                          },
                        ),
                        Gaps.vGap32,
                      ],
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
