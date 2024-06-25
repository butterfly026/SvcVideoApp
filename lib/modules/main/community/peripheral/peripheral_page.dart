import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/widgets/refresh_view.dart';
import 'package:flutter_video_community/modules/main/community/widgets/release_post_button.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:get/get.dart';

import '../../../../data/event/city_changed_event.dart';
import 'peripheral_list_item.dart';
import 'peripheral_page_controller.dart';

/// 认证外围
class PeripheralPage extends StatefulWidget {
  const PeripheralPage({
    super.key,
    required this.tabData,
  });

  final TabModel tabData;

  @override
  State<StatefulWidget> createState() => _PeripheralPageState();
}

class _PeripheralPageState extends State<PeripheralPage> {
  final _controller = Get.put(PeripheralPageController());
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
      body: GetBuilder<PeripheralPageController>(
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
            body: GridView.builder(
              itemCount: controller.dataList.length,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.margin,
              ).copyWith(top: Dimens.gap_dp10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Dimens.gap_dp6,
                crossAxisSpacing: Dimens.gap_dp12,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                final itemData = controller.dataList[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRouter.communityDetails,
                      parameters: {'id': itemData.id},
                    );
                  },
                  child: PeripheralListItem(data: itemData),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
