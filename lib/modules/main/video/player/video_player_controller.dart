// import 'dart:async';
//
// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_video_community/data/models/main/ads.dart';
// import 'package:flutter_video_community/data/models/main/classify_content.dart';
// import 'package:flutter_video_community/data/repository/content/work_repository.dart';
// import 'package:flutter_video_community/data/repository/main/main_repository.dart';
// import 'package:flutter_video_community/global/controller/global_controller.dart';
// import 'package:flutter_video_community/global/global.dart';
// import 'package:flutter_video_community/utils/app.dart';
// import 'package:flutter_video_community/utils/cache.dart';
// import 'package:get/get.dart';
//
// class VideoPlayerController extends GetxController {
//   static VideoPlayerController get to => Get.find();
//
//
//   final FijkPlayer player = FijkPlayer();
//
//   Rx<ClassifyContentModel?> videoInfo = Rx(null);
//   Rx<ChapterModel?> videoChapterInfo = Rx(null);
//   RxList<ClassifyContentModel> recommendVideoList = RxList();
//
//   /// 广告
//   Rx<AdsModel?> videoAds = Rx(null);
//
//   /// 播放页横幅广告
//   RxList<AdsModel> videoContentAdsList = RxList();
//
//   /// 播放页图标
//   RxList<AdsModel> videoPlayAppList = RxList();
//
//   RxBool showVipVideoTip = RxBool(false);
//   RxBool showPayCoinTip = RxBool(false);
//
//   RxList<ChapterModel> chapterList = RxList();
//
//   /// 当前播放选集
//   Rx<ChapterModel?> currentChapter = Rx(null);
//
//   StreamSubscription? currentPosSubs;
//
//   WorkRepository get _repository => Global.getIt<WorkRepository>();
//
//   MainRepository get _mainRepository => null == Get.context
//       ? MainRepository()
//       : RepositoryProvider.of<MainRepository>(Get.context!);
//
//   /// 当前播放选集信息
//   ChapterModel? get currentVideoInfo => currentChapter.value;
//
//   @override
//   void onReady() {
//     super.onReady();
//     final arguments = Get.arguments;
//     if (null != arguments && arguments is ClassifyContentModel) {
//       videoInfo.value = arguments;
//     }
//
//     final adsRsp = GlobalController.to.adsRsp.value;
//     videoAds.value = adsRsp?.videoPlayAdsValue;
//     videoPlayAppList.value = adsRsp?.videoPlayAppList ?? [];
//     videoContentAdsList.value = adsRsp?.videoPlayContentAdsList ?? [];
//
//     getVideoInfo();
//     getRecommendVideo();
//   }
//
//   Future<void> getVideoInfo() async {
//     try {
//       final dataMap = <String, dynamic>{
//         'workId': videoInfo.value?.id,
//       };
//       final value = await _repository.getWorkInfo(dataMap);
//       videoInfo.value = value;
//       videoChapterInfo.value = value.firstChapter;
//
//       chapterList.value = value.chapterList;
//       if (value.chapterList.isNotEmpty) {
//         value.chapterList.first.selected = true;
//         await getChapterInfo(value.chapterList.first);
//       }
//     } catch (error) {
//       /// void
//     }
//   }
//
//   Future<void> getChapterInfo(
//     ChapterModel chapterModel,
//   ) async {
//     try {
//       final value = await _repository.getChapterInfo(
//         chapterModel.chapterId,
//       );
//       videoChapterInfo.value = value;
//       currentChapter.value = value;
//     } catch (error) {
//       /// void
//       videoChapterInfo.value = chapterModel;
//       currentChapter.value = chapterModel;
//     }
//     await _initPlayer();
//   }
//
//   Future<void> getRecommendVideo() async {
//     try {
//       final dataMap = <String, dynamic>{
//         'id': videoInfo.value?.id,
//         'moduleType': 'video',
//         'appId': Cache.getInstance().mainApp?.id,
//       };
//       final value = await _repository.getRecommendWorkList(dataMap);
//       recommendVideoList.value = value;
//     } catch (error) {
//       /// void
//     }
//   }
//
//   Future<void> _initPlayer() async {
//     if (null == currentVideoInfo) {
//       return;
//     }
//
//     final videoUrl = currentVideoInfo!.content;
//     await player.setDataSource(
//       // 'https://sample-videos.com/video123/flv/240/big_buck_bunny_240p_10mb.flv',
//       videoUrl,
//     );
//     int freeTime = Cache.getInstance().mainApp?.freeTime ?? 0;
//     currentPosSubs?.cancel();
//     currentPosSubs = player.onCurrentPosUpdate.listen((event) {
//       debugPrint('video current pos ======> ${event.inSeconds}');
//       if (event.inSeconds >= freeTime) {
//         player.pause();
//         if (currentVideoInfo!.price > 0) {
//           showPayCoinTip.value = true;
//           showVipVideoTip.value = false;
//         } else if (currentVideoInfo!.vip) {
//           if (!AppUtil.isVip()) {
//             showPayCoinTip.value = false;
//             showVipVideoTip.value = true;
//           }
//         }
//       }
//     });
//     // if (currentVideoInfo?.auth == false) {
//     //
//     // }
//     // final freeTime = Cache.getInstance().mainApp?.freeTime ?? 0;
//   }
//
//   /// 切换选集播放
//   Future<void> switchAnthology(
//     ChapterModel data,
//   ) async {
//     videoChapterInfo.value = data;
//     currentChapter.value = data;
//     update();
//
//     await player.reset();
//     // await player.setDataSource(
//     //   dataList[Random().nextInt(dataList.length)],
//     // );
//     await getChapterInfo(data);
//     player.start();
//   }
//
//   Future<void> videoAdsCompleted() async {
//     videoAds.value = null;
//
//     if (null == videoInfo.value || null == currentChapter.value) {
//       await getVideoInfo();
//     }
//
//     if (currentVideoInfo?.auth == true) {
//       player.start();
//     } else {
//       /// void
//     }
//   }
//
//   Future<void> switchVideo(
//     ClassifyContentModel data,
//   ) async {
//     await player.reset();
//
//     videoInfo.value = data;
//
//     final adsRsp = GlobalController.to.adsRsp.value;
//     videoAds.value = adsRsp?.videoPlayAdsValue;
//     videoPlayAppList.value = adsRsp?.videoPlayAppList ?? [];
//     videoContentAdsList.value = adsRsp?.videoPlayContentAdsList ?? [];
//
//     await getVideoInfo();
//
//     player.start();
//     // getRecommendVideo();
//   }
//
//   Future<void> unlockVideo() async {
//     if (null == currentVideoInfo) {
//       return;
//     }
//     try {
//       final dataMap = <String, dynamic>{
//         'coins': currentVideoInfo!.price,
//         'busType': 'video',
//         'busId': currentVideoInfo!.chapterId,
//         'busName': '解锁视频:${currentVideoInfo!.title}',
//       };
//       _mainRepository.buy(dataMap);
//     } catch (error) {
//       /// void
//     }
//   }
//
//   @override
//   void onClose() async {
//     await player.release();
//     currentPosSubs?.cancel();
//     super.onClose();
//   }
// }
