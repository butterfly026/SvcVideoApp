import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/mine/recharge_model.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/modules/main/mine/recharge/vip/vip_recharge_controller.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/countdown/countdown.dart';
import 'package:flutter_video_community/widgets/gradient_text.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

class VipRechargeListItem extends StatelessWidget {
  const VipRechargeListItem({
    super.key,
    required this.data,
  });

  final RechargeModel data;

  @override
  Widget build(BuildContext context) {
    final controller = VipRechargeController.to;
    final currentRecharge = controller.currentRecharge.value;
    final selected = data.id == currentRecharge?.id;
    return GestureDetector(
      onTap: () {
        controller.switchRecharge(data);
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: Dimens.gap_dp6),
            padding: EdgeInsets.only(
              left: Dimens.gap_dp8,
            ),
            height: Dimens.gap_dp1 * 64,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Dimens.gap_dp32,
                  height: Dimens.gap_dp32,
                  child: AppTool.isEmpty(data.pic)
                      ? null
                      : RHExtendedImage.network(
                    data.pic,
                    width: Dimens.gap_dp100,
                    height: Dimens.gap_dp100,
                    fit: BoxFit.cover,
                  ),
                ),
                Gaps.hGap10,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.vGap8,
                    Text(
                      data.name,
                      style: TextStyle(
                        fontSize: Dimens.font_sp14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF191D26),
                      ),
                    ),
                    Gaps.vGap6,
                    Row(
                      children: [
                        Text("原价",
                            style: TextStyle(
                              fontSize: Dimens.font_sp12,
                            )),
                        Text(
                          "￥${data.originalPrice}",
                          style: TextStyle(
                            fontSize: Dimens.font_sp12,
                            // 添加删除线
                            decoration: TextDecoration.lineThrough,
                            // 设置删除线颜色
                            decorationColor: Colors.black,
                            // 设置删除线样式为实线
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GradientText(
                        text: '特惠价',
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFF0000),
                            Color(0xFFFF9900),
                          ],
                        ),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.font_sp12,
                            fontWeight: FontWeight.bold),
                      ),
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
                          return GradientText(
                            text: '￥$price',
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFF0000),
                                Color(0xFFFF9900),
                              ],
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimens.font_sp24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Gaps.hGap8,
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
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
                // else if (data.donation.isNotEmpty) {
                //   textValue = data.donation;
                // } 赠送不展示
                if (textValue.isEmpty) {
                  return Gaps.empty;
                }
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.gap_dp2,
                    horizontal: Dimens.gap_dp12,
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: Images.imgBgLimitedTimeOffer,
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
          Positioned(
              right: 0,
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
