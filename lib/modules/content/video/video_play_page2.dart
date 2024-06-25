// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_video_community/config/dimens.dart';
// import 'package:flutter_video_community/config/gaps.dart';
// import 'package:flutter_video_community/data/models/main/ads.dart';
// import 'package:flutter_video_community/data/models/main/classify_content.dart';
// import 'package:flutter_video_community/global/controller/global_controller.dart';
// import 'package:flutter_video_community/global/enum/classify.dart';
// import 'package:flutter_video_community/global/widgets/HeaderWidget.dart';
// import 'package:flutter_video_community/modules/content/detail/work_detail_controller.dart';
// import 'package:flutter_video_community/modules/content/video/video_play_controller.dart';
// import 'package:flutter_video_community/modules/content/detail/work_chapter_dialog.dart';
// import 'package:flutter_video_community/modules/main/video/widgets/ijk_panel.dart';
// import 'package:flutter_video_community/modules/main/widgets/app_item_widget.dart';
// import 'package:flutter_video_community/modules/main/widgets/work_chapter_item.dart';
// import 'package:flutter_video_community/utils/app_tool.dart';
// import 'package:flutter_video_community/utils/screen.dart';
// import 'package:flutter_video_community/widgets/banner.dart';
// import 'package:flutter_video_community/widgets/image.dart';
// import 'package:get/get.dart';
// import 'package:readmore/readmore.dart';
// import 'package:video_player/video_player.dart';
//
// import 'video_list_2col_item.dart';
//
// class VideoPlayPage2 extends StatefulWidget {
//   const VideoPlayPage2({super.key});
//
//   @override
//   State<VideoPlayPage2> createState() => _VideoPlayPageState();
// }
//
// class _VideoPlayPageState extends State<VideoPlayPage2>
//     implements VideoCallback {
//  // final FijkPlayer player = FijkPlayer();
//   String? workId;
//   late VideoPlayController playLogic;
//   String? playUrl;
//   late WorkDetailController workDetailController;
//   static const double padding = 15;
//   VideoPlayerController? _playerController;
//   @override
//   void initState() {
//     super.initState();
//     playLogic = VideoPlayController(this);
//     workId = Get.parameters['id'];
//     workDetailController = Get.put(WorkDetailController(), tag: ContentEnum.video.type);
//
//     if (AppTool.isNotEmpty(workId)) {
//       playLogic.setWorController(workDetailController);
//       playLogic.loadData(workId);
//     }
//
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     // player.release();
//     if (_playerController != null) {
//       _playerController!.dispose();
//     }
//   }
//
//   @override
//   onDataLoaded() {
//     ChapterModel? videoChapter = workDetailController.currentChapter.value;
//     if (videoChapter != null && AppTool.isNotEmpty(videoChapter.content)) {
//          playUrl = videoChapter.content;
//
//       // setState(() {
//       //   playUrl = videoChapter.content;
//       //   player.setDataSource(playUrl!, autoPlay: true);
//       // });
//       _playerController = VideoPlayerController.networkUrl(Uri.parse(
//           playUrl!))
//         ..initialize().then((_) {
//           debugPrint('video player init');
//           // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//           setState(() {
//           });
//           _playerController?.play();
//         }).onError((error, stackTrace) {
//           debugPrint('video player error---1---err=$error');
//
//         });
//
//     }
//   }
//
//
//   @override
//   onSwitchChapter() async {
//     ChapterModel? videoChapter = workDetailController.currentChapter.value;
//     if (videoChapter != null && AppTool.isNotEmpty(videoChapter.content)) {
//       playUrl = videoChapter.content;
//       workDetailController.readChapterContent();
//
//
//       // try{
//       //   await player.reset();
//       //   player.setDataSource(playUrl!, autoPlay: false, showCover: false);
//       // }catch(err) {
//       //   debugPrint("onSwitchChapter-player err=>$err");
//       // }
//
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final adsRsp = GlobalController.to.adsRsp.value;
//       // AdsModel? videoAds = adsRsp?.videoPlayAdsValue;
//       // List<AdsModel>? videoPlayAppList = adsRsp?.videoPlayAppList ?? [];
//       // List<AdsModel>? videoContentAdsList =
//       //     adsRsp?.videoPlayContentAdsList ?? [];
//       //
//       // ChapterModel? curChapter = workDetailController.currentChapter.value;
//       // ClassifyContentModel? workInfo = workDetailController.workInfo.value;
//       // List<ChapterModel> chapterList = workDetailController.chapterList;
//       // List<ClassifyContentModel> recommendList =
//       //     workDetailController.recommendList;
//       // final title = curChapter?.title;
//       // final desc = workInfo?.des;
//       return Scaffold(
//         backgroundColor: Colors.white,
//         body: Column(
//           children: [
//             // AppTool.isNotEmpty(playUrl)
//             //     ? FijkView(
//             //         width: Screen.width,
//             //         height: Screen.height * 0.4,
//             //         player: player,
//             //         color: Colors.black,
//             //         panelBuilder: fijkPanelBuilder,
//             //         cover: RHExtendedImage.network(
//             //           width: double.infinity,
//             //           height: double.infinity,
//             //           workInfo?.pic ?? '',
//             //         ).image,
//             //       )
//             //     : Gaps.empty,
//             _playerController != null && _playerController!.value.isInitialized ? AspectRatio(
//                 aspectRatio: _playerController!.value.aspectRatio,
//                  child: VideoPlayer(_playerController!),) : Container(),
//             // Expanded(
//             //     child: Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: padding),
//             //   child: CustomScrollView(
//             //     slivers: [
//             //       if (AppTool.isNotEmpty(title))
//             //         SliverPadding(
//             //           padding: const EdgeInsets.only(top: 20),
//             //           sliver: SliverToBoxAdapter(
//             //             child: Text(
//             //               title!,
//             //               textAlign: TextAlign.start,
//             //               maxLines: 2,
//             //               style: const TextStyle(
//             //                 color: Colors.black,
//             //                 fontSize: 18,
//             //                 fontFamily: 'PingFang SC',
//             //                 fontWeight: FontWeight.bold,
//             //                 height: 0,
//             //               ),
//             //             ),
//             //           ),
//             //         ),
//             //       if (AppTool.isNotEmpty(desc))
//             //         SliverPadding(
//             //           padding: const EdgeInsets.only(top: padding),
//             //           sliver: SliverToBoxAdapter(
//             //               child: ReadMoreText(
//             //             desc!,
//             //             trimLines: 2,
//             //             colorClickableText: const Color(0xFFFF0000),
//             //             trimMode: TrimMode.Line,
//             //             trimCollapsedText: '查看更多',
//             //             trimExpandedText: '点击收起',
//             //             style: TextStyle(
//             //               height: 1.8,
//             //               fontSize: Dimens.font_sp14,
//             //               color: const Color(0xFF626773),
//             //             ),
//             //             moreStyle: TextStyle(
//             //               fontSize: Dimens.font_sp14,
//             //               color: const Color(0xFFFF0000),
//             //             ),
//             //           )),
//             //         ),
//             //       if (videoContentAdsList.isNotEmpty)
//             //         SliverPadding(
//             //           padding: const EdgeInsets.only(top: padding),
//             //           sliver: SliverToBoxAdapter(
//             //             child: CustomBanner(
//             //               list: videoContentAdsList,
//             //               height: Dimens.gap_dp100,
//             //             ),
//             //           ),
//             //         ),
//             //       if (videoPlayAppList.isNotEmpty)
//             //         SliverPadding(
//             //           padding: EdgeInsets.only(top: padding / 2),
//             //           sliver: SliverGrid(
//             //             gridDelegate:
//             //                 const SliverGridDelegateWithFixedCrossAxisCount(
//             //               crossAxisCount: 4,
//             //               childAspectRatio: 0.71,
//             //               mainAxisSpacing: padding,
//             //               crossAxisSpacing: padding,
//             //             ),
//             //             delegate: SliverChildBuilderDelegate((context, index) {
//             //               return GestureDetector(
//             //                 onTap: () {
//             //                   GlobalController.to.launch(
//             //                     videoPlayAppList[index],
//             //                   );
//             //                 },
//             //                 child: AppItemWidget(
//             //                   data: videoPlayAppList[index],
//             //                 ),
//             //               );
//             //             }, childCount: videoPlayAppList.length),
//             //           ),
//             //         ),
//             //       if (chapterList.isNotEmpty)
//             //         SliverToBoxAdapter(
//             //           child: Column(
//             //             mainAxisSize: MainAxisSize.min,
//             //             children: [
//             //               Gaps.vGap12,
//             //               Row(
//             //                 children: [
//             //                    Expanded(
//             //                     child: HeaderWidget(
//             //                       title: '选集',
//             //                     ),
//             //                   ),
//             //                   TextButton(
//             //                     onPressed: () {
//             //                       if (null != workInfo) {
//             //                         /// 查看选集
//             //                         WorkChapterDialog.show(
//             //                           context,
//             //                           ContentEnum.video.type,
//             //                           btnText: '开始观看'
//             //                         );
//             //                       }
//             //                     },
//             //                     child: Text(
//             //                       '查看目录',
//             //                       style: TextStyle(
//             //                         fontSize: Dimens.font_sp14,
//             //                         color: const Color(0xFF626773),
//             //                       ),
//             //                     ),
//             //                   ),
//             //                 ],
//             //               ),
//             //               SizedBox(
//             //                 height: Dimens.gap_dp64,
//             //                 child: ListView.builder(
//             //                   itemCount: chapterList.length,
//             //
//             //                   scrollDirection: Axis.horizontal,
//             //                   itemBuilder: (context, index) {
//             //                     final itemData = chapterList[index];
//             //                     final selected =
//             //                         itemData.chapterId == curChapter?.chapterId;
//             //                     debugPrint(
//             //                         'index: $index selected ======> $selected');
//             //                     return Container(
//             //                       margin: EdgeInsets.only(
//             //                         right: Dimens.gap_dp6,
//             //                       ),
//             //                       child: GestureDetector(
//             //                         onTap: () {
//             //                           /// 切换选集
//             //                           playLogic
//             //                               .switchChapter(itemData);
//             //                         },
//             //                         child: WorkChapterItemWidget(
//             //                           data: itemData,
//             //                           workVip: workInfo?.vip ?? false,
//             //                           selected: selected,
//             //                         ),
//             //                       ),
//             //                     );
//             //                   },
//             //                 ),
//             //               ),
//             //             ],
//             //           ),
//             //         ),
//             //       if (recommendList.isNotEmpty)
//             //          SliverPadding(
//             //            padding: EdgeInsets.only(top: padding),
//             //            sliver: SliverToBoxAdapter(
//             //             child: HeaderWidget(
//             //               title: '推荐',
//             //               more: false,
//             //             ),
//             //                                ),
//             //          ),
//             //       if (recommendList.isNotEmpty)
//             //         SliverPadding(
//             //           padding: const EdgeInsets.only(top: padding, bottom: padding * 2),
//             //           sliver: SliverGrid(
//             //             gridDelegate:
//             //                 const SliverGridDelegateWithFixedCrossAxisCount(
//             //               crossAxisCount: 2,
//             //               childAspectRatio: 1.4,
//             //               mainAxisSpacing: padding,
//             //               crossAxisSpacing: padding,
//             //             ),
//             //             delegate: SliverChildBuilderDelegate((context, index) {
//             //               final itemData = recommendList[index];
//             //               return GestureDetector(
//             //                 onTap: () => () {},
//             //                 child: VideoList2ColItem(
//             //                   video: itemData,
//             //                 ),
//             //               );
//             //             }, childCount: recommendList.length),
//             //           ),
//             //         ),
//             //     ],
//             //   ),
//             // ))
//           ],
//         ),
//       );
//     });
//   }
// }
