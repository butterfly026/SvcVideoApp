
import 'package:flutter/foundation.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/repository/content/work_repository.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/modules/content/detail/work_detail_controller.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:get/get.dart';

abstract class VideoCallback{
   onDataLoaded(bool noData);
   onSwitchChapter(bool noData);
}

class VideoPlayController extends GetxController {
  VideoPlayController(this.callback);
  final VideoCallback callback;
  // late Callback callback;
  // void setCallback(Callback callback) {
  //   this.callback = callback;
  // }
  String? workId;
  late WorkDetailController workDetailController;

  void setWorController(WorkDetailController workDetailController) {
    this.workDetailController = workDetailController;
  }


  Future<void> loadData(String? workId) async {
    if (AppTool.isEmpty(workId)) {
      return;
    }
    this.workId = workId;
    var workInfo = await workDetailController.loadData(workId!, ContentEnum.video.type);
    callback.onDataLoaded(workInfo == null || workInfo.chapterList.isEmpty);
  }

  /// 切换选集
  Future<ChapterModel?> switchChapter(
      ChapterModel data) async {
    var chapter = await workDetailController.switchChapter(data);
    callback.onSwitchChapter(chapter == null);
    return chapter;
  }




}