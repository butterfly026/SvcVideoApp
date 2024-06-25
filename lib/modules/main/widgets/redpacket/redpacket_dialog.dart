import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 红包雨弹窗
class RedPacketDialog extends StatefulWidget {
  const RedPacketDialog({super.key});

  static Future<void> show(BuildContext context) async {
    SmartDialog.show(
      tag: 'red_packet',
      builder: (_) {
        return RedPacketDialog();
      },
      alignment: Alignment.center,
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'red_packet');
  }

  @override
  State<StatefulWidget> createState() => _RedPacketDialogState();
}

class _RedPacketDialogState extends State<RedPacketDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
