
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';

class ThemeTag extends StatelessWidget {
  const ThemeTag({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 17,
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF0000),
            Color(0xFFFF9900),
          ],
        ),
        shape: StadiumBorder()
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.gap_dp6,
          vertical: Dimens.gap_dp1,
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: Dimens.font_sp10,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF9a5c1f),
          ),
        ),
      ),
    );
  }
}
