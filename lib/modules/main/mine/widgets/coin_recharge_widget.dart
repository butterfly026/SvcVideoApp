import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/image.dart';

class CoinRechargeWidget extends StatelessWidget {
  const CoinRechargeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Dimens.gap_dp100,
      margin: EdgeInsets.only(
        right: Dimens.gap_dp10,
      ),
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
                left: Dimens.gap_dp44,
                top: Dimens.gap_dp10,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD283),
                    Color(0xFFFFB950),
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
                      text: '金币充值\n',
                      style: TextStyle(
                        fontSize: Dimens.font_sp14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    TextSpan(
                      text: '限时特惠 充值返利',
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
              Images.iconCoinRecharge.assetName,
              width: Dimens.gap_dp66,
              height: Dimens.gap_dp54,
            ),
          ),
        ],
      ),
    );
  }
}
