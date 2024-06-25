import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/screen.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/image.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

import 'novel_read_controller.dart';

/// 小说阅读页
class NovelReadPage extends StatefulWidget {
  const NovelReadPage({super.key});

  @override
  State<StatefulWidget> createState() => _NovelReadPageState();
}

class _NovelReadPageState extends State<NovelReadPage> {
  final _controller = Get.put(NovelReadController());

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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Obx(
                        () {
                          /// 小说名称
                          return Text(
                            _controller.details?.workInfo.value?.title ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
                                  _controller.details?.switchChapterInDrawer(
                                    context, itemData
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
      body: GetBuilder<NovelReadController>(
        init: _controller,
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() {
                return CustomAppBar(
                  titleSpacing: 0,
                  title: Obx(
                    () {
                      return Text(
                        _controller.details?.workInfo.value?.title ?? '',
                        style: TextStyle(
                          color: _controller.dayTheme.value
                              ? const Color(0xFF2C2C2C)
                              : Theme.of(context).colorScheme.surface,
                        ),
                      );
                    },
                  ),
                  centerTitle: false,
                  backgroundColor: _controller.dayTheme.value
                      ? Theme.of(context).colorScheme.surface
                      : const Color(0xFF2C2C2C),
                  leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    splashRadius: Dimens.gap_dp20,
                    icon: Icon(
                      Icons.arrow_back,
                      color: _controller.dayTheme.value
                          ? const Color(0xFF2C2C2C)
                          : Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: Dimens.gap_dp12,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          openDrawer();
                        },
                        child: Container(
                          width: Dimens.gap_dp28,
                          height: Dimens.gap_dp28,
                          alignment: Alignment.center,
                          child: Image(
                            image: Images.iconComicsChapter,
                            width: Dimens.gap_dp22,
                            height: Dimens.gap_dp22,
                            color: _controller.dayTheme.value
                                ? const Color(0xFF2C2C2C)
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              Expanded(
                child: Obx(
                  () {
                    final currentChapter = _controller.details?.currentChapter;
                    final content = currentChapter?.value?.content;
                    debugPrint('content ==========> $content');
                    return Container(
                      color: _controller.dayTheme.value
                          ? Theme.of(context).colorScheme.surface
                          : Colors.black,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.margin,
                          ),
                          child: Text(
                            content ?? '',
                            style: TextStyle(
                              fontSize: Dimens.font_sp16,
                              color: _controller.dayTheme.value
                                  ? Colors.black
                                  : Colors.white,
                              height: 1.8,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Obx(
                () {
                  return Container(
                    height: Dimens.gap_dp52,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.margin,
                    ),
                    color: _controller.dayTheme.value
                        ? Theme.of(context).colorScheme.surface
                        : const Color(0xFF2C2C2C),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _controller.pre(context);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Gaps.hGap16,
                              RHExtendedImage.asset(
                                Images.iconArrowLeft.assetName,
                                width: Dimens.gap_dp24,
                                height: Dimens.gap_dp24,
                              ),
                              Text(
                                '上一章',
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RHExtendedImage.asset(
                                Images.iconArrowRight2.assetName,
                                width: Dimens.gap_dp24,
                                height: Dimens.gap_dp24,
                              ),
                              Text(
                                '下一章',
                                style: TextStyle(
                                  color: const Color(0xFF191D26),
                                  fontSize: Dimens.font_sp14,
                                ),
                              ),
                              Gaps.hGap32,
                            ],
                          ),
                        ),
                      ],
                    ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _controller.dayTheme.value =
                                !_controller.dayTheme.value;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image(
                                image: _controller.dayTheme.value
                                    ? Images.iconThemeLight
                                    : Images.iconThemeNight,
                                width: Dimens.gap_dp22,
                                height: Dimens.gap_dp22,
                              ),
                              Text(
                                _controller.dayTheme.value ? '日间' : '夜间',
                                style: TextStyle(
                                  fontSize: Dimens.font_sp14,
                                  fontWeight: FontWeight.bold,
                                  color: _controller.dayTheme.value
                                      ? const Color(0xFF191D26)
                                      : Colors.white,
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
            ],
          );
        },
      ),
    );
  }
}
