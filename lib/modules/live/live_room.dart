import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/screen.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LiveRoom extends StatefulWidget {
  const LiveRoom({super.key});

  @override
  State<LiveRoom> createState() => _LiveRoomState();
}

class _LiveRoomState extends State<LiveRoom> {
  late VideoPlayerController playerController;
  bool _playerInit = false; //播放器初始化完成否
  bool _playerErr = false; //播放器初始化是否异常
  String? url; //stream url
  late double playAreaW;
  late double playAreaH;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    playAreaW = Screen.width;
    playAreaH = Screen.height;
    url = Get.parameters['url'];
    if (AppTool.isEmpty(url)) {
      _playerErr = true;
      _playerInit = false;
    } else {
      // String u = 'http://la2kle01.shiqing01.top/live/cx_373956.flv';
      //  String u = 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8';
      // String u = 'https://sf1-hscdn-tos.pstatp.com/obj/media-fe/xgplayer_doc_video/flv/xgplayer-demo-360p.flv//';
      debugPrint('liveroom-> init  player url= $url');

      playerController = VideoPlayerController.networkUrl(Uri.parse(url!))
        ..initialize().then((_) {
          debugPrint('liveroom-> init finished url= $url');
          playerController.addListener(_videoListener);
          chewieController = ChewieController(
              videoPlayerController: playerController,
              isLive: true,
              autoPlay: true,
              autoInitialize: true,
              looping: true,
              fullScreenByDefault: true,
              showControlsOnInitialize: false,
              customControls: null);

          // playerController.seekTo(Duration(days: 30));
          // playerController.setLooping(true);
          //playerController.play();
          setState(() {
            //  playerController.play();

            _playerInit = true;
            _playerErr = false;
          });
        }).onError((error, stackTrace) {
          debugPrint('liveroom-> err=$error');
          playerController.dispose();
          setState(() {
            _playerInit = false;
            _playerErr = true;
          });
        });
      debugPrint('liveroom-> 1=');
    }
  }

  void _videoListener() async {
    debugPrint('liveroom listener-----');
    if (playerController.value.hasError) {
      debugPrint('liveroom listener hasError-----');
      setState(() {
        _playerErr = true;
      });
    } else {
      if (_playerInit) {
        Duration curPos = playerController.value.position;
        Duration duration = playerController.value.duration;
        //  playerController.seekTo(Duration(days: 30));

        debugPrint('liveroom listener---curPos=${curPos}--duration=$duration');
        // if (curPos >= duration) {
        //   await playerController.seekTo(const Duration(seconds: 0));
        //  // await playerController.pause();
        // }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_playerInit) {
      playerController.removeListener(_videoListener);
      playerController.dispose();
      // chewieController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = 100;
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: playAreaW,
          height: playAreaH,
          child: _playerErr
              ? EmptyView()
              : Stack(
                  children: [
                    //  (_playerInit && playerController.value.isInitialized) ? VideoPlayer(playerController) : Container(),
                    (_playerInit && playerController.value.isInitialized)
                        ? Chewie(
                            controller: chewieController,
                          )
                        : Container(),

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
                  ],
                ),
        ),
        Positioned(
          left: 15,
          top: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){
              Get.back();
            }, icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,)),
          ),
        ),
      ],
    );
  }
}
