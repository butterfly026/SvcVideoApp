import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/main/web.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/modules/main/game/game_page_controller.dart';
import 'package:flutter_video_community/modules/main/main_controller.dart';
import 'package:flutter_video_community/modules/main/widgets/announcement_widget.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/widgets/banner.dart';
import 'package:flutter_video_community/widgets/button/draggable.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

import 'widgets/game_classify_item_list_widget.dart';
import 'widgets/game_classify_list_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final controller = Get.put(GamePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () {
                  final bannerList = controller.adsList;
                  final isEmpty = bannerList.isEmpty;
                  if (isEmpty) {
                    return Gaps.empty;
                  }

                  /// banner
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppTheme.margin,
                    ).copyWith(bottom: Dimens.gap_dp12),
                    child: CustomBanner(
                      list: controller.adsList,
                    ),
                  );
                },
              ),

              /// 公告
              Obx(
                () {
                  if (controller.announcement.value.isEmpty) {
                    return Gaps.empty;
                  }
                  return AnnouncementWidget(
                    text: controller.announcement.value,
                  );
                },
              ),

              Container(
                height: Dimens.gap_dp1 * 78,
                margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.margin,
                ).copyWith(top: Dimens.gap_dp20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFE2E2),
                      Color(0xFFFFF4E1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(
                    Dimens.gap_dp10,
                  ),
                ),
                child: Row(
                  children: [
                    /// id、balance
                    SizedBox(
                      width: Dimens.gap_dp10 * 14,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () {
                                  return Text(
                                    'ID: ${controller.userInfo.value?.nickName}',
                                    style: TextStyle(
                                      fontSize: Dimens.font_sp12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  );
                                },
                              ),
                              Gaps.hGap8,
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(Dimens.gap_dp2),
                                  child: RHExtendedImage.asset(
                                    Images.iconCopy.assetName,
                                    width: Dimens.gap_dp14,
                                    height: Dimens.gap_dp14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                final balance = controller.gameBalance;
                                return Text(
                                  '¥ $balance',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: Dimens.font_sp1 * 15,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                );
                              }),
                              Gaps.hGap8,
                              GestureDetector(
                                onTap: () {
                                  controller.refreshGameBalance();
                                },
                                child: RotationTransition(
                                  turns: controller.animation,
                                  child: Padding(
                                    padding: EdgeInsets.all(Dimens.gap_dp2),
                                    child: RHExtendedImage.asset(
                                      Images.iconGameRefresh.assetName,
                                      width: Dimens.gap_dp18,
                                      height: Dimens.gap_dp18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMenuItem(
                            context,
                            Images.iconGameDeposit.assetName,
                            '存款',
                            () {
                              Get.toNamed(AppRouter.gameDeposit);
                            },
                          ),
                          _buildMenuItem(
                            context,
                            Images.iconGameWithdraw.assetName,
                            '取款',
                            () {
                              Get.toNamed(AppRouter.gameWithdrawal);
                            },
                          ),
                          _buildMenuItem(
                            context,
                            Images.iconGameDiscount.assetName,
                            '优惠',
                            () {
                              Get.toNamed(AppRouter.gameActivity);
                            },
                          ),
                          _buildMenuItem(
                            context,
                            Images.iconGameService.assetName,
                            '客服',
                            () {
                              String? url = controller
                                  .gameInfo.value?.customerService;
                              AppUtil.showCustomer(url);
                              // Get.toNamed(
                              //   AppRouter.webView,
                              //   parameters: ,
                              //   // arguments: WebModel(
                              //   //   url: controller
                              //   //           .gameInfo.value?.customerService ??
                              //   //       '',
                              //   // ),
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// 游戏菜单
              Expanded(
                child: GetBuilder<GamePageController>(
                  init: controller,
                  builder: (controller) {
                    return StateWidget(
                      state: controller.loadState.value,
                      onReload: controller.loadData,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: Dimens.gap_dp20,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: Dimens.gap_dp1 * 78,
                              color: const Color(0xFFFAF7F7),
                              child: GameClassifyListWidget(),
                            ),
                            Expanded(
                              child: GameClassifyItemListWidget(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Obx(
            () {
              final gameFloatingBanner =
                  controller.adsRsp.value?.gameFloatingBannerValue;
              if (null == gameFloatingBanner) {
                return Gaps.empty;
              }
              return DraggableButton(data: gameFloatingBanner);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String assetName,
    String text,
    Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RHExtendedImage.asset(
            assetName,
            width: Dimens.gap_dp36,
            height: Dimens.gap_dp36,
          ),
          Gaps.vGap2,
          Text(
            text,
            style: TextStyle(
              fontSize: Dimens.font_sp10,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
