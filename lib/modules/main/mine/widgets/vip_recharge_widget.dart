import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/image.dart';

class VipRechargeWidget extends StatelessWidget {
  const VipRechargeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Dimens.gap_dp100,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                left: Dimens.gap_dp16,
              ),
              padding: EdgeInsets.only(
                left: Dimens.gap_dp38,
                top: Dimens.gap_dp10,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF0000),
                    Color(0xFFFF9900),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(
                  Dimens.gap_dp12,
                ),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '会员充值\n',
                      style: TextStyle(
                        fontSize: Dimens.font_sp14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    TextSpan(
                      text: '永久会员限时开放',
                      style: TextStyle(
                        fontSize: Dimens.font_sp12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: RHExtendedImage.asset(
              Images.iconVipRecharge.assetName,
              width: Dimens.gap_dp54,
              height: Dimens.gap_dp50,
            ),
          ),
        ],
      ),
    );
  }
}
