import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:marquee/marquee.dart';

class AnnouncementWidget extends StatelessWidget {
  const AnnouncementWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.gap_dp38,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF3E8),
        // gradient: LinearGradient(
        //   colors: [
        //     Color(0xFFFF0000),
        //     Color(0xFFFF9900),
        //   ],
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        // ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.margin,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RHExtendedImage(
            image: Images.iconOfficialTips,
            width: Dimens.gap_dp24,
            height: Dimens.gap_dp24,
          ),
          Gaps.hGap12,
          RHExtendedImage(
            image: Images.imgNewest,
            width: Dimens.gap_dp30,
            height: Dimens.gap_dp18,
          ),
          Gaps.hGap10,
          Expanded(
            child: SizedBox(
              height: Dimens.gap_dp38,
              child: Marquee(
                text: text,
                velocity: 50.0,
                scrollAxis: Axis.horizontal,
                blankSpace: Dimens.gap_dp20,
                style: TextStyle(
                  fontSize: Dimens.font_sp14,
                  color: const Color(0xFFFB6621),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
