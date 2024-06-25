import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/widgets/refresh_view.dart';
import 'package:flutter_video_community/modules/main/video/classify/video_classify_list_controller.dart';
import 'package:flutter_video_community/global/widgets/video_list_item.dart';
import 'package:flutter_video_community/modules/main/widgets/invite_friend_banner.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/widgets/banner.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class VideoClassifyList extends StatefulWidget {
  const VideoClassifyList({
    super.key,
    required this.tabData,
    this.first = false,
    this.adsModel,
  });

  final TabModel tabData;
  final bool first;
  final AdsModel? adsModel;

  @override
  State<StatefulWidget> createState() => _VideoClassifyListState();
}

class _VideoClassifyListState extends State<VideoClassifyList> {
  late VideoClassifyListController listController;
  late RefreshController refreshController;

  String get tag => null != widget.adsModel
      ? '${widget.adsModel?.appId}_${widget.tabData.name}'
      : widget.tabData.name;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    listController = VideoClassifyListController(
      adsModel: widget.adsModel,
    );
    Get.put(listController, tag: tag);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        listController.load(
          widget.tabData,
          refreshController,
          first: widget.first,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = VideoClassifyListController.to(tag);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<VideoClassifyListController>(
        tag: tag,
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
                first: widget.first,
              );
            },
            body: GridView.custom(
              scrollDirection: Axis.vertical,
              reverse: false,
              cacheExtent: 100,
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
                  } else if (videoItem.equityBanner &&
                      videoItem.newUserEquityTime > 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp6),
                      child: Obx(
                        () {
                          final newUserEquityTime =
                              GlobalController.to.newUserEquityTime.value;
                          return InviteFriendBanner(
                            duration: Duration(
                              seconds: newUserEquityTime,
                            ),
                          );
                        },
                      ),
                    );
                  } else if (null != videoItem.miniBanner) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.gap_dp6,
                      ).copyWith(
                        bottom: Dimens.gap_dp12,
                        top: (widget.first && videoItem.newUserEquityTime > 0)
                            ? 0
                            : Dimens.gap_dp12,
                      ),
                      child: CustomBanner(
                        list: videoItem.miniBanner!,
                        onTap: (index) {},
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
                          parameters: {'title': '更多视频', 'catId': sectionData.id},
                        );
                      },
                    );
                  } else if (null != videoItem.contentHorizontal) {
                    final item = videoItem.contentHorizontal!;
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRouter.videoPlayer, arguments: item);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimens.gap_dp6,
                        ),
                        child: VideoListItem(cover: item.pic, title: item.title,),
                      ),
                    );
                  } else if (null != videoItem.content) {
                    final item = videoItem.content!;
                    return GestureDetector(
                      onTap: () {
                        navToVideoPlayer(item);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimens.gap_dp6,
                        ),
                        child: VideoListItem(cover: item.pic, title: item.title),
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

  Future<void> navToVideoPlayer(ClassifyContentModel data) async {
    Get.toNamed(AppRouter.videoPlayer, arguments: data)?.then((value) {
      if (null != value && value is ClassifyContentModel) {
        navToVideoPlayer(value);
      }
    });
  }
}
