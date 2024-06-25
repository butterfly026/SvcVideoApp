import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/widgets/refresh_view.dart';
import 'package:flutter_video_community/modules/main/widgets/work_cat_list_item.dart';
import 'package:flutter_video_community/modules/main/comics/list/comics_classify_list_controller.dart';
import 'package:flutter_video_community/modules/main/comics/list/comics_list_item.dart';
import 'package:flutter_video_community/modules/main/widgets/announcement_widget.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/widgets/banner.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ComicsClassifyList extends StatefulWidget {
  const ComicsClassifyList({
    super.key,
    required this.tabData,
  });

  final TabModel tabData;

  @override
  State<StatefulWidget> createState() => _ComicsClassifyListState();
}

class _ComicsClassifyListState extends State<ComicsClassifyList> {
  late ComicsClassifyListController listController;
  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    listController = ComicsClassifyListController();
    Get.put(
      listController,
      tag: widget.tabData.name,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listController.load(
        widget.tabData,
        refreshController,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ComicsClassifyListController.to(widget.tabData.name);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<ComicsClassifyListController>(
        tag: widget.tabData.name,
        init: controller,
        builder: (controller) {
          return RefreshView(
            loadState: controller.loadState.value,
            refreshController: refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoadMore,
            onReload: () {
              controller.load(
                widget.tabData,
                refreshController,
              );
            },
            body: GridView.custom(
              scrollDirection: Axis.vertical,
              reverse: false,
              gridDelegate: SliverStairedGridDelegate(
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                pattern: controller.patternList,
                startCrossAxisDirectionReversed: true,
              ),
              padding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp6),
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  final gridTile = controller.patternList[index];
                  final videoItem = controller.dataList[index];
                  if (null != videoItem.banner) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.gap_dp6,
                      ).copyWith(top: Dimens.gap_dp6),
                      child: CustomBanner(
                        list: videoItem.banner!,
                      ),
                    );
                  } else if (null != videoItem.announcement) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: Dimens.gap_dp12,
                      ),
                      child: AnnouncementWidget(
                        text: videoItem.announcement!,
                      ),
                    );
                  } else if (null != videoItem.sectionData) {
                    final sectionData = videoItem.sectionData!;
                    return SectionWidget(
                      title: sectionData.name,
                      more: true,
                      padding: EdgeInsets.zero,
                      onTap: () {
                        Get.toNamed(
                          AppRouter.workMore,
                          parameters: {'title': '更多漫画', 'catId': sectionData.id},
                        );
                      },
                    );
                  } else if (null != videoItem.content) {
                    final item = videoItem.content!;
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRouter.workDetail,
                          parameters: {'id': videoItem.content!.id, 'type': videoItem.content!.type},
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimens.gap_dp6,
                        ),
                        child: WorkCatItemWidget(data: item),
                      ),
                    );
                  } else {
                    return Gaps.empty;
                  }
                },
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                childCount: controller.dataList.length,
              ),
            ),
          );
        },
      ),
    );
  }
}
