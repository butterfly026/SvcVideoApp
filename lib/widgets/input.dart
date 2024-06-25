import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';

class CustomInputNormal extends StatelessWidget {
  const CustomInputNormal({
    super.key,
    required this.controller,
    this.textAlign,
    this.style,
    this.hintStyle,
    this.hintText,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final TextAlign? textAlign;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      maxLines: 1,
      maxLength: maxLength,
      textAlign: textAlign ?? TextAlign.start,
      inputFormatters: inputFormatters,
      style: style ??
          TextStyle(
            fontFamily: 'Sans',
            fontSize: Dimens.font_sp16,
            height: 1.3,
            fontWeight: FontWeight.w600,
          ),
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        hintText: hintText ?? '请输入',
        hintStyle: hintStyle ??
            TextStyle(
              fontSize: Dimens.font_sp16,
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class MyNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;

  ///允许的小数位数，-1代表不限制位数
  int digit;
  MyNumberTextInputFormatter({this.digit = -1});
  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  ///获取目前的小数位数
  static int getValueDigit(String value) {
    if (value.contains(".")) {
      return value.split(".")[1].length;
    } else {
      return -1;
    }
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value == "-") {
      value = "-";
      selectionIndex++;
    } else if (value != "" && value != defaultDouble.toString() && strToFloat(value, defaultDouble) == defaultDouble || getValueDigit(value) > digit) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}