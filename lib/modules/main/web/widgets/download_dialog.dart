import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/modules/main/web/webview_controller.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:get/get.dart';
import 'package:r_upgrade/r_upgrade.dart';

class DownloadDialog extends StatelessWidget {
  const DownloadDialog({super.key});

  static Future<void> show(
    BuildContext context,
  ) async {
    SmartDialog.show(
      tag: 'download',
      builder: (_) {
        return const DownloadDialog();
      },
      alignment: Alignment.center,
      backDismiss: false,
      clickMaskDismiss: false,
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'download');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: Dimens.gap_dp40,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.all(Dimens.gap_dp20),
            child: const Text(
              '提示',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(bottom: 12),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '正在下载，请稍候',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Gaps.vGap10,
                Obx(
                  () {
                    final downloadEvent =
                        WebViewController.to.downloadEvent.value;
                    if (null == downloadEvent) {
                      return Gaps.empty;
                    }
                    return SizedBox(
                      height: Dimens.gap_dp6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.gap_dp10),
                        child: LinearProgressIndicator(
                          backgroundColor: AppTheme.success.withAlpha(25),
                          value: downloadEvent.progress,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.success,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  dismiss();
                },
                child: Obx(
                  () {
                    final downloadEvent =
                        WebViewController.to.downloadEvent.value;
                    final downloadCompleted =
                        downloadEvent?.downloadCompleted ?? false;
                    return Text(
                      downloadCompleted ? '取消安装' : '取消下载',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    );
                  },
                ),
              ),
              Obx(
                () {
                  final downloadEvent =
                      WebViewController.to.downloadEvent.value;
                  final downloadCompleted =
                      downloadEvent?.downloadCompleted ?? false;
                  if (!downloadCompleted) {
                    return Gaps.empty;
                  }
                  return TextButton(
                    onPressed: () async {
                      dismiss();
                      await RUpgrade.installByPath(downloadEvent!.path);
                    },
                    child: const Text(
                      '下载完成，点击安装',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  );
                },
              ),
              Gaps.hGap10,
            ],
          ),
          Gaps.vGap10,
        ],
      ),
    );
  }
}
