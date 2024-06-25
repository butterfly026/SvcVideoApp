import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/widgets/HeaderWidget.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/global/widgets/video_empty.dart';
import 'package:flutter_video_community/modules/content/detail/work_detail_controller.dart';
import 'package:flutter_video_community/modules/content/video/video_play_controller.dart';
import 'package:flutter_video_community/modules/content/detail/work_chapter_dialog.dart';
import 'package:flutter_video_community/modules/main/widgets/app_item_widget.dart';
import 'package:flutter_video_community/modules/main/widgets/work_chapter_item.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/cache_util.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/screen.dart';
import 'package:flutter_video_community/widgets/banner.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/countdown/countdown.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

import 'video_list_2col_item.dart';

class VideoPlayPage extends StatefulWidget {
  const VideoPlayPage({super.key});

  @override
  State<VideoPlayPage> createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage>
    implements VideoCallback {
  //final FijkPlayer player = FijkPlayer();
  String? workId;
  late VideoPlayController playerLogic;
  String? playUrl;
  late WorkDetailController workDetailController;
  static const double padding = 15;
  late double playAreaW;
  late double playAreaH;
  //late double playAreaRatio;

  late double playAreaWFull;
  late double playAreaHFull;
  late double playAreaRatioFull;
  bool vidPlayable = false; //视频源是否初始化完成之后可以播放;
  late Duration freeTime;
  bool showVideoAd = true; //是否展示视频倒计时广告
  bool showVipTip = false; //是否展示vip提示
  bool showVidCover = true; //是否展示视频封面
  bool previewVid = false;//是否有试看条件
  Duration previewVidDuration = Duration.zero;
  bool _previewOver = false; //试看是否结束
  bool firstShowAd = true; //用于倒计时视频广告，只展示一次，切换分集不再显示
  //播放器player相关定义
  late VideoPlayerController playerController;
  //late ChewieController panController;
  bool _playerInit = false; //播放器初始化完成否
  bool _playerErr = false; //播放器初始化是否异常
  Timer? _hideTimer; //隐藏视频面板的timer
  bool _hidePlayControl = true; // 控制是否隐藏视频面板
  double _playControlOpacity = 0; // 通过透明度动画显示/隐藏d播放按钮
  bool _canControl = false; // 控制是否可以点击视频操作面板
  String playerDuration = '0:0 / 0:0';
  /// 记录是否全屏
  // bool get _isFullScreen =>
  //     MediaQuery.of(context).orientation == Orientation.landscape;
  bool _isFullScreen = false;
  Duration _vidDuration = Duration.zero;
  double _recordVidVolumn = 0;
  bool _isMuted = false; //控制视频是否静音


  @override
  void initState() {
    super.initState();
    freeTime = Duration(seconds: Cache.getInstance().mainApp?.freeTime ?? 0);
    playAreaW = Screen.width;
    playAreaH = (playAreaW * 9) / 16;
    //playAreaRatio = 16 / 9;
    //全屏的参数
    playAreaWFull = Screen.height;
    playAreaHFull = Screen.width;
   // playAreaRatioFull = playAreaWFull / playAreaHFull;

    playerLogic = VideoPlayController(this);
    workId = Get.parameters['id'];
    workDetailController =
        Get.put(WorkDetailController(), tag: ContentEnum.video.type);

    if (AppTool.isNotEmpty(workId)) {
      playerLogic.setWorController(workDetailController);
      playerLogic.loadData(workId);

    } else {
      setState(() {
        _playerErr = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_playerInit) {
      playerController.removeListener(_videoListener);
      playerController.dispose();
     // panController.dispose();

    }
    _hideTimer?.cancel();
    //player.release();
  }

  @override
  onDataLoaded(bool noData) {
    _reset();
    if (noData) {
      playerController.pause();
      playerController.dispose();
      setState(() {
        _playerInit = false;
        _playerErr = true;
      });
    } else {
      _checkBeforePlayChapter();
    }
  }

  @override
  onSwitchChapter(bool noData) async {
    _reset();
    if (noData) {
      playerController.pause();
      playerController.dispose();
      setState(() {
        _playerInit = false;
        _playerErr = true;
      });
    } else {
      _checkBeforePlayChapter();
    }
  }

  //------------Player 相关 -----start-----

  void _playOrPause() {
    debugPrint('vplayer _playOrPause');

    /// 同样的，点击动态播放或者暂停
    if (_playerInit) {
      showVidCover = false;
      debugPrint(
          'vplayer _playOrPause--isPlaying-=${playerController.value.isPlaying} ');
      _hideTimer?.cancel();
      playerController.value.isPlaying
          ? playerController.pause()
          : playerController.play();
      if (!playerController.value.isPlaying) {
        // 准备暂停
        setState(() {
          _playControlOpacity = 1;
          _hidePlayControl = false;
        });
       // _startHideTimer();
        // _startPlayControlTimer(); // 操作控件后，重置延迟隐藏控件的timer
      } else {
        // 准备播放
        setState(() {
          _playControlOpacity = 0;
          _hidePlayControl = true;
        });
      }
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _hidePlayControl = true;
        _playControlOpacity = 0;
      });
    });
  }

