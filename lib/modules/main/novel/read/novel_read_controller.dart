import 'package:flutter/cupertino.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/modules/content/detail/work_detail_controller.dart';
import 'package:get/get.dart';

class NovelReadController extends GetxController {
  static NovelReadController get to => Get.find();

  RxBool reversed = RxBool(false);
  RxList<ChapterModel> chapterList = RxList();

  WorkDetailController? details;

  final Map<String, int> indexDataMap = <String, int>{};

  final RxBool dayTheme = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (null != arguments && arguments is ClassifyContentModel) {
      details = WorkDetailController.to(arguments.id);
      chapterList.addAll(details!.chapterList);
      int index = 0;
      for (final item in chapterList) {
        indexDataMap[item.chapterId] = index;
        index++;
      }
    }
  }

  Future<void> reverse() async {
    reversed.value = !reversed.value;
    if (reversed.value) {
      chapterList.sort((a, b) => b.number.compareTo(a.number));
    } else {
      chapterList.sort((a, b) => a.number.compareTo(b.number));
    }
  }

  Future<void> pre(BuildContext context) async {
    final currentChapter = details?.currentChapter.value;
    if (null != currentChapter) {
      final index = indexDataMap[currentChapter.chapterId] ?? 0;
      if (index > 0) {
        details?.switchChapterInDrawer(
            context, chapterList[index - 1]
        );
      }
      debugPrint('pre index ==========> $index');
    }
  }

  Future<void> next(BuildContext context) async {
    final currentChapter = details?.currentChapter.value;
    if (null != currentChapter) {
      final index = indexDataMap[currentChapter.chapterId] ?? 0;
      if (index < chapterList.length) {
        details?.switchChapterInDrawer(
          context, chapterList[index + 1],
        );
      }
      debugPrint('next index ==========> $index');
    }
  }

  Future<void> switchTheme() async {
    dayTheme.value = dayTheme.value;
    update();
  }

}
