import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/screen.dart';
import 'package:get/get.dart';

class CustomActionDialog extends StatelessWidget {
  const CustomActionDialog({
    super.key,
    required this.text,
    this.body,
    this.style,
  });

  final String text;
  final Widget? body;
  final TextStyle? style;

  static Future<void> show(
    BuildContext context, {
    required String text,
    String? actionConfirmText,
    String? actionCancelText,
    Function()? onConfirm,
    Function()? onCancel,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            '提示',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.zero,
          content: CustomActionDialog(
            text: text,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (null != onCancel) {
                  onCancel();
                }
              },
              child: Text(
                actionCancelText ?? '取消',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (null != onConfirm) {
                  onConfirm();
                }
              },
              child: Text(
                actionConfirmText ?? '确认',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Screen.width * 0.4,
      constraints: const BoxConstraints(
        minHeight: 80,
        maxHeight: 100,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: style ??
            TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
    );
  }
}

class CustomDialog {
  static Future<T?> showDialog<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool cancelable = true,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool removeViewInsets = true,
  }) async {
    return showGeneralDialog<T>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return WillPopScope(
          child: DialogView(
            removeViewInsets: removeViewInsets,
            child: Builder(builder: builder),
          ),
          onWillPop: () async => cancelable,
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
      useRootNavigator: useRootNavigator,
    );
  }
}

Widget _buildMaterialDialogTransitions(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

class DialogView extends StatelessWidget {
  const DialogView({
    Key? key,
    required this.child,
    this.removeViewInsets = true,
  }) : super(key: key);

  final Widget child;
  final bool removeViewInsets;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: MediaQuery.removeViewInsets(
        removeLeft: removeViewInsets,
        removeTop: removeViewInsets,
        removeRight: removeViewInsets,
        removeBottom: removeViewInsets,
        context: context,
        child: child,
      ),
    );
  }
}

class RhActionDialog extends StatelessWidget {
  const RhActionDialog({
    super.key,
    required this.text,
    this.body,
    this.style,
    this.onCancel,
    this.onConfirm,
    this.actionConfirmText,
    this.actionCancelText,
  });

  final String text;
  final Widget? body;
  final TextStyle? style;
  final Function()? onCancel;
  final Function()? onConfirm;
  final String? actionConfirmText;
  final String? actionCancelText;

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'action_dialog');
  }

  static Future<void> show(
    BuildContext context, {
    required String text,
    String? actionConfirmText,
    String? actionCancelText,
    Function()? onConfirm,
    Function()? onCancel,
  }) async {
    SmartDialog.show(
      tag: 'action_dialog',
      builder: (_) {
        return RhActionDialog(
          text: text,
          actionConfirmText: actionConfirmText,
          actionCancelText: actionCancelText,
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      },
      backDismiss: false,
      clickMaskDismiss: false,
    );
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
            child: Text(
              text,
              style: style ??
                  TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  dismiss();
                  if (null != onCancel) {
                    onCancel!();
                  }
                },
                child: Text(
                  actionCancelText ?? '取消',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  dismiss();
                  if (null != onConfirm) {
                    onConfirm!();
                  }
                },
                child: Text(
                  actionConfirmText ?? '确认',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
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
