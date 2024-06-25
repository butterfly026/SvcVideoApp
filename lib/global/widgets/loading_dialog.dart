import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/widgets/loading.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
    this.message,
  });

  final String? message;

  static Future<void> show(
    BuildContext context, {
    String? message,
    bool? backDismiss,
    bool? clickMaskDismiss,
  }) async {
    SmartDialog.show(
      backDismiss: backDismiss,
      clickMaskDismiss: clickMaskDismiss,
      maskColor: Colors.transparent,
      builder: (_) {
        return Center(
          child: LoadingDialog(
            message: message ?? '加载中...',
          ),
        );
      },
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.gap_dp16,
        vertical: Dimens.gap_dp16,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(Dimens.gap_dp12),
      ),
      constraints: BoxConstraints(
        maxWidth: Dimens.gap_dp16 * 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Dimens.gap_dp30,
            height: Dimens.gap_dp30,
            child: const CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          if (null != message)
            Container(
              margin: EdgeInsets.only(top: Dimens.gap_dp10),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.font_sp14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
