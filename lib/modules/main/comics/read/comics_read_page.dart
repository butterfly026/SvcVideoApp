import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/screen.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/image.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

import 'comics_read_controller.dart';

/// 漫画阅读页
class ComicsReadPage extends StatefulWidget {
  const ComicsReadPage({super.key});

  @override
  State<StatefulWidget> createState() => _ComicsReadPageState();
}

class _ComicsReadPageState extends State<ComicsReadPage> {
  final _controller = Get.put(ComicsReadController());
  final ScrollController listViewController = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.closeEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        titleSpacing: 0,
        title: Obx(
          () {
            return Text(
              _controller.details?.workInfo.value?.title ?? '',
            );
          },
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: Dimens.gap_dp12,
            ),
            child: ImageButton(
              assetName: Images.iconComicsChapter.assetName,
              imageSize: Dimens.gap_dp22,
              onTap: () {
                /// show drawer
                openDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  closeDrawer();
                },
                child: Gaps.empty,
              ),
            ),
            Container(
              width: Screen.width / 2,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Screen.statusBar,
                  ),
                  SizedBox(
                    height: kToolbarHeight,
                    child: Center(
                      child: Obx(
                        () {
                          /// 漫画名称
                          return Text(
                            _controller.details?.workInfo.value?.title ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimens.font_sp16,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () {
                      final list = _controller.chapterList;
                      return Container(
                        height: Dimens.gap_dp38,
                        color: const Color(0xFFFFF3E8),
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimens.gap_dp10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '共${list.length}章',
                                style: TextStyle(
                                  fontSize: Dimens.font_sp14,
                                  color: const Color(0xFFFB6621),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _controller.reverse();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RHExtendedImage.asset(
                                    Images.iconSort.assetName,
                                    width: Dimens.gap_dp16,
                                    height: Dimens.gap_dp16,
                                  ),
                                  Gaps.hGap2,
                                  Text(
                                    '倒叙',
                                    style: TextStyle(
                                      fontSize: Dimens.font_sp14,
                                      color: const Color(0xFFFB6621),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Obx(
                      () {
                        final dataList = _controller.chapterList;
                        final currentChapter =
                            _controller.details?.currentChapter;
                        debugPrint(
                            'currentChapter ======> ${currentChapter?.value?.number}');
                        debugPrint(
                            'reversed ======> ${_controller.reversed.value}');
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            final itemData = dataList[index];
                            final selected = itemData.chapterId ==
                                currentChapter?.value?.chapterId;
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  _controller.details?.switchChapterInDrawer(context,
                                    itemData,
                                  );
                                  closeDrawer();
                                },
                                child: Container(
                                  height: Dimens.gap_dp52,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.gap_dp12,
                                  ),
                                  child: Text(
                                    '${itemData.number}-${itemData.number}',
                                    style: TextStyle(
                                      fontSize: Dimens.font_sp14,
                                      color: selected
                                          ? const Color(0xFF191D26)
                                          : const Color(0xFF626773),
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Obx(
              () {
                final currentChapter = _controller.details?.currentChapter;
                final content = currentChapter?.value?.content;
                if (null == content || content.isEmpty) {
                  return Gaps.empty;
                }
                final dataList = content.split(',');
                return ListView.builder(
                  controller: listViewController,
                  padding: EdgeInsets.zero,
                  addRepaintBoundaries: false,
                  addAutomaticKeepAlives: false,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return RHExtendedImage.network(
                      dataList[index],
                      // AppConfig.randomImage(),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            height: Dimens.gap_dp52,
            margin: const EdgeInsets.symmetric(
              horizontal: AppTheme.margin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.pre(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RHExtendedImage.asset(
                        Images.iconArrowLeft.assetName,
                        width: Dimens.gap_dp24,
                        height: Dimens.gap_dp24,
                      ),
                      Text(
                        '上一话',
                        style: TextStyle(
                          color: const Color(0xFF191D26),
                          fontSize: Dimens.font_sp14,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _controller.next(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RHExtendedImage.asset(
                        Images.iconArrowRight2.assetName,
                        width: Dimens.gap_dp24,
                        height: Dimens.gap_dp24,
                      ),
                      Text(
                        '下一话',
                        style: TextStyle(
                          color: const Color(0xFF191D26),
                          fontSize: Dimens.font_sp14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
