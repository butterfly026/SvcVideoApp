import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/search.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/enum/launch.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/modules/main/main_controller.dart';
import 'package:flutter_video_community/modules/main/web/app/web_app_page.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/widgets/button/draggable.dart';
import 'package:flutter_video_community/widgets/keep_alive_widget.dart';
import 'package:flutter_video_community/widgets/search.dart';
import 'package:flutter_video_community/widgets/tab_bar.dart';
import 'package:get/get.dart';

import 'list/tv_series_classify_list.dart';
import 'tv_series_controller.dart';

/// 影视剧集
class TvSeriesPage extends StatefulWidget {
  const TvSeriesPage({super.key});

  @override
  State<StatefulWidget> createState() => _TvSeriesPageState();
}

class _TvSeriesPageState extends State<TvSeriesPage> {
  final _controller = Get.put(TvSeriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GetBuilder<TvSeriesController>(
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
                        final index = controller.tabController?.index ?? 0;
                        final searchModel = SearchModel(
                          keywords: value,
                          moduleType: ContentEnum.tv.type,
                        );
                        if (controller.tabDataList.isNotEmpty) {
                          final tabData = controller.tabDataList[index];
                          searchModel.appId = tabData.appId;
                        }
                        Get.toNamed(
                          AppRouter.tvSeriesSearch,
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
                                                  .map((element) =>
                                                      Tab(text: element.name))
                                                  .toList(),
                                              isScrollable: true,
                                            ),
                                          ),
                                          Builder(
                                            builder: (context) {
                                              final tabController =
                                                  DefaultTabController.of(
                                                      context);
                                              controller.initTabController(
                                                tabController,
                                              );
                                              return Gaps.empty;
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
                                                LaunchType.web.value) {
                                              return KeepAliveWidget(
                                                child: WebAppPage(
                                                  data: element.toWebData(),
                                                ),
                                              );
                                            }
                                            return KeepAliveWidget(
                                              child: TvSeriesClassifyList(
                                                tabData: element,
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
              final tvFloatingBanner =
                  _controller.adsRsp.value?.tvFloatingBannerValue;
              if (null == tvFloatingBanner) {
                return Gaps.empty;
              }
              return DraggableButton(data: tvFloatingBanner);
            },
          ),
        ],
      ),
    );
  }
}
