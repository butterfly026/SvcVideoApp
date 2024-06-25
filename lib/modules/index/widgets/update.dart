import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/update.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({
    super.key,
    this.data,
    this.onCancel,
    this.onUpdate,
  });

  final UpdateModel? data;
  final Function()? onCancel;
  final Function()? onUpdate;

  static Future<void> show(
    BuildContext context, {
    UpdateModel? data,
    Function()? onCancel,
    Function()? onUpdate,
  }) async {
    SmartDialog.show(
      tag: 'update',
      builder: (_) {
        return AppUpdateDialog(
          data: data,
          onCancel: onCancel,
          onUpdate: onUpdate,
        );
      },
      backDismiss: false,
      clickMaskDismiss: false,
      alignment: Alignment.center,
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'update');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.gap_dp10 * 30,
      height: Dimens.gap_dp10 * 39,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.vGap20,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(Dimens.gap_dp8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RHExtendedImage.asset(
                        Images.imgUpdateHeader.assetName,
                        width: double.infinity,
                        height: Dimens.gap_dp10 * 9,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        '发现新版本',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimens.font_sp18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.vGap12,
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.gap_dp12),
                          child: SingleChildScrollView(
                            child: HtmlWidget(data?.content ?? ''),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (onCancel != null)
                            GradientButton(
                              text: '暂不更新',
                              grey: true,
                              onTap: () {
                                dismiss();
                                if (null != onCancel) {
                                  onCancel!();
                                }
                              },
                            ),
                          GradientButton(
                            text: '立即更新',
                            onTap: () {
                              CommonUtil.launchUrl(
                                  data?.downloadUrl ?? '');
                              if (null != onUpdate) {
                                onUpdate!();
                              }
                            },
                          ),
                        ],
                      ),
                      Gaps.vGap32,
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: RHExtendedImage.asset(
              Images.imgUpdate.assetName,
              width: Dimens.gap_dp1 * 74,
              height: Dimens.gap_dp1 * 125,
            ),
          ),
        ],
      ),
    );
  }
}
