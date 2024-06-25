import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/search.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/enum/launch.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/modules/content/video/video_list.dart';
import 'package:flutter_video_community/modules/main/home/home_page_controller.dart';
import 'package:flutter_video_community/modules/main/main_controller.dart';
import 'package:flutter_video_community/modules/main/video/classify/video_classify_list.dart';
import 'package:flutter_video_community/modules/main/web/app/web_app_page.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/widgets/button/draggable.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/keep_alive_widget.dart';
import 'package:flutter_video_community/widgets/search.dart';
import 'package:flutter_video_community/widgets/tab_bar.dart';
import 'package:get/get.dart';

import 'video_classify_dialog.dart';

/// 首页 主要是 视频
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GetBuilder<HomePageController>(
            init: _controller,
            builder: (controller) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => controller.hideKeyboard(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SearchWidget(
                      editingController: controller.editingController,
                      onSubmitted: (value) {
                        Get.toNamed(
                          AppRouter.workSearch,
                          parameters: {'keyword': value, 'type':  ContentEnum.video.type},
                        );
                      },
                    ),
                    Expanded(
                      child: StateWidget(
                        state: controller.loadState.value,
                        onReload: () => controller.reload(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: DefaultTabController(
                                length: controller.tabDataList.length,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: Dimens.gap_dp10,
                                      ).copyWith(right: Dimens.gap_dp16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CustomTabBar(
                                              tabs: controller.tabDataList
                                                  .map((element) =>
                                                      Tab(text: element.name))
                                                  .toList(),
                                              isScrollable: true,
                                            ),
                                          ),
                                          Gaps.hGap16,
                                          Builder(
                                            builder: (context) {
                                              final tabController =
                                                  DefaultTabController.of(
                                                context,
                                              );
                                              controller.initTabController(
                                                tabController,
                                              );
                                              return GestureDetector(
                                                onTap: () {
                                                  VideoClassifyDialog.show(
                                                      context,
                                                      index:
                                                          tabController.index,
                                                      callback: (index) {
                                                    tabController
                                                        .animateTo(index);
                                                  });
                                                },
                                                child: RHExtendedImage.asset(
                                                  Images
                                                      .iconTabBarMenu.assetName,
                                                  width: Dimens.gap_dp16,
                                                  height: Dimens.gap_dp16,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: controller.tabDataList.map(
                                          (element) {
                                            if (element.openWay ==
                                                LaunchType.hybrid.value) {
                                              return KeepAliveWidget(
                                                child: WebAppPage(
                                                  data: element.toWebData(),
                                                ),
                                              );
                                            }
                                            return KeepAliveWidget(
                                              child: VideoList(
                                                tabData: element,
                                                first: controller.tabDataList
                                                        .indexOf(element) ==
                                                    0,
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Obx(
            () {
              final homeFloatingBanner =
                  _controller.adsRsp.value?.homeFloatingBannerValue;
              if (null == homeFloatingBanner) {
                return Gaps.empty;
              }
              return DraggableButton(data: homeFloatingBanner);
            },
          ),
        ],
      ),
    );
  }
}
