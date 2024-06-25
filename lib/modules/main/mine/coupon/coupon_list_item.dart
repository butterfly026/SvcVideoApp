import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/mine/coupon_model.dart';
import 'package:flutter_video_community/widgets/gradient_text.dart';
import 'package:flutter_video_community/widgets/image.dart';

class CouponListItem extends StatelessWidget {
  const CouponListItem({
    super.key,
    required this.data,
  });

  final CouponModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.gap_dp1 * 106,
      margin: EdgeInsets.symmetric(
        vertical: Dimens.gap_dp8,
        horizontal: Dimens.gap_dp12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: const Color(0x40E3E3E3),
            offset: Offset(0, Dimens.gap_dp20),
            blurRadius: Dimens.gap_dp10,
            spreadRadius: -Dimens.gap_dp10,
          ),
        ],
        borderRadius: BorderRadius.circular(
          Dimens.gap_dp10,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: Dimens.gap_dp1 * 100,
            child: Center(
              child: GradientText(
                text: '${data.price}元',
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF0000),
                    Color(0xFFFF9900),
                  ],
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.font_sp22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          RHExtendedImage.asset(
            Images.imgDashLineVertical.assetName,
            width: Dimens.gap_dp1,
            height: double.infinity,
          ),
          Gaps.hGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.rechargePackageType,
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: Dimens.font_sp22,
                  ),
                ),
                Gaps.vGap10,
                Text(
                  '有效期至${data.expiresDate}',
                  style: TextStyle(
                    color: const Color(0xFF666666),
                    fontSize: Dimens.font_sp16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
