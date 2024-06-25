import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/image.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.title,
    this.style,
    this.value,
    this.valueStyle,
    this.more = false,
    this.onTap,
  });

  final String title;
  final TextStyle? style;
  final String? value;
  final TextStyle? valueStyle;
  final bool more;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.gap_dp40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: Dimens.gap_dp4,
            height: Dimens.gap_dp16,
            margin: EdgeInsets.only(
              right: Dimens.gap_dp10,
            ).copyWith(top: 3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF0000),
                  Color(0xFFFF9900),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Dimens.gap_dp2),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: Dimens.font_sp16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ).merge(style),
          ),
          Expanded(child: Gaps.empty),
          if (null != value)
            Text(
              value!,
              style: TextStyle(
                fontSize: Dimens.font_sp14,
                color: const Color(0xFF626773),
              ).merge(valueStyle),
            ),
          if (more)
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: Dimens.gap_dp20,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(
                  left: AppTheme.margin / 2,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '更多',
                      style: TextStyle(
                        fontSize: Dimens.font_sp16,
                        color: const Color(0xFF858078),
                      ).merge(style),
                    ),
                    Container(
                      width: Dimens.gap_dp20,
                      height: Dimens.gap_dp20,
                      margin: EdgeInsets.only(top: 4),
                      alignment: Alignment.center,
                      child: RHExtendedImage.asset(
                        Images.iconArrowRight.assetName,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
