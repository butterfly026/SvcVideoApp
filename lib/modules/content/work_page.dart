import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/search.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/enum/launch.dart';
import 'package:flutter_video_community/global/web/app_webview.dart';
import 'package:flutter_video_community/global/widgets/route_empty.dart';
import 'package:flutter_video_community/modules/content/work_logic.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/button/draggable.dart';
import 'package:flutter_video_community/widgets/keep_alive_widget.dart';
import 'package:flutter_video_community/widgets/search.dart';
import 'package:flutter_video_community/widgets/tab_bar.dart';
import 'package:get/get.dart';

import 'work_list.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({super.key, required this.type});

  final String type;

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  late final WorkLogic _workLogic;

  String? type;
  final TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (AppTool.isEmpty(widget.type)) {
      type = Get.parameters['type'];
    } else {
      type = widget.type;
    }
    _workLogic = Get.put(WorkLogic(), tag: type);
    _workLogic.init(type);
  }

  @override
  void dispose() {
    super.dispose();
    editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      AdsModel? floatingBanner = _workLogic.floatingAd.value;
      if (null == floatingBanner) {
        return Gaps.empty;
      }
      List<TabModel> tabList = _workLogic.tabList;

      return Stack(
        children: [
          DefaultTabController(
            length: tabList.length,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SearchWidget(
                    editingController: editingController,
                    onSubmitted: (value) {

                      Get.toNamed(
                        AppRouter.workSearch,
                        parameters: {'keyword': value, 'type': type ?? ''},
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: dPadding,
                    ).copyWith(right: Dimens.gap_dp16),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTabBar(
                            tabs: tabList
                                .map((element) =>
                                Tab(text: element.name))
                                .toList(),
                            isScrollable: true,
                            onTap: (index) {
                              TabModel tabModel = tabList[index];
                              AppUtil.to(tabModel.address, tabModel.openWay);

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
                                child: AppWebView(url: element.address),
                              );
                            }
                            return KeepAliveWidget(
                              child: showRouteEmpty ? RouteEmpty(route: element.address, openWay: element.openWay) : WorkList(
                                catId: element.id, type: type ?? '',
                              ),
                            );
                          }
                      )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DraggableButton(data: floatingBanner)
        ],
      );
    });
  }
}
