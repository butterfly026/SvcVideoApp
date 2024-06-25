import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/widgets/refresh_view.dart';
import 'package:flutter_video_community/modules/main/widgets/announcement_widget.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/widgets/banner.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'tv_series_list_item.dart';
import 'tv_series_classify_list_controller.dart';

class TvSeriesClassifyList extends StatefulWidget {
  const TvSeriesClassifyList({
    super.key,
    required this.tabData,
  });

  final TabModel tabData;

  @override
  State<StatefulWidget> createState() => _TvSeriesClassifyListState();
}

class _TvSeriesClassifyListState extends State<TvSeriesClassifyList> {
  late TvSeriesClassifyListController listController;
  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    listController = TvSeriesClassifyListController(
      widget.tabData,
      refreshController,
    );
    Get.put(
      listController,
      tag: widget.tabData.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = TvSeriesClassifyListController.to(widget.tabData.name);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<TvSeriesClassifyListController>(
        tag: widget.tabData.name,
        init: controller,
        builder: (controller) {
          return RefreshView(
            loadState: controller.loadState.value,
            refreshController: refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoadMore,
            onReload: controller.load,
            body: GridView.custom(
              scrollDirection: Axis.vertical,
              reverse: false,
              gridDelegate: SliverStairedGridDelegate(
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                pattern: controller.patternList,
                startCrossAxisDirectionReversed: true,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.gap_dp6,
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  final classifyContentItem = controller.dataList[index];
                  if (null != classifyContentItem.banner) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.gap_dp6,
                      ).copyWith(top: Dimens.gap_dp6),
                      child: CustomBanner(
                        list: classifyContentItem.banner!,
                        onTap: (index) {},
                      ),
                    );
                  } else if (null != classifyContentItem.announcement) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: Dimens.gap_dp12,
                      ),
                      child: AnnouncementWidget(
                        text: classifyContentItem.announcement!,
                      ),
                    );
                  } else if (null != classifyContentItem.sectionData) {
                    final sectionData = classifyContentItem.sectionData!;
                    return SectionWidget(
                      title: sectionData.name,
                      more: true,
                      padding: EdgeInsets.zero,
                      onTap: () {
                        Get.toNamed(
                          AppRouter.workMore,
                          parameters: {'title': '更多剧集', 'catId': sectionData.id},
                        );
                      },
                    );
                  } else if (null != classifyContentItem.content) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimens.gap_dp4,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRouter.tvSeriesVideoPlayer,
                            arguments: classifyContentItem.content!,
                          );
                        },
                        child: SeriesListItemWidget(
                          data: classifyContentItem.content!,
                        ),
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
