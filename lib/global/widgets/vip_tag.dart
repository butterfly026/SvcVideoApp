
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';

class VipTag extends StatelessWidget {
  const VipTag({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 17,
      alignment: Alignment.center,
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFfadfaf),
            Color(0xFFf8ce74),
          ],
        ),
        shape: StadiumBorder()
      ),
      child: Text(
        "VIP",
        style: TextStyle(
          fontSize: Dimens.font_sp10,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF9a5c1f),
        ),
      ),
    );
  }
}