  //隐藏或显示player UI板
  void _togglePlayControl() {
    if (!_playerInit) {
      return;
    }
    debugPrint('vplayer_togglePlayControl');
    _hideTimer?.cancel();
    //暂停中 点击面板不做反应, 播放中，点击面板可以切换面板隐藏和显示
    if (playerController.value.isPlaying) {
      if (_hidePlayControl) {
        //准备显示面板和 按钮
        setState(() {
          _playControlOpacity = 1;
          _hidePlayControl = false;
        });
        _startHideTimer();

      } else {
        //准备隐藏面板和按钮
        setState(() {
          _playControlOpacity = 0;
          _hidePlayControl = true;
        });
      }
    }
  }


  void _toggleFullScreen() {

    setState(() {
      if (_isFullScreen) {
        /// 如果是全屏就切换竖屏
        _isFullScreen = false;
        AppUtil.setPortraitScreen();
       // _isFullScreen = false;
        ///显示状态栏，与底部虚拟操作按钮
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: [SystemUiOverlay.bottom]);
      } else {
        _isFullScreen = true;
        AppUtil.setFullScreen();
       // _isFullScreen = true;
        ///关闭状态栏，与底部虚拟操作按钮
        // SystemChrome.setEnabledSystemUIMode();
      }
    });
  }

  // 拦截返回键
  Future<bool> _onWillPop() async {
    if (_isFullScreen) {
      _toggleFullScreen();
      return false;
    }
    return true;
  }

  void _videoListener() async {
    debugPrint('vplayer listener-----');
    if (playerController.value.hasError) {
      setState(() {
        _playerErr = true;
      });
    } else {

      if (_canControl && _playerInit && !_hidePlayControl) {
        Duration curPos =  playerController.value.position;
        Duration duration = playerController.value.duration;
        debugPrint('vplayer listener---curPos=${curPos}--duration=$duration---_isFullScreen=$_isFullScreen');
        if (curPos >= duration) {
          await playerController.seekTo(const Duration(seconds: 0));
          await playerController.pause();
        } else if (previewVid && curPos.inSeconds >= previewVidDuration.inSeconds) {
          //试看过程中, 播放超过试看时间或者用户拉进度条超过试看时间
          await playerController.seekTo(previewVidDuration);
          await playerController.pause();
          setState(() {
            _canControl = false;
            previewVid = false;
            _previewOver = true;
            _hidePlayControl = true;
            showVipTip = true;
          });
        } else {
          String curPosStr = curPos.toString().substring(2, 7);
          String durationStr = duration.toString().substring(2, 7);
          setState(() {
            playerDuration = '$curPosStr / $durationStr';
          });
        }


      }

      // curPos=curPos.subString(0,2);


      // }
    }
  }

  void _setupVolume() {
    if (_playerInit) {
      _isMuted = !_isMuted;
      if (_isMuted) {
        _recordVidVolumn = playerController.value.volume;
        debugPrint("vplayer _setupVolume-> _isMuted=$_isMuted _recordVidVolumn=$_recordVidVolumn");
        playerController.setVolume(0);
      } else {
        playerController.setVolume(_recordVidVolumn);
      }
    }

  }

  ////////--------end----------------

  //播放前的权限校验等
  _checkBeforePlayChapter() async {
    _playerErr = false;
    ChapterModel? videoChapter = workDetailController.currentChapter.value;
    ClassifyContentModel? workInfo = workDetailController.workInfo.value;
    if (videoChapter == null || AppTool.isEmpty(videoChapter.content)) {
      return;
    }
    playUrl = videoChapter.content;

    final AudioSession session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    try {
      // _prepareVideo(playUrl!, false);
      debugPrint('vplayer check playUrl=$playUrl');
      //playUrl="http://137.175.37.43:2100/20231216/EJ3KMJtQ/index.m3u8?&start=0&end=60";
      playerController = VideoPlayerController.networkUrl(Uri.parse(playUrl!))
        ..initialize().then((_) {
          playerController.addListener(_videoListener);
         // panController = ChewieController(videoPlayerController: playerController, autoInitialize: true);
          _playerInit = true;
          _recordVidVolumn = playerController.value.volume;
          _vidDuration = playerController.value.duration;
          //判断试看当auth为false且免费时长字段有时间才能试看
          if (videoChapter.auth == false && freeTime.inSeconds > 3) {
            previewVid = true;
            previewVidDuration = (freeTime.inSeconds <= _vidDuration.inSeconds) ? freeTime : _vidDuration;
          }

          // if (playerController.value.aspectRatio > playAreaRatio) {
          //   playAreaRatio = playerController.value.aspectRatio;
          //   playAreaH = playAreaW / playAreaRatio;
          // }
          if (playerController.value.isPlaying) {
            playerController.pause();
          }
          debugPrint("vplayer check init");
          debugPrint("vplayer check init vidDuration=${_vidDuration!.inSeconds}秒");

          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            _playerErr = false;
          });
          if (!showVideoAd) {
            if (previewVid) {
              _checkFreeTime();
            } else {
              _checkVipTip();
            }
          }

        }).onError((error, stackTrace) {
          debugPrint("vplayer check init err=>$error");
          setState(() {
            _playerErr = true;
          });

        });
    } catch (err) {
      setState(() {
        _playerErr = true;
      });
      debugPrint("vplayer check err=>$err");
    }
    //在播放之前需要判断三个前置条件的逻辑 showVideoAd, previewVid, showVipTip,
    //如果进入任意一个条件,播放事件则被拦截

    //1. 如果要显示视频倒计时广告，则播放事件被拦截由广告代理，_buildVideoAds的onCompleted回调方法里进行下一步
    final adsRsp = GlobalController.to.adsRsp.value;
    AdsModel? videoAds = adsRsp?.videoPlayAdsValue;
    if (firstShowAd && showVideoAd && videoAds != null) {
      debugPrint('vplayer check showVideoAd');
      setState(() {
        showVideoAd = true;
      });
    }
  }

  //检查观看权限
  void _checkVipTip() {
    debugPrint('vplayer _checkVipTip');
    AppUtil.checkNeedUpdateUserInfo();
    ChapterModel? vidChapter = workDetailController.currentChapter.value;
    if (vidChapter != null && vidChapter.auth) {
      setState(() {
        showVipTip = false;
        _canControl = true;
      });
      _playOrPause();
    } else {
      setState(() {
        showVipTip = true;
        _canControl = false;
      });
     // _verifyVideo();
    }
  }

  void _verifyVideo() {
    //全屏模式下不弹窗
    if (!_isFullScreen) {
      final workInfo = workDetailController.workInfo.value;
      ChapterModel? vidChapter = workDetailController.currentChapter.value;
      AppUtil.verifyChapterContent(workInfo, vidChapter, () {});
    }
  }

  //
  //检查免费观看时长和试看
  void _checkFreeTime() {
    debugPrint('vplayer _checkFreeTime---previewVid=$previewVid');

    if (previewVid) {
      //有免费试看时长
     // vidPreviewTimeStart = DateTime.now().millisecondsSinceEpoch;
      debugPrint("vplayer _checkFreeTime previewVidDuration=${previewVidDuration.inSeconds}");
      setState(() {
        showVidCover = false;
        _canControl = true;
        _playOrPause();
      });
    } else {
      _checkVipTip();
    }
  }

  void _reset()  {
    showVidCover = true;
    showVipTip = false;
    previewVid = false;
    _previewOver = false;
    //await player.reset();//切换视频源之前需要await 等待reset()
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final adsRsp = GlobalController.to.adsRsp.value;
      AdsModel? videoAds = adsRsp?.videoPlayAdsValue;
      List<AdsModel>? videoPlayAppList = adsRsp?.videoPlayAppList ?? [];
      List<AdsModel>? videoContentAdsList =
          adsRsp?.videoPlayContentAdsList ?? [];

      ChapterModel? curChapter = workDetailController.currentChapter.value;
      ClassifyContentModel? workInfo = workDetailController.workInfo.value;
      List<ChapterModel> chapterList = workDetailController.chapterList;
      List<ClassifyContentModel> recommendList =
          workDetailController.recommendList;
      final title = curChapter?.title;
      bool favored = workInfo?.haveCollect ?? false;

      final desc = workInfo?.des;
      final vidCoverUrl = workInfo?.pic ?? '';
      bool isFullScreen = _isFullScreen;
      return WillPopScope(
        onWillPop: _onWillPop,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
               Stack(
                 children: [
                   SizedBox(
                       width: isFullScreen ? playAreaWFull : playAreaW,
                       height: isFullScreen ? playAreaHFull : playAreaH,
                       child:  (_playerErr) ? const VideoEmpty() :  Stack(
                         children: [
                           // AppTool.isNotEmpty(playUrl)
                           //     ? FijkView(
                           //   width: double.infinity,
                           //   height: double.infinity,
                           //   player: player,
                           //   color: Colors.black,
                           //   panelBuilder: fijkPanelBuilder,)
                           //     : Gaps.empty,
                           (_playerInit && playerController.value.isInitialized)
                               ? GestureDetector(
                             onTap: _togglePlayControl,
                             child: Container(
                               width: isFullScreen ? playAreaWFull : playAreaW,
                               height: isFullScreen ? playAreaHFull : playAreaH,
                               color: Colors.black,
                               alignment: Alignment.center,
                               child: Stack(
                                 children: [
                                   Align(
                                     alignment: Alignment.center,
                                     child: AspectRatio(
                                       aspectRatio:
                                       playerController.value.aspectRatio,
                                       child: VideoPlayer(playerController),
                                     ),
                                   ),
                                   if (_canControl)
                                     GestureDetector(
                                       onTap: _playOrPause,
                                       child: AnimatedOpacity(
                                         opacity: _playControlOpacity,
                                         duration:
                                         const Duration(milliseconds: 300),
                                         child: Align(
                                           //正中间播放按钮
                                           alignment: Alignment.center,
                                           child: Container(
                                             padding: const EdgeInsets.all(20),
                                             decoration: const ShapeDecoration(
                                                 color: Color(0xBFFFFFFF),
                                                 shape: CircleBorder()),
                                             child: Icon(
                                               playerController.value.isPlaying
                                                   ? Icons.pause
                                                   : Icons.play_arrow,
                                               color: Colors.black,
                                               size: 50,
                                             ),
                                           ),
                                         ),
                                       ),
                                     ),
                                   if (!_hidePlayControl && _canControl)
                                     GestureDetector(
                                       onTap: () {},
                                       child: Align(
                                         //播放器操作bar
                                           alignment: Alignment.bottomCenter,
                                           child: Container(
                                             width: double.infinity,
                                             height: 80,
                                             decoration: const BoxDecoration(
                                               gradient: LinearGradient(
                                                 begin: Alignment.bottomCenter,
                                                 end: Alignment.topCenter,
                                                 colors: [
                                                   Color(0xF5000000),
                                                   Color(0x12000000)
                                                 ],
                                               ),
                                             ),
                                             child: Stack(
                                               children: [
                                                 Positioned(
                                                     left: 20,
                                                     bottom: 40,
                                                     child: Text(playerDuration, style: TextStyle(
                                                         color: Colors.white,
                                                         fontSize: 18,
                                                         fontWeight: FontWeight.w400

                                                     ),)),
                                                 Positioned(
                                                   right: 64,
                                                   bottom: 28,
                                                   child: IconButton(
                                                     // 静音按钮
                                                     padding: EdgeInsets.zero,
                                                     iconSize: 26,
                                                     icon: Icon(
                                                       // 根据当前屏幕方向切换图标
                                                       _isMuted
                                                           ? Icons.volume_off
                                                           : Icons.volume_up,
                                                       color: Colors.white,
                                                     ),
                                                     onPressed: () {
                                                       // 切换静音还是开音
                                                       _setupVolume();
                                                     },
                                                   ),
                                                 ),
                                                 Positioned(
                                                   right: 10,
                                                   bottom: 28,
                                                   child: IconButton(
                                                     // 全屏/横屏按钮
                                                     padding: EdgeInsets.zero,
                                                     iconSize: 26,
                                                     icon: Icon(
                                                       // 根据当前屏幕方向切换图标
                                                       _isFullScreen
                                                           ? Icons.fullscreen_exit
                                                           : Icons.fullscreen,
                                                       color: Colors.white,
                                                     ),
                                                     onPressed: () {
                                                       // 点击切换是否全屏
                                                       _toggleFullScreen();
                                                     },
                                                   ),
                                                 ),
                                                 Positioned( //进度条
                                                   bottom: 22,
                                                   left: 20,
                                                   right: 20,
                                                   child: VideoProgressIndicator(
                                                     playerController,
                                                     allowScrubbing: true,
                                                     colors: VideoProgressColors(
                                                         playedColor:
                                                         Colors.white,
                                                         bufferedColor: Colors
                                                             .grey.shade500),
                                                   ),
                                                 )
                                               ],
                                             ),
                                           )),
                                     )
                                 ],
                               ),
                             ),
                           )
                               : Container(),
                           if (showVidCover && AppTool.isNotEmpty(vidCoverUrl))
                             RHExtendedImage.network(
                               vidCoverUrl,
                               width: playAreaW,
                               height: playAreaH,
                             ),
                           if (previewVid)
                             Positioned(
                                 right: 10,
                                 top:40,
                                 child: _buildPreviewTip()),
                           if (showVipTip || _previewOver) _buildVipTip(),
                           if (videoAds != null && showVideoAd && firstShowAd)
                             _buildVideoAds(videoAds.pic, () {
                               //广告倒计时结束
                               //判断权限逻辑
                               showVideoAd = false;
                               firstShowAd = false;
                               _checkFreeTime();
                             }),

                         ],
                       )),
                   Positioned(
                       left: 0,
                       top: 24,
                       child: IconButton(onPressed: () {
                         debugPrint('IconButton-back=$_isFullScreen');
                         if (_isFullScreen) {
                           _toggleFullScreen();
                         } else {
                           Get.back();
                         }
                       }, icon:  Padding(
                         padding: const EdgeInsets.all(12),
                         child: Icon(
                           Icons.arrow_back_ios_rounded,
                           color: _playerErr ? Colors.black : Colors.white,
                           size: 26,),
                       ),))
                 ]
               ),

                if (!isFullScreen)Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: CustomScrollView(
                    slivers: [
                      if (AppTool.isNotEmpty(title))
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 20),
                          sliver: SliverToBoxAdapter(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    title!,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: 'PingFang SC',
                                      fontWeight: FontWeight.bold,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      top: Dimens.gap_dp2,
                                      right: Dimens.gap_dp12,
                                    ),
                                    child:  Icon(
                                      favored ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                      color: const Color(0xFFFF0000),
                                      size: Dimens.gap_dp32,
                                    ),
                                  ),
                                  onTap: () {
                                    workDetailController.favorOrNot();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (AppTool.isNotEmpty(desc))
                        SliverPadding(
                          padding: const EdgeInsets.only(top: padding),
                          sliver: SliverToBoxAdapter(
                              child: ReadMoreText(
                            desc!,
                            trimLines: 2,
                            colorClickableText: const Color(0xFFFF0000),
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '查看更多',
                            trimExpandedText: '点击收起',
                            style: TextStyle(
                              height: 1.8,
                              fontSize: Dimens.font_sp14,
                              color: const Color(0xFF626773),
                            ),
                            moreStyle: TextStyle(
                              fontSize: Dimens.font_sp14,
                              color: const Color(0xFFFF0000),
                            ),
                          )),
                        ),
                      if (videoContentAdsList.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.only(top: padding),
                          sliver: SliverToBoxAdapter(
                            child: CustomBanner(
                              list: videoContentAdsList,
                              height: Dimens.gap_dp100,
                            ),
                          ),
                        ),
                      if (videoPlayAppList.isNotEmpty)
                        SliverPadding(
                          padding: EdgeInsets.only(top: padding / 2),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.71,
                              crossAxisSpacing: padding,
                            ),
                            delegate: SliverChildBuilderDelegate((context, index) {
                              return GestureDetector(
                                onTap: () {
                                  GlobalController.to.launch(
                                    videoPlayAppList[index],
                                  );
                                },
                                child: AppItemWidget(
                                  data: videoPlayAppList[index],
                                  imageSize: 60,
                                ),
                              );
                            }, childCount: videoPlayAppList.length),
                          ),
                        ),
                      if (chapterList.isNotEmpty && chapterList.length > 1)
                        SliverToBoxAdapter(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Gaps.vGap12,
                              Row(
                                children: [
                                  Expanded(
                                    child: HeaderWidget(
                                      title: '选集',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (null != workInfo) {
                                        /// 查看选集
                                        WorkChapterDialog.show(
                                            context, ContentEnum.video.type,
                                            btnText: '开始观看');
                                      }
                                    },
                                    child: Text(
                                      '查看目录',
                                      style: TextStyle(
                                        fontSize: Dimens.font_sp14,
                                        color: const Color(0xFF626773),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dimens.gap_dp64,
                                child: ListView.builder(
                                  itemCount: chapterList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final itemData = chapterList[index];
                                    final selected =
                                        itemData.chapterId == curChapter?.chapterId;
                                    debugPrint(
                                        'index: $index selected ======> $selected');
                                    return Container(
                                      margin: EdgeInsets.only(
                                        right: Dimens.gap_dp6,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          /// 切换选集
                                          playerLogic.switchChapter(itemData);
                                        },
                                        child: WorkChapterItemWidget(
                                          data: itemData,
                                          workVip: workInfo?.vip ?? false,
                                          selected: selected,
                                          index: index,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (recommendList.isNotEmpty)
                        const SliverPadding(
                          padding: EdgeInsets.only(top: padding),
                          sliver: SliverToBoxAdapter(
                            child: HeaderWidget(
                              title: '推荐',
                              more: false,
                            ),
                          ),
                        ),
                      if (recommendList.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.only(
                              top: padding, bottom: padding * 2),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.4,
                              mainAxisSpacing: padding,
                              crossAxisSpacing: padding,
                            ),
                            delegate: SliverChildBuilderDelegate((context, index) {
                              final itemData = recommendList[index];
                              return GestureDetector(
                                onTap: () async {
                                  LoadingDialog.show(context);
                                  await playerLogic.loadData(itemData.id);
                                  LoadingDialog.dismiss();

                                },
                                child: VideoList2ColItem(
                                  video: itemData,
                                ),
                              );
                            }, childCount: recommendList.length),
                          ),
                        ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildVideoAds(String picUrl, Function onCompleted) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          RHExtendedImage.network(
            picUrl,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            right: 16,
            top: 44,
            child: SizedBox(
              height: Dimens.gap_dp36,
              child: CountdownWidget(
                seconds: 5,
                onComplete: () {
                  onCompleted();
                },
                childBuilder: (context, seconds) {
                  return GradientButton(
                    text: '广告${seconds}s',
                    width: Dimens.gap_dp56,
                    height: Dimens.gap_dp24,
                    radius: Dimens.gap_dp12,
                    style: TextStyle(
                      fontSize: Dimens.font_sp12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipTip() {
    bool userIsVip = AppUtil.isVip();
    String desc = userIsVip ? '充值': '解锁';
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0x80000000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Align(
                child: RHExtendedImage.asset(
                  Images.imgVipVideoTip.assetName,
                  width: Dimens.gap_dp1 * 250,
                  height: Dimens.gap_dp1 * 174,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _previewOver ? '试看已结束,$desc免费看' : '当前视频需要$desc',
                      style: TextStyle(
                        fontSize: Dimens.font_sp13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.vGap12,
          GradientButton(
            text: '立即$desc',
            width: 110,
            height: Dimens.gap_dp32,
            onTap: () {
              // Get.toNamed(AppRouter.vipRecharge);
              _verifyVideo();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTip() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xBF000000),
        borderRadius: BorderRadius.circular(
          Dimens.gap_dp4,
        ),
      ),
      child: Row(
        children: [
           Text('免费试看, 观看完整请', style: TextStyle(
            color: Colors.white,
            fontSize: Dimens.font_sp18,
            fontWeight: FontWeight.w500
          ),),
          GestureDetector(
            onTap: () {
              _verifyVideo();
            },
            child: Text('解锁视频', style: TextStyle(
              color: const Color(0xFFf8ce74),
                fontSize: Dimens.font_sp18,
                fontWeight: FontWeight.w500
            ),),
          ),
        ],
      ),
    );
  }
}
