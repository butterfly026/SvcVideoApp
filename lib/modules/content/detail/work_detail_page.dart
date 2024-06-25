import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/event/purchase_occurred_event.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/modules/main/widgets/work_cat_list_item.dart';
import 'package:flutter_video_community/modules/main/widgets/work_chapter_item.dart';
import 'package:flutter_video_community/modules/content/detail/work_chapter_dialog.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/button/image.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import 'work_detail_controller.dart';

class WorkDetailPage extends StatefulWidget {
  const WorkDetailPage({super.key});

  @override
  State<StatefulWidget> createState() => _WorkDetailPageState();
}

class _WorkDetailPageState extends State<WorkDetailPage> {
  late WorkDetailController _controller;
  late final StreamSubscription purchaseOccurredSubscription;
  String? workId;
  String? workType;
  @override
  void initState() {
    super.initState();
    _controller = WorkDetailController();

    workId = Get.parameters['id'];
    workType = Get.parameters['type'];

    if (AppTool.isNotEmpty(workId)) {
      Get.put(_controller, tag: workId);
      _controller.loadData(workId, workType);
    }
    purchaseOccurredSubscription = eventBus.on<PurchaseOccurredEvent>().listen((event) {
      _controller.loadData(workId, workType);
    });
  }

  @override
  void dispose() {
    purchaseOccurredSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              height: Dimens.gap_dp10 * 20,
              child: RHExtendedImage.asset(
                // _controller.novelInfo.value?.pic ?? '',
                Images.imgLocalBanner.assetName,
                width: double.infinity,
                height: 200,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                splashRadius: Dimens.gap_dp20,
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
          Obx(
            () {
              return Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: Dimens.gap_dp1 * 108,
                  height: Dimens.gap_dp1 * 168,
                  margin: EdgeInsets.only(
                    top: Dimens.gap_dp10 * 12,
                    left: Dimens.gap_dp20,
                  ),
                  child: RHExtendedImage.network(
                    _controller.workInfo.value?.pic ?? '',
                    borderRadius: BorderRadius.circular(
                      Dimens.gap_dp8,
                    ),
                  ),
                ),
              );
            },
          ),
          Obx(
            () {
              bool favored = _controller.workInfo.value?.haveCollect ?? false;
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(
                    top: Dimens.gap_dp10 * 20,
                    left: Dimens.gap_dp1 * 128,
                  ),
                  height: Dimens.gap_dp1 * 88,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gaps.hGap10,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _controller.workInfo.value?.title ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimens.font_sp18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: Dimens.gap_dp6,
                            right: Dimens.gap_dp12,
                          ),
                          child:  Icon(
                            favored ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                            color: const Color(0xFFFF0000),
                            size: Dimens.gap_dp32,
                          ),
                        ),
                        onTap: () {
                          _controller.favorOrNot();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(
              top: Dimens.gap_dp10 * 29,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.margin,
                        ),
                        child: ReadMoreText(
                          _controller.workInfo.value?.des ?? '',
                          trimLines: 2,
                          colorClickableText: const Color(0xFFFF0000),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '查看更多',
                          trimExpandedText: '点击收起',
                          style: TextStyle(
                            height: 1.8,
                            fontSize: Dimens.font_sp14,
                            color: const Color(0xFF626773),
                          ),
                          moreStyle: TextStyle(
                            fontSize: Dimens.font_sp14,
                            color: const Color(0xFFFF0000),
                          ),
                        ),
                      );
                    },
                  ),
                  Obx(
                    () {
                      if (_controller.chapterList.isEmpty) {
                        return Gaps.empty;
                      }
                      final currentChapter = _controller.currentChapter.value;
                      debugPrint('currentChapter: ${currentChapter?.title}');
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Gaps.vGap12,
                          Row(
                            children: [
                              const Expanded(
                                child: SectionWidget(
                                  title: '选集',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (null != _controller.workInfo.value) {
                                    /// 查看选集
                                    WorkChapterDialog.show(
                                      context,
                                      _controller.workInfo.value!.id,
                                    );
                                  }
                                },
                                child: Text(
                                  '查看目录',
                                  style: TextStyle(
                                    fontSize: Dimens.font_sp14,
                                    color: const Color(0xFF626773),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dimens.gap_dp64,
                            child: ListView.builder(
                              itemCount: _controller.chapterList.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimens.gap_dp16,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final itemData = _controller.chapterList[index];
                                final selected = itemData.chapterId ==
                                    _controller.currentChapter.value?.chapterId;
                                debugPrint(
                                    'index: $index selected ======> $selected');
                                return Container(
                                  margin: EdgeInsets.only(
                                    right: Dimens.gap_dp6,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      /// 切换选集
                                      _controller.switchChapter(itemData);
                                    },
                                    child: WorkChapterItemWidget(
                                      data: itemData,
                                      workVip: _controller.workInfo.value?.vip ?? false,
                                      selected: selected,
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          GradientButton(
                            text: '开始阅读',
                            width: double.infinity,
                            height: Dimens.gap_dp52,
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppTheme.margin,
                            ).copyWith(top: Dimens.gap_dp16),
                            onTap: () {
                              /// 开始阅读
                              ClassifyContentModel? workInfo =  _controller.workInfo.value;
                              _controller.readChapterContent(workInfo, currentChapter);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  Obx(
                    () {
                      final recommendNovels = _controller.recommendList;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: Dimens.gap_dp10),
                            child: const SectionWidget(
                              title: '大家正在看',
                              more: false,
                            ),
                          ),
                          recommendNovels.isEmpty
                              ? const EmptyView()
                              : GridView.builder(
                                  shrinkWrap: true,
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: false,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.gap_dp16,
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.68,
                                        crossAxisSpacing: dPadding,
                                        mainAxisSpacing: dPadding

                                  ),
                                  itemCount: recommendNovels.length,
                                  itemBuilder: (context, index) {
                                    final itemData = recommendNovels[index];
                                    return GestureDetector(
                                        onTap: () {
                                          debugPrint("onClickRecommendItem->id=${itemData.id}, type=${itemData.type}");
                                          Get.toNamed(
                                            AppRouter.workDetail,
                                            parameters: {'id': itemData.id, 'type': itemData.type},
                                            preventDuplicates: false
                                          );
                                        },
                                        child: WorkCatItemWidget(data: itemData));
                                  },
                                ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
