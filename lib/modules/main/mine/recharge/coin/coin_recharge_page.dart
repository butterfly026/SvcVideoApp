import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';
import 'package:flutter_video_community/data/models/mine/recharge_model.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/recharge_type.dart';
import 'package:flutter_video_community/modules/main/mine/recharge/coin/coin_recharge_controller.dart';
import 'package:flutter_video_community/modules/main/mine/recharge/coin/coin_recharge_list_item.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/pay/pay_controller.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/cache_util.dart';
import 'package:flutter_video_community/utils/umeng_util.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/gradient_text.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/my_title.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

/// 金币充值页
class CoinRechargePage extends StatefulWidget {
  const CoinRechargePage({super.key});

  @override
  State<StatefulWidget> createState() => _CoinRechargePageState();
}

class _CoinRechargePageState extends State<CoinRechargePage> {
  final _controller = Get.put(CoinRechargeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Obx(() {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: Text(
                    '金币充值',
                    style: TextStyle(
                      fontSize: Dimens.font_sp16,
                    ),
                  ),
                  actions: [
                    IconButton(
                      constraints: const BoxConstraints.expand(width: 100),
                      icon: Text(
                        '充值记录',
                        style: TextStyle(
                          fontSize: Dimens.font_sp16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(AppRouter.orderHistory, parameters: {
                          'rechargeType': RechargeType.coin.value
                        });
                      },
                    ),
                  ],
                  flexibleSpace: Align(
                    alignment: Alignment.topCenter,
                    child: RHExtendedImage.asset(
                      Images.imgBgHeader.assetName,
                      width: double.infinity,
                      height: Dimens.gap_dp1 * 375,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Image(
                    image: Images.imgBgCoinRecharge,
                    width: Dimens.gap_dp1 * 317,
                    height: Dimens.gap_dp1 * 74,
                  ),
                  Gaps.vGap16,
                  Container(
                    alignment: Alignment.centerLeft,
                    height: Dimens.gap_dp1 * 109,
                    margin: EdgeInsets.only(
                      left: Dimens.gap_dp16,
                      right: Dimens.gap_dp16,
                    ),
                    padding: EdgeInsets.only(
                      left: Dimens.gap_dp16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFE0A9),
                          Color(0xFFFFCE63),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        Dimens.gap_dp12,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '钱包余额',
                          style: TextStyle(
                            fontSize: Dimens.font_sp16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF965100),
                          ),
                        ),
                        Gaps.vGap8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(
                              () {
                                return Text(
                                  '${_controller.userInfo.value?.coins ?? 0}',
                                  style: TextStyle(
                                    fontSize: Dimens.font_sp20,
                                    color: const Color(0xFF5C3200),
                                  ),
                                );
                              },
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: Dimens.gap_dp1 * 180,
                                  height: Dimens.gap_dp30,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFFE0A9),
                                        Color(0xFFFFE0A9),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      Dimens.gap_dp6,
                                    ),
                                  ),
                                  child: GradientText(
                                    text: "充值成功, 立赠VIP无限观影",
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFF0000),
                                        Color(0xFFFF9900)
                                      ],
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.font_sp12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Gaps.hGap16,
                          ],
                        ),
                      ],
                    ),
                  ),
                ])),
                SliverPadding(
                  padding: EdgeInsets.all(Dimens.gap_dp16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.6,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final itemData = _controller.rechargeList[index];
                      return CoinRechargeListItem(
                        data: itemData,
                      );
                    }, childCount: _controller.rechargeList.length),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  const MyTitleWidget("钱包用途"),
                  Gaps.vGap16,
                  Container(
                    margin: EdgeInsets.only(
                      left: Dimens.gap_dp16,
                      right: Dimens.gap_dp16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWalletUsage(
                          context,
                          "直播打赏",
                          Images.iconWalletUsage1,
                        ),
                        _buildWalletUsage(
                          context,
                          "玩游戏",
                          Images.iconWalletUsage2,
                        ),
                        _buildWalletUsage(
                          context,
                          "色圈打赏",
                          Images.iconWalletUsage3,
                        ),
                        _buildWalletUsage(
                          context,
                          "购买视频",
                          Images.iconWalletUsage4,
                        ),
                        _buildWalletUsage(
                          context,
                          "楼风解锁",
                          Images.iconWalletUsage5,
                        ),
                      ],
                    ),
                  ),
                  Gaps.vGap16,
                  const MyTitleWidget("常见问题"),
                  Gaps.vGap16,
                  Container(
                    alignment: Alignment.centerLeft,
                    height: Dimens.gap_dp1 * 78,
                    margin: EdgeInsets.only(
                      left: Dimens.gap_dp16,
                      right: Dimens.gap_dp16,
                    ),
                    padding: EdgeInsets.only(
                      left: Dimens.gap_dp1 * 13,
                      right: Dimens.gap_dp1 * 13,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(
                        Dimens.gap_dp12,
                      ),
                    ),
                    child: Text(
                      "问：充值多久到账? \n答：一般为1~5分钟内即可到账，如果5分钟仍未到账可联系客服咨询核对",
                      style: TextStyle(
                        fontSize: Dimens.font_sp12,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.gap_dp100),
                ]))
              ],
            );
          }),
          // CustomAppBar(
          //   title: Text(
          //     '金币充值',
          //     style: TextStyle(
          //       fontSize: Dimens.font_sp16,
          //     ),
          //   ),
          //   actions: [
          //     GestureDetector(
          //       child: Text(
          //         '充值记录',
          //         style: TextStyle(
          //           fontSize: Dimens.font_sp14,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       onTap: () {
          //         Get.toNamed(AppRouter.orderHistory, arguments: {'rechargeType': RechargeType.coin.value});
          //       },
          //     ),
          //   ],
          //   backgroundColor: Colors.transparent,
          //   systemOverlayStyle: const SystemUiOverlayStyle(
          //     statusBarColor: Colors.transparent,
          //     statusBarIconBrightness: Brightness.dark,
          //   ),
          // ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.gap_dp16,
                vertical: Dimens.gap_dp16,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    child: SizedBox(
                      height: Dimens.gap_dp56,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: Images.iconCustomerService,
                            width: Dimens.gap_dp1 * 23.33,
                            height: Dimens.gap_dp1 * 21.94,
                          ),
                          Gaps.vGap6,
                          Text(
                            "联系客服",
                            style: TextStyle(
                                fontSize: Dimens.font_sp12,
                                color: const Color(0xFF965100)),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      AppUtil.showCustomer('');
                    },
                  ),
                  Expanded(
                    child: Obx(
                      () {
                        final currentRecharge =
                            _controller.currentRecharge.value;

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
                          height: Dimens.gap_dp56,
                          margin: EdgeInsets.only(left: Dimens.gap_dp12),
                          text: '确认充值$price元',
                          onTap: () {
                            PayController.setPayType(UMengType.coin);
                            UmengUtil.upPoint(UMengType.coin, {
                              'name': UMengEvent.coinRechargeBtn,
                              'desc': '金币充值页面立即充值按钮点击',
                              'value': '确认充值$price元',
                            });
                            _controller.recharge(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =====================钱包用途==========================
  Widget _buildWalletUsage(
      BuildContext context, String title, ImageProvider image) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - Dimens.gap_dp32) / 5,
      height: Dimens.gap_dp62,
      child: Column(
        children: [
          Image(
            image: image,
            width: Dimens.gap_dp36,
            height: Dimens.gap_dp36,
          ),
          Gaps.vGap6,
          Text(title, style: TextStyle(fontSize: Dimens.font_sp12))
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
