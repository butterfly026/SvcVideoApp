import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.radius,
    this.style,
    this.onTap,
    this.grey = false,
    this.margin,
  });

  final String text;
  final double? width;
  final double? height;
  final double? radius;
  final TextStyle? style;
  final Function()? onTap;
  final bool grey;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Dimens.gap_dp1 * 97,
      height: height ?? Dimens.gap_dp30,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: grey
              ? const [
                  Color(0xFFAEAEAE),
                  Color(0x80AEAEAE),
                ]
              : const [
                  Color(0xFFFF0000),
                  Color(0xFFFF9900),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          radius ?? Dimens.gap_dp6,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            radius ?? Dimens.gap_dp6,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: Dimens.font_sp16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF8EDE4),
              ).merge(style),
            ),
          ),
        ),
      ),
    );
  }
}
