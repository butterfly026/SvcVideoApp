import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/mine/recharge_model.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/modules/main/game/deposit/deposit_page_controller.dart';
import 'package:flutter_video_community/widgets/countdown/countdown.dart';
import 'package:get/get.dart';

class DepositListItem extends StatelessWidget {
  const DepositListItem({
    super.key,
    required this.data,
  });

  final RechargeModel data;

  @override
  Widget build(BuildContext context) {
    final controller = DepositPageController.to;
    final currentRecharge = controller.currentRecharge.value;
    final selected = data.id == currentRecharge?.id;
    return GestureDetector(
      onTap: () {
        controller.switchRecharge(data);
      },
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        fontSize: Dimens.font_sp16,
                        color: const Color(0xFF191D26),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                Text(
                  '${data.presentPrice}金币',
                  style: TextStyle(
                    fontSize: Dimens.font_sp12,
                    color: const Color(0xFF626773),
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
                } else if (data.donation.isNotEmpty) {
                  textValue = data.donation;
                }
                if (textValue.isEmpty) {
                  return Gaps.empty;
                }
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.gap_dp2,
                  ).copyWith(
                    left: Dimens.gap_dp12,
                    right: Dimens.gap_dp6,
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: Images.imgBgDeliverVip,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Text(
                    textValue,
                    style: TextStyle(
                      fontSize: Dimens.font_sp10,
                      color: const Color(0xFF965100),
                    ),
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
