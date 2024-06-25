import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/widgets/empty_refresh_view.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/global/widgets/video_list_item.dart';
import 'package:flutter_video_community/modules/main/widgets/announcement_widget.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/banner.dart';
import 'package:get/get.dart';

import 'live_list_controller.dart';

class LiveList extends StatefulWidget {
  const LiveList({
    super.key,
    required this.catId,
  });

  final String catId;

  @override
  State<StatefulWidget> createState() => LiveListState();
}

class LiveListState extends State<LiveList> {
  late LiveListController controller;

  @override
  void initState() {
    super.initState();
    if (AppTool.isNotEmpty(widget.catId)) {
      controller = Get.put(LiveListController(), tag: widget.catId);
      controller.init(widget.catId);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            /// banner
            if (controller.adsList.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.margin,
                ).copyWith(bottom: Dimens.gap_dp12),
                child: CustomBanner(
                  list: controller.adsList,
                  onTap: (index) {},
                ),
              ),

            /// 公告
            if (controller.announcement.value.isNotEmpty)
              AnnouncementWidget(
                text: controller.announcement.value,
              ),
            Expanded(
              child: controller.dataList.isEmpty ?  EmptyRefreshView(onRefresh: (){
                controller.loadData();

                // Get.toNamed(
                //   AppRouter.liveRoom,
                //   parameters: {'url' : 'dsa'},
                // );
              },) : EasyRefresh(
                onRefresh: () async {
                  controller.loadData();
                },
                onLoad: () async {
                  controller.loadMore();
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(
                    AppTheme.margin,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: dPadding,
                    mainAxisSpacing: dPadding,
                  ),
                  itemCount: controller.dataList.length,
                  itemBuilder: (context, index) {
                    final itemData = controller.dataList[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRouter.liveRoom,
                          parameters: {'url' : itemData.address},
                        );
                      },
                      child: VideoListItem(
                        cover: itemData.img,
                        title: itemData.title,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
