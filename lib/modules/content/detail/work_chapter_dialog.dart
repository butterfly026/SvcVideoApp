import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/modules/main/widgets/work_chapter_item.dart';
import 'package:flutter_video_community/modules/content/detail/work_detail_controller.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:get/get.dart';

class WorkChapterDialog extends StatelessWidget {
  const WorkChapterDialog({
    super.key,
    required this.workId, required this.btnText,
  });

  final String workId;
  final String btnText;

  static Future<void> show(
    BuildContext context,
    String workId, {String btnText = '开始阅读'}
  ) async {
    SmartDialog.show(
      tag: 'WorkChapterDialog',
      builder: (_) {
        return WorkChapterDialog(
          workId: workId,
          btnText: btnText,
        );
      },
      alignment: Alignment.bottomCenter,
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(
      tag: 'WorkChapterDialog',
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = WorkDetailController.to(workId);
    return Container(
      width: double.infinity,
      height: Dimens.gap_dp10 * 42,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Dimens.gap_dp10,
          ),
        ),
      ),
      child: Column(
        children: [
          Gaps.vGap10,
          SectionWidget(
            title: '选集',
            style: TextStyle(
              fontSize: Dimens.font_sp18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Obx(
              () {
                final currentChapter = controller.currentChapter.value;
                debugPrint('currentChapter: ${currentChapter?.title}');
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.margin,
                  ),
                  itemCount: controller.chapterList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.6,
                    mainAxisSpacing: Dimens.gap_dp10,
                    crossAxisSpacing: Dimens.gap_dp10,
                  ),
                  itemBuilder: (context, index) {
                    final itemData = controller.chapterList[index];
                    final selected = itemData.chapterId ==
                        controller.currentChapter.value?.chapterId;
                    return GestureDetector(
                      onTap: () {
                        controller.switchChapter(itemData);
                      },
                      child: WorkChapterItemWidget(
                        data: itemData,
                        workVip: controller.workInfo.value?.vip ?? false,
                        selected: selected,
                        index: index,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          GradientButton(
            text: btnText,
            width: double.infinity,
            height: Dimens.gap_dp52,
            margin: const EdgeInsets.symmetric(
              horizontal: AppTheme.margin,
            ).copyWith(
              top: Dimens.gap_dp16,
              bottom: Dimens.gap_dp10,
            ),
            onTap: () {
              /// 开始阅读
              dismiss();
              ClassifyContentModel? workInfo =  controller.workInfo.value;
              final curChapter = controller.currentChapter.value;

              controller.readChapterContent(workInfo, curChapter);

            },
          ),
        ],
      ),
    );
  }
}
