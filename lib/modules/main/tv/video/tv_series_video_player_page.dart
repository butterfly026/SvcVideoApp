// import 'package:flutter/material.dart';
// import 'package:flutter_video_community/config/dimens.dart';
// import 'package:flutter_video_community/config/gaps.dart';
// import 'package:flutter_video_community/config/images.dart';
// import 'package:flutter_video_community/global/controller/global_controller.dart';
// import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
// import 'package:flutter_video_community/modules/main/tv/widget/video_anthology_item.dart';
// import 'package:flutter_video_community/modules/main/video/player/video_player_controller.dart';
// import 'package:flutter_video_community/modules/main/video/widgets/custom_video_player.dart';
// import 'package:flutter_video_community/global/widgets/video_list_item.dart';
// import 'package:flutter_video_community/modules/main/widgets/app_item_widget.dart';
// import 'package:flutter_video_community/themes/theme.dart';
// import 'package:flutter_video_community/widgets/app_bar.dart';
// import 'package:flutter_video_community/widgets/banner.dart';
// import 'package:flutter_video_community/widgets/image.dart';
// import 'package:flutter_video_community/widgets/layout/rh_state.dart';
// import 'package:flutter_video_community/widgets/section.dart';
// import 'package:get/get.dart';
//
// /// 影视剧集视频播放
// class TvSeriesVideoPlayerPage extends StatefulWidget {
//   const TvSeriesVideoPlayerPage({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _TvSeriesVideoPlayerPageState();
// }
//
// class _TvSeriesVideoPlayerPageState extends RhState<TvSeriesVideoPlayerPage> {
//  // final _controller = Get.put(VideoPlayerController());
//
//   @override
//   void onResumed() {
//     super.onResumed();
//     _controller.player.start();
//     debugPrint('video details page onResumed');
//   }
//
//   @override
//   void onPaused() {
//     super.onPaused();
//     _controller.player.pause();
//     debugPrint('video details page onPaused');
//   }
//
//   @override
//   void dispose() {
//     _controller.player.release();
//     super.dispose();
//     debugPrint('video details page dispose -----------');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         toolbarHeight: 0,
//         backgroundColor: Colors.black,
//         automaticallyImplyLeading: false,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//        //   CustomVideoPlayer(),
//           Expanded(
//             child: CustomScrollView(
//               slivers: [
//                 Obx(() {
//                   final title = _controller.currentChapter.value?.title;
//                   return SliverPadding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: AppTheme.margin,
//                     ).copyWith(top: Dimens.gap_dp20),
//                     sliver: SliverToBoxAdapter(
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               title ?? '',
//                               textAlign: TextAlign.start,
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18,
//                                 fontFamily: 'PingFang SC',
//                                 fontWeight: FontWeight.w600,
//                                 height: 0,
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               /// todo 收藏、取消收藏
//                             },
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 RHExtendedImage.asset(
//                                   Images.iconCollection.assetName,
//                                   width: Dimens.gap_dp18,
//                                   height: Dimens.gap_dp18,
//                                 ),
//                                 Gaps.hGap4,
//                                 Text(
//                                   '收藏',
//                                   style: TextStyle(
//                                     fontSize: Dimens.font_sp14,
//                                     color: const Color(0xFF965100),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//                 Obx(
//                   () {
//                     final desc = _controller.videoInfo.value?.des;
//                     if (null == desc || desc.isEmpty) {
//                       return const SliverToBoxAdapter();
//                     }
//                     return SliverPadding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: AppTheme.margin,
//                       ).copyWith(top: Dimens.gap_dp10),
//                       sliver: SliverToBoxAdapter(
//                         child: Text(
//                           desc,
//                           maxLines: 2,
//                           style: const TextStyle(
//                             color: Color(0xFF626773),
//                             fontSize: 12,
//                             fontFamily: 'PingFang SC',
//                             fontWeight: FontWeight.w400,
//                             height: 1.5,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 Obx(
//                   () {
//                     if (_controller.chapterList.isEmpty) {
//                       return const SliverToBoxAdapter();
//                     }
//                     final currentChapter = _controller.currentChapter.value;
//                     debugPrint('currentChapter: ${currentChapter?.title}');
//                     return SliverPadding(
//                       padding: EdgeInsets.only(top: Dimens.gap_dp10),
//                       sliver: SliverToBoxAdapter(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             SectionWidget(
//                               title: '选集',
//                               value: '全 ${_controller.chapterList.length} 话',
//                             ),
//                             SizedBox(
//                               height: Dimens.gap_dp64,
//                               child: ListView.builder(
//                                 itemCount: _controller.chapterList.length,
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: Dimens.gap_dp16,
//                                 ),
//                                 scrollDirection: Axis.horizontal,
//                                 itemBuilder: (context, index) {
//                                   final itemData =
//                                       _controller.chapterList[index];
//                                   final selected = itemData.chapterId ==
//                                       _controller
//                                           .currentChapter.value?.chapterId;
//                                   debugPrint(
//                                       'index: $index selected ======> $selected');
//                                   return Container(
//                                     margin: EdgeInsets.only(
//                                       right: Dimens.gap_dp6,
//                                     ),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         _controller.switchAnthology(itemData);
//                                       },
//                                       child: VideoAnthologyItemWidget(
//                                         data: itemData,
//                                         selected: selected,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 Obx(
//                   () {
//                     final videoContentAdsList = _controller.videoContentAdsList;
//                     final isEmpty = videoContentAdsList.isEmpty;
//                     if (isEmpty) {
//                       return const SliverToBoxAdapter();
//                     }
//                     return SliverPadding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: AppTheme.margin,
//                       ).copyWith(top: Dimens.gap_dp10),
//                       sliver: SliverToBoxAdapter(
//                         child: CustomBanner(
//                           list: videoContentAdsList,
//                           height: Dimens.gap_dp100,
//                           onTap: (index) {},
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 Obx(
//                   () {
//                     final videoPlayAppList = _controller.videoPlayAppList;
//                     final isEmpty = videoPlayAppList.isEmpty;
//                     if (isEmpty) {
//                       return const SliverToBoxAdapter();
//                     }
//                     return SliverPadding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: AppTheme.margin,
//                       ).copyWith(top: Dimens.gap_dp10),
//                       sliver: SliverToBoxAdapter(
//                         child: Container(
//                           constraints: BoxConstraints(
//                             minHeight: Dimens.gap_dp100,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.4),
//                                 blurRadius: 1,
//                               ),
//                             ],
//                             borderRadius: BorderRadius.circular(Dimens.gap_dp4),
//                           ),
//                           child: GridView.builder(
//                             shrinkWrap: true,
//                             padding: EdgeInsets.only(
//                               top: Dimens.gap_dp12,
//                               bottom: Dimens.gap_dp8,
//                             ),
//                             physics: const NeverScrollableScrollPhysics(),
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 4,
//                               mainAxisSpacing: Dimens.gap_dp10,
//                               childAspectRatio: 1.1,
//                             ),
//                             itemCount: videoPlayAppList.length,
//                             itemBuilder: (context, index) {
//                               return GestureDetector(
//                                 onTap: () {
//                                   GlobalController.to.launch(
//                                     videoPlayAppList[index],
//                                   );
//                                 },
//                                 child: AppItemWidget(
//                                   data: videoPlayAppList[index],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 Obx(
//                   () {
//                     final recommendVideos = _controller.recommendVideoList;
//                     return SliverToBoxAdapter(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(top: Dimens.gap_dp10),
//                             child: const SectionWidget(
//                               title: '推荐',
//                               more: false,
//                             ),
//                           ),
//                           recommendVideos.isEmpty
//                               ? const EmptyView()
//                               : GridView.builder(
//                                   shrinkWrap: true,
//                                   addAutomaticKeepAlives: false,
//                                   addRepaintBoundaries: false,
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: Dimens.gap_dp16,
//                                   ),
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     crossAxisSpacing: Dimens.gap_dp10,
//                                   ),
//                                   itemCount:
//                                       _controller.recommendVideoList.length,
//                                   itemBuilder: (context, index) {
//                                     final itemData =
//                                         _controller.recommendVideoList[index];
//                                     return VideoListItem(cover: itemData.pic, title: itemData.title);
//                                   },
//                                 ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
