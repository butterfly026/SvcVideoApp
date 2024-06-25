import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/live/live_cat.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/enum/launch.dart';
import 'package:flutter_video_community/global/web/app_webview.dart';
import 'package:flutter_video_community/global/widgets/route_empty.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/modules/live/live_controller.dart';
import 'package:flutter_video_community/modules/live/live_list.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/widgets/button/draggable.dart';
import 'package:flutter_video_community/widgets/keep_alive_widget.dart';
import 'package:flutter_video_community/widgets/tab_bar.dart';
import 'package:get/get.dart';


/// 直播列表
class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  final _controller = Get.put(LiveController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<LiveCatModel> tabList = _controller.tabList;

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            DefaultTabController(
              length: tabList.length,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: dPadding,
                    ).copyWith(right: Dimens.gap_dp16),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTabBar(
                            tabs: tabList
                                .map((element) =>
                                Tab(text: element.title))
                                .toList(),
                            isScrollable: true,
                            onTap: (index) {
                              LiveCatModel tabModel = tabList[index];
                              AppUtil.to(tabModel.url, tabModel.openWay);

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: tabList
                          .map(
                            (element)  {
                              String openWay = element.openWay;
                              bool showRouteEmpty = (openWay == LaunchType.web.value || openWay == LaunchType.third.value);
                              if (openWay ==
                                  LaunchType.hybrid.value) {
                                return KeepAliveWidget(
                                  child: AppWebView(url: element.url),
                                );
                              }
                              return KeepAliveWidget(
                                child: showRouteEmpty ? RouteEmpty(route: element.url, openWay: element.openWay) : LiveList(
                                  catId: element.id,
                                ),
                              );
                              return KeepAliveWidget(child: LiveList(catId: element.id,));
                            }
                      )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
                  () {
                final liveFloatingBanner =
                    _controller.adsRsp.value?.liveFloatingBannerValue;
                if (null == liveFloatingBanner) {
                  return Gaps.empty;
                }
                return DraggableButton(data: liveFloatingBanner);
              },
            ),
          ],
        ),
      );
    });
  }
}
