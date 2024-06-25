import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/modules/main/mine/mine_page_controller.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/app_icons_group_widget.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/user_info_header.dart';
import 'package:flutter_video_community/modules/main/widgets/app_icon_widget.dart';
import 'package:flutter_video_community/modules/main/widgets/app_item_widget.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/opennstall_util.dart';
import 'package:flutter_video_community/widgets/button/image.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:flutter_video_community/widgets/cell.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../../utils/umeng_util.dart';
import 'widgets/account_credentials_dialog.dart';
import 'widgets/coin_recharge_widget.dart';
import 'widgets/vip_recharge_widget.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with RouteAware {
  final _controller = Get.put(MinePageController());
  @override
  void didPopNext() {
    debugPrint('minePage-didPopNext-');
    _controller.fetchUserInfo();
    super.didPopNext();
  }

  @override
  void didPush() {
    debugPrint('minePage-didPush-');
    super.didPush();
  }

  @override
  void didChangeDependencies() {
    AppRouter.routeObservers.subscribe(
      this,
      ModalRoute.of(context)!,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    AppRouter.routeObservers.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() {
            UserModel? user = _controller.userInfo.value;
            return Container(
              padding: EdgeInsets.only(bottom: Dimens.gap_dp20),
              height: Dimens.gap_dp1 * 154,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.gap_dp14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Column(
                            children: [
                              SizedBox(
                                width: Dimens.gap_dp28,
                                height: Dimens.gap_dp28,
                                child: ImageButton(
                                  assetName: Images.iconQrCode.assetName,
                                ),
                              ),
                              Gaps.vGap2,
                              Text(
                                '身份卡',
                                style: TextStyle(
                                  fontSize: Dimens.font_sp10,
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            /// 展示二维码弹窗
                            AccountCredentialsDialog.show(context);
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            children: [
                              ImageButton(
                                assetName: Images.iconMessage.assetName,
                                imageSize: Dimens.gap_dp28,
                              ),
                              Gaps.vGap4,
                              Text(
                                '客服',
                                style: TextStyle(fontSize: Dimens.font_sp10),
                              )
                            ],
                          ),
                          onTap: () {
                            AppUtil.showCustomer('');
                          },
                        ),
                      ],
                    ),
                  ),
                  if (user != null) UserInfoHeader(userInfo: user)
                ],
              ),
            );
          }),
          Expanded(
            child: Container(
              color: const Color(0xFFF9F5F5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: Dimens.gap_dp6,
                            right: Dimens.gap_dp6,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    UmengUtil.upPoint(UMengType.vip, {
                                      'name': UMengEvent.toVipPage,
                                      'desc': '从我的页面进入会员充值页面'
                                    });

                                    /// 跳转到会员充值页
                                    Get.toNamed(AppRouter.vipRecharge);

                                    // Get.to(WebViewInAppScreen(
                                    //   url: "http://43.138.252.165:400",
                                    //   onWebTitleLoaded: (v) {},
                                    //   onLoadFinished: (v) {},
                                    // ));
                                  },
                                  child: const VipRechargeWidget(),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    UmengUtil.upPoint(UMengType.coin, {
                                      'name': UMengEvent.toCoinPage,
                                      'desc': '从我的页面进入金币充值页面'
                                    });

                                    /// 跳转到金币充值页
                                    Get.toNamed(AppRouter.coinRecharge);
                                  },
                                  child: const CoinRechargeWidget(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: Dimens.gap_dp64,
                              left: Dimens.gap_dp1 * 21,
                              right: Dimens.gap_dp16,
                            ),
                            constraints: BoxConstraints(
                              minHeight: Dimens.gap_dp100,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(
                                Dimens.gap_dp12,
                              ),
                            ),
                            child: Obx(() {
                              if (0 == _controller.mineApps.length) {
                                return Gaps.empty;
                              }
                              return GridView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                  top: Dimens.gap_dp12,
                                  bottom: Dimens.gap_dp4,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: Dimens.gap_dp10,
                                  childAspectRatio: 1.1,
                                ),
                                itemCount: _controller.mineApps.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      GlobalController.to.launch(
                                        _controller.mineApps[index],
                                      );
                                    },
                                    child: AppItemWidget(
                                      data: _controller.mineApps[index],
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () {
                        final banner1 = _controller.mineBanner1.value;
                        if (null == banner1) {
                          return Gaps.empty;
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppTheme.margin,
                          ).copyWith(
                            top: Dimens.gap_dp12,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              GlobalController.to.launch(banner1);
                            },
                            child: RHExtendedImage.network(
                              banner1.pic,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: Dimens.gap_dp100,
                              borderRadius: BorderRadius.circular(
                                Dimens.gap_dp10,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Obx(
                      () {
                        final banner2 = _controller.mineBanner2.value;
                        if (null == banner2) {
                          return Gaps.empty;
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppTheme.margin,
                          ).copyWith(
                            top: Dimens.gap_dp12,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              GlobalController.to.launch(banner2);
                            },
                            child: RHExtendedImage.network(
                              banner2.pic,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: Dimens.gap_dp100,
                              borderRadius: BorderRadius.circular(
                                Dimens.gap_dp10,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppTheme.margin,
                      ).copyWith(
                        top: Dimens.gap_dp12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(Dimens.gap_dp10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.gap_dp10),
                        child: CustomCellGroup(
                          minHeight: Dimens.gap_dp56,
                          showDivider: false,
                          children: [
                            _buildCustomCell(
                              context,
                              title: '收藏',
                              leading: Images.iconCollection.assetName,
                              onTap: () {
                                Get.toNamed(AppRouter.favor);
                                OpenInstallTool.reportEffectPoint("shoucang");
                              },
                            ),
                            _buildCustomCell(
                              context,
                              title: '分享有礼',
                              leading: Images.iconShare.assetName,
                              onTap: () {
                                Get.toNamed(AppRouter.share);
                              },
                            ),
                            _buildCustomCell(
                              context,
                              title: '检查更新',
                              leading: Images.iconCheckUpdate.assetName,
                              onTap: () {
                                _controller.checkUpdate(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (DeviceUtil.isAndroid || DeviceUtil.isIOS)
                      AppIconsGroupWidget(controller: _controller)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCell(
    BuildContext context, {
    required String title,
    required String leading,
    Function()? onTap,
  }) {
    return CustomCell(
      showArrow: true,
      onTap: onTap,
      leading: Container(
        margin: EdgeInsets.only(
          right: Dimens.gap_dp10,
        ),
        child: RHExtendedImage.asset(
          leading,
          width: Dimens.gap_dp20,
          height: Dimens.gap_dp20,
        ),
      ),
      title: Text(title),
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.gap_dp12,
      ),
      titleStyle: TextStyle(
        fontSize: Dimens.font_sp16,
        color: const Color(0xFF191D26),
      ),
    );
  }
}
