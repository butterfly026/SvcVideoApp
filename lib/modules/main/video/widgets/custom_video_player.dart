// import 'package:flutter/material.dart';
// import 'package:flutter_video_community/config/dimens.dart';
// import 'package:flutter_video_community/config/gaps.dart';
// import 'package:flutter_video_community/config/images.dart';
// import 'package:flutter_video_community/modules/main/video/player/video_player_controller.dart';
// import 'package:flutter_video_community/router/router.dart';
// import 'package:flutter_video_community/widgets/button/gradient.dart';
// import 'package:flutter_video_community/widgets/countdown/countdown.dart';
// import 'package:flutter_video_community/widgets/image.dart';
// import 'package:flutter_video_community/widgets/video/rh_fijkview.dart';
// import 'package:get/get.dart';
//
// import 'ijk_panel.dart';
//
// class CustomVideoPlayer extends StatefulWidget {
//   const CustomVideoPlayer({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _CustomVideoPlayerState();
// }
//
// class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   late VideoPlayerController controller;
//
//   bool showVipVideoTip = false;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = VideoPlayerController.to;
//   }
//
//   Widget _buildPlayerView() {
//     final videoInfo = controller.videoInfo.value;
//     return FijkView(
//       width: double.infinity,
//       height: double.infinity,
//       color: Colors.black,
//       player: controller.player,
//       panelBuilder: fijkPanelBuilder,
//       cover: RHExtendedImage.network(
//         videoInfo?.pic ?? '',
//         width: double.infinity,
//         height: double.infinity,
//       ).image,
//     );
//   }
//
//   Widget _buildVideoAds() {
//     return SizedBox(
//       width: double.infinity,
//       height: double.infinity,
//       child: Stack(
//         children: [
//           RHExtendedImage.network(
//             controller.videoAds.value!.pic,
//             width: double.infinity,
//             height: double.infinity,
//           ),
//           Align(
//             alignment: Alignment.topCenter,
//             child: SizedBox(
//               height: Dimens.gap_dp36,
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Get.back();
//                     },
//                     splashRadius: Dimens.gap_dp20,
//                     icon: Icon(
//                       Icons.arrow_back_ios_new,
//                       size: Dimens.gap_dp18,
//                       color: Theme.of(context).colorScheme.surface,
//                     ),
//                   ),
//                   Expanded(child: Gaps.empty),
//                   CountdownWidget(
//                     seconds: 5,
//                     onComplete: () {
//                       controller.videoAdsCompleted();
//                     },
//                     childBuilder: (context, seconds) {
//                       return GradientButton(
//                         text: '广告${seconds}s',
//                         width: Dimens.gap_dp56,
//                         height: Dimens.gap_dp24,
//                         radius: Dimens.gap_dp12,
//                         style: TextStyle(
//                           fontSize: Dimens.font_sp12,
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).colorScheme.surface,
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPayCoinTip() {
//     if (!controller.showPayCoinTip.value) {
//       return Gaps.empty;
//     }
//     return Container(
//       width: double.infinity,
//       color: const Color(0x80000000),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: Dimens.gap_dp1 * 216,
//             height: Dimens.gap_dp1 * 146,
//             child: Stack(
//               children: [
//                 Align(
//                   child: RHExtendedImage.asset(
//                     Images.imgVipVideoTip.assetName,
//                     width: Dimens.gap_dp1 * 246,
//                     height: Dimens.gap_dp1 * 166,
//                   ),
//                 ),
//                 Positioned(
//                   left: 0,
//                   right: 0,
//                   bottom: 6,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         '当前视频需${controller.currentVideoInfo?.price}金币解锁',
//                         style: TextStyle(
//                           fontSize: Dimens.font_sp12,
//                           color: Theme.of(context).colorScheme.surface,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Gaps.vGap12,
//           GradientButton(
//             text: '立即解锁',
//             width: Dimens.gap_dp92,
//             height: Dimens.gap_dp32,
//             onTap: () {
//               controller.unlockVideo();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVipVideoTip() {
//     if (!controller.showVipVideoTip.value) {
//       return Gaps.empty;
//     }
//     return Container(
//       width: double.infinity,
//       color: const Color(0x80000000),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: Dimens.gap_dp1 * 216,
//             height: Dimens.gap_dp1 * 146,
//             child: Stack(
//               children: [
//                 Align(
//                   child: RHExtendedImage.asset(
//                     Images.imgVipVideoTip.assetName,
//                     width: Dimens.gap_dp1 * 246,
//                     height: Dimens.gap_dp1 * 166,
//                   ),
//                 ),
//                 Positioned(
//                   left: 0,
//                   right: 0,
//                   bottom: 6,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         '当前视频需开通 VIP 解锁',
//                         style: TextStyle(
//                           fontSize: Dimens.font_sp12,
//                           color: Theme.of(context).colorScheme.surface,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Gaps.vGap12,
//           GradientButton(
//             text: '马上开通',
//             width: Dimens.gap_dp92,
//             height: Dimens.gap_dp32,
//             onTap: () {
//               Get.toNamed(AppRouter.vipRecharge);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: Dimens.gap_dp10 * 30,
//       child: Stack(
//         children: [
//           Align(
//             child: Obx(
//               () {
//                 Widget child = Gaps.empty;
//                 if (null != controller.videoAds.value) {
//                   child = _buildVideoAds();
//                 } else {
//                   child = Stack(
//                     children: [
//                       Align(
//                         child: _buildPlayerView(),
//                       ),
//                       if (controller.showVipVideoTip.value)
//                         Align(
//                           child: _buildVipVideoTip(),
//                         ),
//                       if (controller.showPayCoinTip.value)
//                         Align(
//                           child: _buildPayCoinTip(),
//                         ),
//                     ],
//                   );
//                 }
//                 return Container(child: child);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
