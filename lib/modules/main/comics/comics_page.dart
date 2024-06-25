import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/search.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/enum/launch.dart';
import 'package:flutter_video_community/global/web/app_webview.dart';
import 'package:flutter_video_community/global/widgets/route_empty.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/modules/main/comics/comics_page_controller.dart';
import 'package:flutter_video_community/modules/main/comics/list/comics_classify_list.dart';
import 'package:flutter_video_community/modules/main/web/app/web_app_page.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/widgets/button/draggable.dart';
import 'package:flutter_video_community/widgets/keep_alive_widget.dart';
import 'package:flutter_video_community/widgets/search.dart';
import 'package:flutter_video_community/widgets/tab_bar.dart';
import 'package:get/get.dart';

/// 漫画
class ComicsPage extends StatefulWidget {
  const ComicsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ComicsPageState();
}

class _ComicsPageState extends State<ComicsPage> {
  final _controller = Get.put(ComicsPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GetBuilder<ComicsPageController>(
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
                          moduleType: ContentEnum.comic.type,
                        );
                        if (controller.tabDataList.isNotEmpty) {
                          final tabData = controller.tabDataList[index];
                          searchModel.appId = tabData.appId;
                        }
                        Get.toNamed(
                          AppRouter.comicsSearch,
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
                                              onTap: (index) {
                                                TabModel tabModel = controller.tabDataList[index];
                                                AppUtil.to(tabModel.address, tabModel.openWay);

                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: controller.tabDataList.map(
                                          (element) {
                                            String openWay = element.openWay;
                                            bool showRouteEmpty = (openWay == LaunchType.web.value || openWay == LaunchType.third.value);
                                            if (openWay ==
                                                LaunchType.hybrid.value) {
                                              return KeepAliveWidget(
                                                child: AppWebView(url: element.address),
                                              );
                                            }
                                            return KeepAliveWidget(
                                              child: showRouteEmpty ? RouteEmpty(route: element.address, openWay: element.openWay) : ComicsClassifyList(
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
              final cartoonFloatingBanner =
                  _controller.adsRsp.value?.cartoonFloatingBannerValue;
              if (null == cartoonFloatingBanner) {
                return Gaps.empty;
              }
              return DraggableButton(data: cartoonFloatingBanner);
            },
          ),
        ],
      ),
    );
  }
}
