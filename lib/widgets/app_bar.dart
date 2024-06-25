import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/themes/theme.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    bool automaticallyImplyLeading = true,
    Widget? title,
    double? toolbarHeight,
    List<Widget>? actions,
    bool? centerTitle,
    double? titleSpacing,
    Widget? leading,
    Color? backgroundColor,
    SystemUiOverlayStyle? systemOverlayStyle,
  }) : super(
          key: key,
          title: title,
          titleSpacing: titleSpacing,
          systemOverlayStyle: systemOverlayStyle,
          automaticallyImplyLeading: automaticallyImplyLeading,
          backgroundColor: backgroundColor,
          centerTitle: centerTitle,
          actions: _buildActions(actions),
          leading: leading,
          toolbarHeight: toolbarHeight,
        );

  static List<Widget>? _buildActions(List<Widget>? items) {
    if ((items ?? []).isEmpty) return null;
    final ws = <Widget>[];
    for (var element in items!) {
      ws.add(
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: AppTheme.margin),
          child: element,
        ),
      );
    }
    return ws;
  }
}
