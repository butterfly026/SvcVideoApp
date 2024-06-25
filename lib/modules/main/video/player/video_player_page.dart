// import 'package:flutter/material.dart';
// import 'package:flutter_video_community/config/dimens.dart';
// import 'package:flutter_video_community/global/controller/global_controller.dart';
// import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
// import 'package:flutter_video_community/modules/main/video/player/video_player_controller.dart';
// import 'package:flutter_video_community/modules/main/video/widgets/custom_video_player.dart';
// import 'package:flutter_video_community/global/widgets/video_list_item.dart';
// import 'package:flutter_video_community/modules/main/widgets/app_item_widget.dart';
// import 'package:flutter_video_community/router/router.dart';
// import 'package:flutter_video_community/themes/theme.dart';
// import 'package:flutter_video_community/widgets/app_bar.dart';
// import 'package:flutter_video_community/widgets/banner.dart';
// import 'package:flutter_video_community/widgets/layout/rh_state.dart';
// import 'package:flutter_video_community/widgets/section.dart';
// import 'package:get/get.dart';
// import 'package:readmore/readmore.dart';
//
// class VideoPlayerPage extends StatefulWidget {
//   const VideoPlayerPage({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _VideoPlayerPageState();
// }
//
// class _VideoPlayerPageState extends RhState<VideoPlayerPage> with RouteAware {
//   final _controller = Get.put(VideoPlayerController());
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     AppRouter.routeObservers.subscribe(
//       this,
//       ModalRoute.of(context)!,
//     );
//   }
//
//   @override
//   void didPop() {
//     super.didPop();
//     debugPrint('video details page didPop');
//   }
//
//   /// 从其他页面返回时调用
//   @override
//   void didPopNext() {
//     super.didPopNext();
//     _controller.player.start();
//     debugPrint('video details page didPopNext');
//   }
//
//   @override
//   void didPush() {
//     super.didPush();
//     debugPrint('video details page didPush');
//   }
//
//   /// 跳转到其他页面回调
//   @override
//   void didPushNext() {
//     super.didPushNext();
//     _controller.player.pause();
//     debugPrint('video details page didPushNext');
//   }
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
//   void dispose() async {
//     AppRouter.routeObservers.unsubscribe(this);
//     WidgetsBinding.instance.removeObserver(this);
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
//           CustomVideoPlayer(),
//           Expanded(
//             child: CustomScrollView(
//               slivers: [
//                 Obx(
//                   () {
//                     final title = _controller.currentChapter.value?.title;
//                     if (null == title || title.isEmpty) {
//                       return const SliverToBoxAdapter();
//                     }
//                     return SliverPadding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: AppTheme.margin,
//                       ).copyWith(top: Dimens.gap_dp20),
//                       sliver: SliverToBoxAdapter(
//                         child: Text(
//                           title,
//                           textAlign: TextAlign.start,
//                           maxLines: 2,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontFamily: 'PingFang SC',
//                             fontWeight: FontWeight.bold,
//                             height: 0,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
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
//                         child: ReadMoreText(
//                           desc,
//                           trimLines: 2,
//                           colorClickableText: const Color(0xFFFF0000),
//                           trimMode: TrimMode.Line,
//                           trimCollapsedText: '查看更多',
//                           trimExpandedText: '点击收起',
//                           style: TextStyle(
//                             height: 1.8,
//                             fontSize: Dimens.font_sp14,
//                             color: const Color(0xFF626773),
//                           ),
//                           moreStyle: TextStyle(
//                             fontSize: Dimens.font_sp14,
//                             color: const Color(0xFFFF0000),
//                           ),
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
//                               bottom: Dimens.gap_dp4,
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
//                                     return GestureDetector(
//                                       onTap: () async {
//                                         // await _controller.player.release();
//                                         // Get.back(result: itemData);
//                                         _controller.switchVideo(itemData);
//                                       },
//                                       child: VideoListItem(cover: itemData.pic, title: itemData.title),
//                                     );
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
