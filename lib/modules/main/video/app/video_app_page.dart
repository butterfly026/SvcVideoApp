import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/search.dart';
import 'package:flutter_video_community/global/enum/launch.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/modules/main/home/video_classify_dialog.dart';
import 'package:flutter_video_community/modules/main/video/app/video_app_controller.dart';
import 'package:flutter_video_community/modules/main/video/classify/video_classify_list.dart';
import 'package:flutter_video_community/modules/main/web/app/web_app_page.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/screen.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/keep_alive_widget.dart';
import 'package:flutter_video_community/widgets/search.dart';
import 'package:flutter_video_community/widgets/tab_bar.dart';
import 'package:get/get.dart';

/// 视频应用页
class VideoAppPage extends StatefulWidget {
  const VideoAppPage({super.key});

  @override
  State<StatefulWidget> createState() => _VideoAppPageState();
}

class _VideoAppPageState extends State<VideoAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF9F5F5),
      body: Stack(
        children: [
          RHExtendedImage.asset(
            Images.imgBgHeader.assetName,
            width: double.infinity,
            height: Dimens.gap_dp1 * 375,
            fit: BoxFit.fill,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Dimens.gap_dp1 * 375,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: Screen.statusBar,
              ),
              Expanded(
                child: GetBuilder<VideoAppController>(
                  init: VideoAppController(),
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
                              final index =
                                  controller.tabController?.index ?? 0;
                              final searchModel = SearchModel(keywords: value);
                              if (controller.tabDataList.isNotEmpty) {
                                final tabData = controller.tabDataList[index];
                                searchModel.appId = tabData.appId;
                              }
                              Get.toNamed(
                                AppRouter.videoSearch,
                                arguments: searchModel,
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
                                                        .map((element) => Tab(
                                                            text: element.name))
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
                                                    controller
                                                        .initTabController(
                                                      tabController,
                                                    );
                                                    return GestureDetector(
                                                      onTap: () {
                                                        VideoClassifyDialog
                                                            .show(
                                                          context,
                                                          index: tabController
                                                              .index,
                                                          adsModel: controller
                                                              .adsModel,
                                                          callback: (index) {
                                                            tabController
                                                                .animateTo(
                                                              index,
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child:
                                                          RHExtendedImage.asset(
                                                        Images.iconTabBarMenu
                                                            .assetName,
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
                                              children:
                                                  controller.tabDataList.map(
                                                (element) {
                                                  if (element.openWay ==
                                                      LaunchType.web.value) {
                                                    return WebAppPage(
                                                      data: element.toWebData(),
                                                    );
                                                  }
                                                  return KeepAliveWidget(
                                                    child: VideoClassifyList(
                                                      tabData: element,
                                                      first: controller
                                                              .tabDataList
                                                              .indexOf(
                                                                  element) ==
                                                          0,
                                                      adsModel:
                                                          controller.adsModel,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
