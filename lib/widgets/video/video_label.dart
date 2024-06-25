import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';

class VideoLabelWidget extends StatelessWidget {
  const VideoLabelWidget({
    super.key,
    required this.text,
    this.padding,
    this.style,
  });

  final String text;
  final EdgeInsets? padding;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: Dimens.gap_dp8,
            vertical: Dimens.gap_dp1,
          ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF0000),
            Color(0xFFFF9900),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.gap_dp10),
          bottomRight: Radius.circular(Dimens.gap_dp10),
        ),
      ),
      child: Text(
        text,
        style: style ??
            TextStyle(
              fontSize: Dimens.font_sp1 * 13,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
      ),
    );
  }
}
