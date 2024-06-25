import 'package:flutter/material.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/screen.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class LiveRoomIos extends StatefulWidget {
  const LiveRoomIos({super.key});

  @override
  State<LiveRoomIos> createState() => _LiveRoomIosState();
}

class _LiveRoomIosState extends State<LiveRoomIos> {
  bool _playerErr = false;
  String? url; //stream url
  late double playAreaW;
  late double playAreaH;

  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    playAreaW = Screen.width;
    playAreaH = Screen.height;
    url = Get.parameters['url'];
    if (AppTool.isEmpty(url)) {
      setState(() {
        _playerErr = true;
      });
    }
    player.open(Media(url!));
    debugPrint('liveroom-> init  player url= $url');
  }

  @override
  void dispose() async {
    super.dispose();
    release();
  }

  Future<void> release() async {
    await player.pause();
    await player.stop();
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = 100;
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _playerErr
            ? Stack(
                children: [
                  const EmptyView(),
                  Positioned(
                    left: 15,
                    top: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  // AspectRatio(
                  //   aspectRatio: playAreaW / (playAreaH),
                  //   child: VideoPlayerRtmpExtWidget(
                  //     controller: controller,
                  //     viewCreated: (IJKPlayerController _) async {
                  //       onPlayerReady();
                  //     },
                  //   ),
                  // )
                  Video(controller: controller),
                  //主播信息
                  // Positioned(
                  //   top: 100,
                  //   left: 15,
                  //   child: Container(
                  //     width: 158,
                  //     height: 54,
                  //     decoration: ShapeDecoration(
                  //       color: Color(0x80000000),
                  //       shape: StadiumBorder(),
                  //     ),
                  //   ),
                  // )
                  Positioned(
                    left: 15,
                    top: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PopScope(
                        canPop: false,
                        onPopInvoked: (bool didPop) async {
                          if (didPop) {
                            return;
                          }
                          await release();
                          Get.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: IconButton(
                              onPressed: () async {
                                await release();
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  // if(!_playerInit) CircularProgressIndicator()
                ],
              ),
      ),
    );
  }
}
