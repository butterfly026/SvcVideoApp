import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/countdown/countdown.dart';
import 'package:flutter_video_community/widgets/image.dart';

class InviteFriendBanner extends StatelessWidget {
  const InviteFriendBanner({
    super.key,
    required this.duration,
  });

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final data = CountdownModel.parse(duration);
    return SizedBox(
      height: Dimens.gap_dp10 * 9,
      child: Stack(
        children: [
          Align(
            child: Container(
              height: Dimens.gap_dp64,
              decoration: BoxDecoration(
                color: const Color(0xFFFFA800),
                borderRadius: BorderRadius.circular(Dimens.gap_dp10),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: RHExtendedImage.asset(
              Images.imgInviteFriend.assetName,
              height: Dimens.gap_dp64,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(Dimens.gap_dp10),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: Dimens.gap_dp54),
              child: RHExtendedImage.asset(
                Images.imgInviteFriendSlogan.assetName,
                height: Dimens.gap_dp44,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: Dimens.gap_dp30),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CountdownItemWidget(text: '${data.hour1}'),
                          Gaps.hGap4,
                          CountdownItemWidget(text: '${data.hour2}'),
                        ],
                      ),
                      Text(
                        '时',
                        style: TextStyle(
                          fontSize: Dimens.font_sp12,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      )
                    ],
                  ),
                  Gaps.hGap8,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CountdownItemWidget(text: '${data.minutes1}'),
                          Gaps.hGap4,
                          CountdownItemWidget(text: '${data.minutes2}'),
                        ],
                      ),
                      Text(
                        '分',
                        style: TextStyle(
                          fontSize: Dimens.font_sp12,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      )
                    ],
                  ),
                  Gaps.hGap8,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CountdownItemWidget(text: '${data.seconds1}'),
                          Gaps.hGap4,
                          CountdownItemWidget(text: '${data.seconds2}'),
                        ],
                      ),
                      Text(
                        '秒',
                        style: TextStyle(
                          fontSize: Dimens.font_sp12,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      )
                    ],
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

class CountdownItemWidget extends StatelessWidget {
  const CountdownItemWidget({
    super.key,
    required this.text,
    this.style,
    this.borderColor,
    this.width,
    this.height,
  });

  final String text;
  final Color? borderColor;
  final TextStyle? style;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Dimens.gap_dp18,
      height: height ?? Dimens.gap_dp30,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Theme.of(context).colorScheme.surface,
        ),
        borderRadius: BorderRadius.circular(
          Dimens.gap_dp4,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: style ??
            TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Dimens.font_sp14,
              color: Theme.of(context).colorScheme.surface,
            ),
      ),
    );
  }
}
