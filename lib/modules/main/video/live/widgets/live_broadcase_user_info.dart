import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/image.dart';

class LiveBroadcastUserInfo extends StatelessWidget {
  const LiveBroadcastUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.gap_dp52,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: Dimens.gap_dp50,
              constraints: BoxConstraints(
                minWidth: Dimens.gap_dp10 * 14,
              ),
              margin: EdgeInsets.only(left: Dimens.gap_dp26),
              padding: EdgeInsets.only(left: Dimens.gap_dp36),
              decoration: BoxDecoration(
                color: const Color(0x40000000),
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(Dimens.gap_dp26),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '倾听',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: Dimens.font_sp14,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ID:1020002',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: Dimens.font_sp14,
                      fontFamily: 'PingFang SC',
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: RHExtendedImage.asset(
              Images.imgLocalBanner.assetName,
              width: Dimens.gap_dp52,
              height: Dimens.gap_dp52,
              borderRadius: BorderRadius.circular(
                Dimens.gap_dp26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
