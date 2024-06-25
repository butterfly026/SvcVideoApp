import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/event/city_changed_event.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/widgets/refresh_view.dart';
import 'package:flutter_video_community/modules/main/community/hall/hall_page_controller.dart';
import 'package:flutter_video_community/modules/main/community/widgets/release_post_button.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:get/get.dart';

import 'hall_list_item.dart';

/// 楼凤大厅
class HallPage extends StatefulWidget {
  const HallPage({
    super.key,
    required this.tabData,
  });

  final TabModel tabData;
  @override
  State<StatefulWidget> createState() => _HallPageState();
}

class _HallPageState extends State<HallPage> {
  final _controller = Get.put(HallPageController());
  late final StreamSubscription cityChangedSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.load(widget.tabData);
    });
    cityChangedSubscription = eventBus.on<CityChangedEvent>().listen((event) {
      _controller.load(widget.tabData);
    });

  }

  @override
  void dispose() {
    cityChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: ReleasePostButton(
        type: widget.tabData.type,
      ),
      body: GetBuilder<HallPageController>(
        init: _controller,
        builder: (controller) {
          return RefreshView(
            loadState: controller.loadState.value,
            refreshController: controller.refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoadMore,
            onReload: () {
              _controller.load(widget.tabData);
            },
            body: ListView.builder(
              itemCount: controller.dataList.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final itemData = controller.dataList[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRouter.communityDetails,
                      parameters: {'id': itemData.id},
                    );
                  },
                  child: HallListItem(data: itemData),
                );
              },
            ),
          );
        },
      ),
    );
  }

}
