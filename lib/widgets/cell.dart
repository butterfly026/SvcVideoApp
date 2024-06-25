import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/themes/theme.dart';

class CustomCellGroup extends StatelessWidget {
  const CustomCellGroup({
    Key? key,
    this.children = const [],
    this.minHeight,
    this.showDivider = true,
    this.indent,
    this.endIndent,
  }) : super(key: key);

  final List<Widget> children;
  final double? minHeight;
  final bool showDivider;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    final ws = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      if (index != 0 && showDivider) {
        ws.add(
          Divider(
            height: 1.h,
            indent: indent ?? AppTheme.margin,
            endIndent: endIndent ?? AppTheme.margin,
          ),
        );
      }
      ws.add(
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minHeight ?? Dimens.gap_dp1 * 65,
          ),
          child: children[index],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: ws,
    );
  }
}

class CustomCell extends StatelessWidget {
  const CustomCell({
    Key? key,
    required this.title,
    this.leading,
    this.value,
    this.arrow,
    this.showArrow,
    this.valueWidth,
    this.onTap,
    this.titleStyle,
    this.valueStyle,
    this.padding,
  }) : super(key: key);

  final Widget title;
  final Widget? leading;
  final Widget? value;
  final Widget? arrow;
  final bool? showArrow;
  final double? valueWidth;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final EdgeInsets? padding;
  final void Function()? onTap;

  factory CustomCell.simple({
    Key? key,
    required Widget title,
    Widget? value,
    EdgeInsets? padding,
  }) = _CellWithSimple;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ws = <Widget>[];
    if (leading != null) {
      ws.add(leading!);
    }
    ws.add(
      Expanded(
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Dimens.font_sp18,
          ).merge(titleStyle),
          child: title,
        ),
      ),
    );
    if (value != null) {
      ws.add(SizedBox(
        width: Dimens.gap_dp12,
      ));
      ws.add(Container(
        constraints: BoxConstraints(maxWidth: valueWidth ?? double.infinity),
        alignment: Alignment.centerRight,
        child: DefaultTextStyle.merge(
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: Dimens.font_sp16,
            color: colorScheme.onBackground.withOpacity(0.7),
          ).merge(valueStyle),
          child: value!,
        ),
      ));
    }
    if ((null != onTap && showArrow != false) || null != arrow) {
      ws.add(SizedBox(width: Dimens.gap_dp8));
      ws.add(arrow ??
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: Dimens.gap_dp16,
            color: colorScheme.onBackground,
          ));
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: AppTheme.margin,
                vertical: Dimens.gap_dp10,
              ),
          child: Row(children: ws),
        ),
      ),
    );
  }
}

class CustomInputCell extends StatelessWidget {
  const CustomInputCell({
    Key? key,
    this.title,
    this.leading,
    this.icon,
    this.value,
    this.titleStyle,
    this.padding,
  }) : super(key: key);

  final Widget? title;
  final Widget? leading;
  final Widget? icon;
  final Widget? value;
  final TextStyle? titleStyle;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ws = <Widget>[];
    if (icon != null) {
      ws.add(
        IconTheme(
          data: IconThemeData(
            color: colorScheme.primary,
            size: Dimens.gap_dp26,
          ),
          child: icon!,
        ),
      );
      ws.add(SizedBox(
        width: Dimens.gap_dp16,
      ));
    }
    if (null != leading) {
      ws.add(leading!);
    }
    if (null != title) {
      ws.add(
        DefaultTextStyle.merge(
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Dimens.font_sp18,
          ).merge(titleStyle),
          child: title!,
        ),
      );
    }
    if (value != null) {
      ws.add(SizedBox(
        width: Dimens.gap_dp12,
      ));
      ws.add(
        Expanded(child: value!),
      );
    }

    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: AppTheme.margin,
            vertical: Dimens.gap_dp10,
          ),
      child: Row(children: ws),
    );
  }
}

class _CellWithSimple extends CustomCell {
  _CellWithSimple({
    Key? key,
    required Widget title,
    Widget? value,
    EdgeInsets? padding,
  }) : super(
          key: key,
          title: title,
          value: value,
          titleStyle: TextStyle(fontSize: Dimens.font_sp18),
          valueStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
            fontSize: Dimens.font_sp18,
          ),
          padding: padding,
        );
}
