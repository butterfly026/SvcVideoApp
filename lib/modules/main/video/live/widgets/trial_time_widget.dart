import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/countdown/countdown.dart';
import 'package:flutter_video_community/widgets/image.dart';

class TrialTimeWidget extends StatelessWidget {
  const TrialTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.gap_dp52,
      child: Stack(
        children: [
          RHExtendedImage.asset(
            Images.imgVideoLiveTrialTime.assetName,
            height: Dimens.gap_dp52,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: Dimens.gap_dp12,
            right: Dimens.gap_dp1 * 46,
            child: CountdownWidget(
              seconds: 30,
              onComplete: () {},
              childBuilder: (context, seconds) {
                return Text(
                  '$seconds',
                  style: TextStyle(
                    color: const Color(0xFFF98418),
                    fontSize: Dimens.font_sp1 * 15,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
