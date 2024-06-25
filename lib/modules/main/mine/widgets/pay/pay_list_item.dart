import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/mine/pay_channel.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/pay/pay_controller.dart';
import 'package:flutter_video_community/widgets/image.dart';

class PayListItem extends StatelessWidget {
  const PayListItem({
    super.key,
    required this.data,
  });

  final PayChannelModel data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          PayController.to.switchPayChannel(data);
        },
        child: Container(
          height: Dimens.gap_dp52,
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.gap_dp16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RHExtendedImage.network(
                data.icon,
                width: Dimens.gap_dp28,
                height: Dimens.gap_dp28,
              ),
              Gaps.hGap10,
              Expanded(
                child: Text(
                  data.name,
                  style: TextStyle(
                    fontSize: Dimens.font_sp16,
                    color: const Color(0xFF626773),
                  ),
                ),
              ),
              RHExtendedImage.asset(
                data.selected
                    ? Images.iconCheckboxSelected.assetName
                    : Images.iconCheckboxUnSelected.assetName,
                width: Dimens.gap_dp20,
                height: Dimens.gap_dp20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
