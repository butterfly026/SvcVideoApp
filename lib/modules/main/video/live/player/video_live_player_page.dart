// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_video_community/config/config.dart';
// import 'package:flutter_video_community/config/dimens.dart';
// import 'package:flutter_video_community/config/images.dart';
// import 'package:flutter_video_community/modules/main/video/live/widgets/live_broadcase_user_info.dart';
// import 'package:flutter_video_community/modules/main/video/live/widgets/trial_time_widget.dart';
// import 'package:flutter_video_community/modules/main/video/widgets/ijk_panel.dart';
// import 'package:flutter_video_community/themes/theme.dart';
// import 'package:flutter_video_community/widgets/image.dart';
// import 'package:flutter_video_community/widgets/layout/rh_state.dart';
// import 'package:get/get.dart';
//
// import 'video_live_player_controller.dart';
//
// /// 直播
// class VideoLivePlayerPage extends StatefulWidget {
//   const VideoLivePlayerPage({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _VideoLivePlayerPageState();
// }
//
// class _VideoLivePlayerPageState extends RhState<VideoLivePlayerPage> {
//   final _controller = Get.put(VideoLivePlayerController());
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
//       body: Stack(
//         children: [
//           Align(
//             child: Obx(
//               () {
//                 return FijkView(
//                   width: double.infinity,
//                   height: double.infinity,
//                   color: Colors.black,
//                   player: _controller.player,
//                   fit: FijkFit.fill,
//                   panelBuilder: (
//                     FijkPlayer player,
//                     FijkData data,
//                     BuildContext context,
//                     Size viewSize,
//                     Rect texturePos,
//                   ) {
//                     return DefaultFijkPanel(
//                       player: player,
//                       buildContext: context,
//                       viewSize: viewSize,
//                       texturePos: texturePos,
//                       isLive: true,
//                     );
//                   },
//                   cover: RHExtendedImage.network(
//                     _controller.videoData.value?.pic ?? '',
//                     width: double.infinity,
//                     height: double.infinity,
//                   ).image,
//                 );
//               },
//             ),
//           ),
//           Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               margin: const EdgeInsets.symmetric(
//                 horizontal: AppTheme.margin,
//               ).copyWith(top: Dimens.gap_dp48),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   LiveBroadcastUserInfo(),
//                   GestureDetector(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: RHExtendedImage.asset(
//                       Images.iconCloseVideoLive.assetName,
//                       width: Dimens.gap_dp34,
//                       height: Dimens.gap_dp34,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Container(
//               margin: EdgeInsets.symmetric(
//                 horizontal: Dimens.gap_dp24,
//               ).copyWith(top: Dimens.gap_dp1 * 114),
//               child: TrialTimeWidget(),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: Container(
//               width: Dimens.gap_dp1 * 204,
//               margin: EdgeInsets.symmetric(
//                 horizontal: Dimens.gap_dp12,
//               ).copyWith(bottom: Dimens.gap_dp24),
//               decoration: BoxDecoration(
//                 color: const Color(0x40000000),
//                 borderRadius: BorderRadius.circular(
//                   Dimens.gap_dp10,
//                 ),
//               ),
//               padding: EdgeInsets.all(Dimens.gap_dp10),
//               child: Text(
//                 '系统提示:严禁未成年人直播或打赏。直播间内严禁出现违法违规、低俗色情、吸烟酗酒等内容。如主播在直播过程中以不当方式诱导打赏、私下交易，请谨慎判断，以防人身财产损失。请大家注意财产安全，谨防网络诈骗。',
//                 style: TextStyle(
//                   color: const Color(0xFF79CEFF),
//                   fontSize: Dimens.font_sp12,
//                   fontFamily: 'PingFang SC',
//                   height: 1.5,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
