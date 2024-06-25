
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/repository/content/work_repository.dart';
import 'package:flutter_video_community/data/repository/favor/favor_repository.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

//作品详情页, 现指小说,漫画的通用模块
class WorkDetailController extends GetxController {
  static WorkDetailController to(String tag) => Get.find(tag: tag);

  Rx<ClassifyContentModel?> workInfo = Rx(null);
  //Rx<ChapterModel?> novelChapterInfo = Rx(null);
  RxList<ClassifyContentModel> recommendList = RxList();

  RxList<ChapterModel> chapterList = RxList();

  /// 当前章节
  Rx<ChapterModel?> currentChapter = Rx(null);

  WorkRepository get _repository => Global.getIt<WorkRepository>();
  FavorRepository get _favorRepository => Global.getIt<FavorRepository>();
  String? workId;
  String? workType;


  @override
  void onReady() {
    super.onReady();
  }

  void loadDataByDefault() async {
    if (AppTool.isNotEmpty(workId) && AppTool.isNotEmpty(workType)) {
      loadData(workId!, workType!);
    }
  }

  Future<ClassifyContentModel?> loadData(String? workId, String? workType) async {
    if (AppTool.isEmpty(workId) || AppTool.isEmpty(workType)) {
      return null;
    }
    this.workId = workId;
    this.workType = workType;
    var workInfo = await getWorkInfo(workId!);
    if (workInfo != null) {
      getRecommendWorkList();
    }
    return workInfo;
  }

  Future<void> favorOrNot() async{
    if (workInfo.value == null) {
      return;
    }
    bool favored = workInfo.value?.haveCollect ?? false;
    ClassifyContentModel contentModel = workInfo.value!;

    if (favored) {
      await _favorRepository.cancelFavor(contentModel.id).then((value) =>
      {showToast("已取消收藏")});
    } else {
      await _favorRepository.favor(contentModel.id, contentModel.title
          , contentModel.pic, contentModel.type).then((value) => {
        showToast('收藏成功')
      });
    }
    loadDataByDefault();

  }


  //getWorkInfo返回的chapterList的auth字段不准确,需要拿到chapterId再去请求getChapterInfo接口
  Future<ClassifyContentModel?> getWorkInfo(String workId) async {
    try {
      final dataMap = <String, dynamic>{
        'workId': workId,
      };
      ClassifyContentModel? value = await _repository.getWorkInfo(dataMap);
      if (value == null) {
        workInfo.value = null;
        chapterList.value = [];
        currentChapter.value = null;
        return null;
      }
      workInfo.value = value;
      chapterList.value = value.chapterList;
      if (chapterList.isNotEmpty) {
        if (currentChapter.value == null) {
          //默认选第一章节
          chapterList.first.selected = true;
          ChapterModel? chapterModel = await _repository.getChapterInfo(chapterList.first.chapterId);
          if (chapterModel != null) {
            currentChapter.value = chapterModel;
          }
        } else {
          currentChapter.value  = await _repository.getChapterInfo(currentChapter.value!.chapterId);
        }
      }
      return value;
    } catch (error) {
      /// void
       return null;
    }
  }


  //内容阅读页的drawer切换章节
  Future<void> switchChapterInDrawer(BuildContext context, ChapterModel chapter) async{

     LoadingDialog.show(context);
     //getWorkInfo返回的chapterList的auth字段不准确,需要拿到chapterId再去请求getChapterInfo接口
     ChapterModel? chapterModel = await _repository.getChapterInfo(chapter.chapterId);
     LoadingDialog.dismiss();
     if (chapterModel == null) {
       return;
     }
     debugPrint("switch chapter in drawer-> auth=${chapterModel.auth} name=${chapterModel.title}");
     if (chapterModel.auth) {
       currentChapter.value = chapterModel;
       update();
     } else {
       AppUtil.verifyChapterContent(workInfo.value, chapterModel, () {
         currentChapter.value = chapterModel;
       });
     }
  }

  /// 切换选集
  Future<ChapterModel?> switchChapter(
      ChapterModel data) async {
    ChapterModel? chapter = await _repository.getChapterInfo(data.chapterId);
    if (chapter != null) {
      currentChapter.value = chapter;
      debugPrint("switch chapter-> auth=${chapter.auth} name=${chapter.title}");
      update();
      return chapter;
    }
    return null;
  }


  Future<void> getRecommendWorkList() async {
    if (workInfo.value?.id == null) {
      return;
    }
    try {
      final dataMap = <String, dynamic>{
        'id': workInfo.value?.id,
        'moduleType': workInfo.value?.type,
        'appId': Cache.getInstance().mainApp?.id,
      };
      final value = await _repository.getRecommendWorkList(dataMap);
      recommendList.value = value;
    } catch (error) {
      /// void
    }
  }

  //开始阅读
  Future<void> readChapterContent(ClassifyContentModel? workInfo, ChapterModel? chapter, {Function? canWatchCb, Function? noAccessCb}) async {
    ClassifyContentModel? tmpWorkInfo = workInfo;
    if (tmpWorkInfo == null) {
      return;
    }
    ChapterModel? curChapter = chapter;
    AppUtil.verifyChapterContent(tmpWorkInfo, curChapter, () {
      AppUtil.toChapterContentPage(tmpWorkInfo);
      if(tmpWorkInfo.type == ContentEnum.video.type) {
        if(canWatchCb != null) {
          canWatchCb();
        }
      }
    });
  }
}
