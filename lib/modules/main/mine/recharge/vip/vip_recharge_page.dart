import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/mine/recharge_model.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/recharge_type.dart';
import 'package:flutter_video_community/modules/main/mine/recharge/vip/vip_recharge_list_item.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/pay/pay_controller.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/umeng_util.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/gradient_text.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/my_title.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import 'vip_recharge_controller.dart';

/// vip充值页
class VipRechargePage extends StatefulWidget {
  const VipRechargePage({super.key});

  @override
  State<StatefulWidget> createState() => _VipRechargePageState();
}

class _VipRechargePageState extends State<VipRechargePage> {
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
          Align(
            child: Container(
              height: Dimens.gap_dp1 * 138,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x00FFFFFF),
                    Color(0xFFF9F5F5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                CustomAppBar(
                  title: Text('会员充值',
                      style: TextStyle(fontSize: Dimens.font_sp16)),
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  actions: [
                    GestureDetector(
                      child: Text(
                        '充值记录',
                        style: TextStyle(
                          fontSize: Dimens.font_sp14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(AppRouter.orderHistory, parameters: {
                          'rechargeType': RechargeType.vip.value
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: GetBuilder<VipRechargeController>(
                    init: VipRechargeController(),
                    builder: (controller) {
                      final userInfo = controller.userInfo.value;
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: Dimens.gap_dp1 * 90,
                            margin: EdgeInsets.only(
                              left: Dimens.gap_dp16,
                              right: Dimens.gap_dp16,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  // Color(0xFFFFBBAA),
                                  // Color(0xFFFFCCAA),
                                  Color(0xFFFFDDDD),
                                  Color(0xFFFFF2E2),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                Dimens.gap_dp12,
                              ),
                            ),
                            child: ListTile(
                              // leading: RHExtendedImage.asset(
                              //   borderRadius: BorderRadius.circular(
                              //     Dimens.gap_dp1 * 50,
                              //   ),
                              //   'assets/images/dading.png',
                              //   width: Dimens.gap_dp54,
                              //   height: Dimens.gap_dp54,
                              // ),
                              leading: AppTool.isEmpty(userInfo?.avatar)
                                  ? RHExtendedImage.asset(
                                      'assets/images/dading.png',
                                      width: Dimens.gap_dp56,
                                      height: Dimens.gap_dp56,
                                      fit: BoxFit.cover,
                                      borderRadius: BorderRadius.circular(
                                          Dimens.gap_dp28),
                                    )
                                  : RHExtendedImage.network(
                                      userInfo!.avatar,
                                      width: Dimens.gap_dp56,
                                      height: Dimens.gap_dp56,
                                      fit: BoxFit.cover,
                                      borderRadius: BorderRadius.circular(
                                          Dimens.gap_dp28),
                                    ),
                              title: Text(
                                userInfo?.nickName ?? '',
                                style: TextStyle(
                                  fontSize: Dimens.font_sp16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                AppUtil.getVipDate(userInfo?.vipTime ?? ''),
                                style: TextStyle(fontSize: Dimens.font_sp12),
                              ),
                            ),
                          ),
                          Gaps.vGap20,
                          const MyTitleWidget("专属权益"),
                          Gaps.vGap20,
                          Wrap(
                            spacing: Dimens.gap_dp6,
                            // 控制子widget之间的横向间距
                            runSpacing: Dimens.gap_dp12,
                            // 控制子widget之间的纵向间距
                            alignment: WrapAlignment.start,
                            // 控制子widget在主轴方向的对齐方式
                            children: [
                              _buildPrivileges(
                                context,
                                "广告特权",
                                "广告全跳过",
                                Images.iconAdPrivilege,
                              ),
                              _buildPrivileges(
                                context,
                                "高速下载",
                                "全站高速下载",
                                Images.iconHighSpeedDownload,
                              ),
                              _buildPrivileges(
                                context,
                                "高清细节",
                                "细节不放过",
                                Images.iconHighDefinition,
                              ),
                            ],
                          ),
                          Gaps.vGap20,
                          const MyTitleWidget("优惠会员"),
                          Gaps.vGap10,
                          Expanded(
                            child: Obx(
                              () {
                                return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.margin,
                                  ),
                                  itemCount: controller.vipRechargeList.length,
                                  itemBuilder: (context, index) {
                                    final itemData =
                                        controller.vipRechargeList[index];
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: Dimens.gap_dp6,
                                      ),
                                      child: VipRechargeListItem(
                                        data: itemData,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Gaps.vGap8,
                          Container(
                            margin: EdgeInsets.only(
                              left: Dimens.gap_dp26,
                              right: Dimens.gap_dp26,
                              bottom: Dimens.gap_dp20,
                            ),
                            child: Obx(
                              () {
                                final currentRecharge =
                                    controller.currentRecharge.value;

                                num price;
                                if (null == currentRecharge) {
                                  price = 0.0;
                                } else {
                                  final newUserEquityTime = GlobalController
                                      .to.newUserEquityTime.value;
                                  if (newUserEquityTime > 0) {
                                    price =
                                        currentRecharge.newComerPrice.isEmpty
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
                                  text: '立即充值$price元',
                                  style: TextStyle(
                                    fontSize: Dimens.font_sp16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  onTap: () {
                                    PayController.setPayType(UMengType.vip);
                                    UmengUtil.upPoint(UMengType.vip, {
                                      'name': UMengEvent.vipRechargeBtn,
                                      'desc': '会员页面立即充值按钮点击',
                                      'value': '立即充值$price元',
                                    });
                                    controller.recharge(context);
                                  },
                                );
                              },
                            ),
                          ),
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

  /// =====================专属权益==========================
  Widget _buildPrivileges(BuildContext context, String title, String subTitle,
      ImageProvider image) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: Dimens.gap_dp8,
          ),
          width: Dimens.gap_dp1 * 129,
          height: Dimens.gap_dp1 * 74,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFE7E7E7),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(Dimens.gap_dp4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: Dimens.font_sp16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.vGap8,
              Text(
                subTitle,
                style: TextStyle(fontSize: Dimens.font_sp12),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Image(
            image: image,
            width: Dimens.gap_dp1 * 34,
            height: Dimens.gap_dp1 * 34,
          ),
        ),
      ],
    );
  }
}
