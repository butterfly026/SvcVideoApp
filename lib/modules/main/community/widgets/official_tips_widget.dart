import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:marquee/marquee.dart';

class OfficialTipsWidget extends StatelessWidget {
  const OfficialTipsWidget({
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
          Expanded(
            child: SizedBox(
              height: Dimens.gap_dp38,
              child: Marquee(
                text: '用户自行上传，仅供参考。未见面不付款，见面不满意请拒绝服务',
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
