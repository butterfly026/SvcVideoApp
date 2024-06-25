import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/mine/recharge_model.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/modules/main/mine/recharge/coin/coin_recharge_controller.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/countdown/countdown.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

class CoinRechargeListItem extends StatelessWidget {
  const CoinRechargeListItem({
    super.key,
    required this.data,
  });

  final RechargeModel data;

  @override
  Widget build(BuildContext context) {
    final controller = CoinRechargeController.to;
    final currentRecharge = controller.currentRecharge.value;
    final selected = data.id == currentRecharge?.id;
    return GestureDetector(
      onTap: () {
        controller.switchRecharge(data);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: Dimens.gap_dp4),
            decoration: BoxDecoration(
              color:
                  selected ? const Color(0xFFFFEDE6) : const Color(0xFFFFFFFF),
              border: Border.all(
                color: selected
                    ? const Color(0xFFFF8413)
                    : const Color(0xFFE7E7E7),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(Dimens.gap_dp4),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: Dimens.gap_dp24,
                  height: Dimens.gap_dp24,
                  child: AppTool.isEmpty(data.pic)
                      ? null
                      : RHExtendedImage.network(
                          data.pic,
                          width: Dimens.gap_dp100,
                          height: Dimens.gap_dp100,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(Dimens.gap_dp12),
                        ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: Dimens.gap_dp4)
                        .copyWith(top: Dimens.gap_dp2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gaps.vGap16,
                        Obx(
                          () {
                            num price;
                            final newUserEquityTime =
                                GlobalController.to.newUserEquityTime.value;
                            if (newUserEquityTime > 0) {
                              price = data.newComerPrice.isEmpty
                                  ? 0.0
                                  : num.parse(data.newComerPrice);
                            } else {
                              price = data.presentPrice.isEmpty
                                  ? 0.0
                                  : num.parse(data.presentPrice);
                            }
                            return Text(
                              '￥$price',
                              style: TextStyle(
                                fontSize: Dimens.font_sp14,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                        if (data.introduction.isNotEmpty)
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: Dimens.gap_dp2,
                            ).copyWith(
                              top: Dimens.gap_dp2,
                            ),
                            child: Text(
                              data.introduction,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Dimens.font_sp12,
                                color: const Color(0xFF626773),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: Obx(
              () {
                String textValue = '';
                final newUserEquityTime =
                    GlobalController.to.newUserEquityTime.value;
                if (newUserEquityTime > 0 && data.newComerPrice.isNotEmpty) {
                  final duration = Duration(seconds: newUserEquityTime);
                  final countdownModel = CountdownModel.parse(duration);
                  textValue =
                      '限时优惠 ${countdownModel.hours}:${countdownModel.minutes}:${countdownModel.seconds}失效';
                }
                //赠送不展示
                // else if (data.donation.isNotEmpty) {
                //   textValue = data.donation;
                // }
                if (textValue.isEmpty) {
                  return Gaps.empty;
                }
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: Dimens.gap_dp10,
                  ),
                  constraints: BoxConstraints(
                    minWidth: Dimens.gap_dp1 * 63,
                  ),
                  height: Dimens.gap_dp1 * 18,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: Images.imgBgDeliverVip,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Text(
                    textValue,
                    style: TextStyle(fontSize: Dimens.font_sp10),
                  ),
                );
              },
            ),
          ),
          Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                width: Dimens.gap_dp20,
                height: Dimens.gap_dp20,
                child: AppTool.isEmpty(data.tag)
                    ? null :
                RHExtendedImage.network(
                  data.tag,
                  fit: BoxFit.contain,
                ),
              ))
        ],
      ),
    );
  }
}
