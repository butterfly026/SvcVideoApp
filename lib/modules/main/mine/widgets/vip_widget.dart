import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/widgets/image.dart';

class VipWidget extends StatelessWidget {
  const VipWidget({super.key, required this.vipTime});

  final String vipTime;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.gap_dp20,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: Dimens.gap_dp16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C5A),
              borderRadius: BorderRadius.circular(
                Dimens.gap_dp4,
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.gap_dp10,
                vertical: Dimens.gap_dp1 * 3,
              ),
              child: Text(
                AppUtil.getVipDate(vipTime),
                style: TextStyle(
                  fontSize: Dimens.font_sp10,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: RHExtendedImage.asset(
              Images.iconVip.assetName,
              width: Dimens.gap_dp1 * 23,
              height: Dimens.gap_dp20,
            ),
          ),
        ],
      ),
    );
  }
}
