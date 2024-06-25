import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/mine/recharge_model.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/recharge_type.dart';
import 'package:flutter_video_community/modules/main/game/deposit/deposit_list_item.dart';
import 'package:flutter_video_community/modules/main/game/deposit/deposit_page_controller.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/pay/pay_controller.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../../../utils/umeng_util.dart';

/// 金币充值页
class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  State<StatefulWidget> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: RHExtendedImage.asset(
              Images.imgBgHeader.assetName,
              width: double.infinity,
              height: Dimens.gap_dp1 * 375,
              fit: BoxFit.fill,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                CustomAppBar(
                  title: Text(
                    '我的钱包',
                    style: TextStyle(fontSize: Dimens.font_sp16),
                  ),
                  actions: [
                    IconButton(
                      constraints: const BoxConstraints.expand(width: 100),
                      icon: Text(
                        '存款记录',
                        style: TextStyle(
                          fontSize: Dimens.font_sp16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(AppRouter.orderHistory, parameters: {
                          'rechargeType': RechargeType.gameCoin.value,
                          'title': '存款记录'
                        });
                      },
                    ),
                  ],
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                ),
                Expanded(
                  child: GetBuilder<DepositPageController>(
                    init: DepositPageController(),
                    builder: (controller) {
                      return Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: controller.rechargeList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.6,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.margin,
                                vertical: AppTheme.margin,
                              ),
                              itemBuilder: (context, index) {
                                return DepositListItem(
                                  data: controller.rechargeList[index],
                                );
                              },
                            ),
                          ),
                          Gaps.vGap16,
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                              left: Dimens.gap_dp16,
                              right: Dimens.gap_dp16,
                            ),
                            child: Text(
                              "*到账后请自行划转到游戏余额",
                              style: TextStyle(
                                fontSize: Dimens.font_sp14,
                                color: const Color(0xFFFB6621),
                              ),
                            ),
                          ),
                          Gaps.vGap26,
                          Obx(
                            () {
                              final currentRecharge =
                                  controller.currentRecharge.value;

                              num price;
                              if (null == currentRecharge) {
                                price = 0.0;
                              } else {
                                final newUserEquityTime =
                                    GlobalController.to.newUserEquityTime.value;
                                if (newUserEquityTime > 0) {
                                  price = currentRecharge.newComerPrice.isEmpty
                                      ? 0.0
                                      : num.parse(
                                          currentRecharge.newComerPrice,
                                        );
                                } else {
                                  price = currentRecharge.presentPrice.isEmpty
                                      ? 0.0
                                      : num.parse(
                                          currentRecharge.presentPrice,
                                        );
                                }
                              }

                              return GradientButton(
                                width: double.infinity,
                                height: Dimens.gap_dp56,
                                margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.gap_dp12,
                                ),
                                text: '购买$price元',
                                onTap: () {
                                  PayController.setPayType(UMengType.game);
                                  UmengUtil.upPoint(UMengType.game, {
                                    'name': UMengEvent.gameRechargeBtn,
                                    'desc': '游戏充值页面购买充值按钮点击',
                                    'value': '购买$price元',
                                  });
                                  controller.recharge(context);
                                },
                              );
                            },
                          ),
                          Gaps.vGap26,
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                              left: Dimens.gap_dp16,
                              right: Dimens.gap_dp16,
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: Dimens.font_sp16,
                                  color: Colors.black,
                                  height: 1.8, // 设置行高为1.5倍字体大小
                                ),
                                children: [
                                  TextSpan(
                                    text: '*官方代理，急速到账，交易无忧*\n',
                                    style: TextStyle(
                                      fontSize: Dimens.font_sp14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF626773),
                                    ),
                                  ),
                                  TextSpan(
                                    text: '1、充值代理有失效限制，请及时联系官方代理、获取有效的充值方式。\n',
                                    style: TextStyle(
                                      fontSize: Dimens.font_sp14,
                                      color: const Color(0xFF626773),
                                    ),
                                  ),
                                  TextSpan(
                                    text: '2、充值高峰期，代理匹配存在延时，请使用在线充值',
                                    style: TextStyle(
                                      fontSize: Dimens.font_sp14,
                                      color: const Color(0xFF626773),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Gaps.vGap26,
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =====================金币选择==========================
  Widget _buildReCharge(BuildContext context,
      {required String title,
      required String subTitle,
      required int day,
      required ImageProvider image,
      required bool selected,
      required GestureTapCallback onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: Dimens.gap_dp6,
              ),
              width: Dimens.gap_dp1 * 129,
              height: Dimens.gap_dp1 * 64,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFFFEDE6)
                    : const Color(0xFFFFFFFF),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFFF8413)
                      : const Color(0xFFE7E7E7),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(Dimens.gap_dp4),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '￥$title',
                      style: TextStyle(
                          fontSize: Dimens.font_sp14, color: Colors.black),
                    ),
                    TextSpan(
                      text: subTitle.isNotEmpty ? '\n$subTitle' : '',
                      style: TextStyle(
                          fontSize: Dimens.font_sp12, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  left: Dimens.gap_dp10,
                ),
                width: Dimens.gap_dp1 * 63,
                height: Dimens.gap_dp1 * 18,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: Images.imgBgDeliverVip,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  "送$day天会员",
                  style: TextStyle(fontSize: Dimens.font_sp10),
                ),
              ),
            ),
          ],
        ));
  }
}
