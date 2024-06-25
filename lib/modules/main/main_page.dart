import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/event/purchase_occurred_event.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/global/widgets/tip_dialog_view.dart';
import 'package:flutter_video_community/modules/content/work_page.dart';
import 'package:flutter_video_community/modules/live/live_page.dart';
import 'package:flutter_video_community/modules/main/game/game_page.dart';
import 'package:flutter_video_community/modules/main/home/home_page.dart';
import 'package:flutter_video_community/modules/main/hot/hot_page.dart';
import 'package:flutter_video_community/modules/main/community/community_page.dart';
import 'package:flutter_video_community/modules/main/mine/mine_page.dart';
import 'package:flutter_video_community/modules/main/web/app/web_app_page.dart';
import 'package:flutter_video_community/modules/undress/undress_page.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_video_community/widgets/bottom_navigation_bar/bottom_tab_model.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/keep_alive_widget.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'crack/crack_page.dart';
import 'main_controller.dart';
import 'tv/tv_series_page.dart';

class MainPage extends StatefulWidget {
  final int curIndex;
  const MainPage({super.key, this.curIndex = 0});

  @override
  State<StatefulWidget> createState() => _MainPageState();
  
  static InAppWebViewController? webViewController;
}

class _MainPageState extends State<MainPage>
    with RouteAware, WidgetsBindingObserver {      
  //int _preIndex = 0;
  final _controller = Get.put(MainController());
  late PageController _pageController;
  //int currentPage = 0;
  late final StreamSubscription purchaseOccurredSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.currentIndex.value = widget.curIndex;
    _pageController = PageController(initialPage: widget.curIndex, keepPage: true);
    purchaseOccurredSubscription =
        eventBus.on<PurchaseOccurredEvent>().listen((event) {
      _controller.refreshUserInfo();
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppRouter.routeObservers.subscribe(
      this,
      ModalRoute.of(context)!,
    );
  }

  @override
  void didPop() {
    super.didPop();
    debugPrint('main page didPop');
  }

  /// 从其他页面返回时调用
  @override
  void didPopNext() {
    super.didPopNext();
    // _controller.didPopNext();
    debugPrint('main page didPopNext');
  }

  @override
  void didPush() {
    super.didPush();
    debugPrint('main page didPush');
  }

  /// 跳转到其他页面回调
  @override
  void didPushNext() {
    super.didPushNext();
    //_controller.didPushNext();
    debugPrint('main page didPushNext');
  }

  @override
  void dispose() {
    AppRouter.routeObservers.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    purchaseOccurredSubscription.cancel();
    super.dispose();
  }

  Widget _getPageByTabId(BottomTabModel tabData) {
    final String url = tabData.url;
    final String action = tabData.action;
    if (tabData.action == TabAction.inside.value) {
      return WebAppPage(data: tabData.toWebData());
    } else {
      if (url == 'app://mine') {
        /// 我的
        return MinePage();
      } else if (url == 'app://hot') {
        /// 热门
        return HotPage();
      } else if (url == 'app://game') {
        /// 游戏
        return GamePage();
      } else if (url == 'app://live') {
        /// 直播
        return LivePage();
      } else if (url == 'app://home') {
        /// 首页
        return HomePage();
      } else if (url == 'app://news') {
        /// 爆料
        return CrackPage();
      } else if (url == 'app://comics') {
        /// 漫画
        return WorkPage(type: ContentEnum.comic.type);
      } else if (url == 'app://novel') {
        /// 小说
        return WorkPage(
          type: ContentEnum.novel.type,
        );
      } else if (url == 'app://community') {
        /// 社区
        return CommunityPage(second: false);
      } else if (url == 'app://crack') {
        /// 爆料
        return CrackPage();
      } else if (url == 'app://aiUndress') {
        /// AI脱衣
        return const UndressPage(second: false);
      } else if (url == 'app://tv') {
        /// 影视剧集
        return const TvSeriesPage();
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //组件树结构为Scaffold嵌套Scaffold时，在iOS有刘海屏的机型上，会出现子Scaffold顶部不响应点击事件的情况
      //Scaffold会把顶部statusbar高度预留出来，这一部分高度无法点击，
      //子组件Scaffold外层套一个MediaQuery.removePadding，把顶部空间移除掉
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Obx(() {
            return StateWidget(
              state: _controller.loadState.value,
              onReload: _controller.reload,
              child: Stack(
                children: [
                  RHExtendedImage.asset(
                    Images.imgBgHeader.assetName,
                    width: double.infinity,
                    height: Dimens.gap_dp1 * 375,
                    fit: BoxFit.fill,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: Dimens.gap_dp1 * 375,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x00FFFFFF),
                            Color(0xFFFFFFFF),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Obx(() {
                        final index = _controller.currentIndex.value;
                        final tabData = _controller.bottomTabDataList[index];
                        if (tabData.url == 'app://aiUndress') {
                          return Gaps.empty;
                        }
                        return SizedBox(
                          height: Dimens.gap_dp44,
                        );
                      }),
                      Expanded(
                        child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          itemCount: _controller.bottomTabDataList.length,
                          itemBuilder: (context, index) {
                            final tabData =
                                _controller.bottomTabDataList[index];
                            return KeepAliveWidget(
                              child: Stack(children: [
                                _getPageByTabId(tabData),
                                if (!tabData.auth)
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: const Color(0x80000000),
                                    alignment: Alignment.center,
                                  ),

                                // AppMenuUnlockView(tabData: tabData, unlockFinished: () {
                                //   setState(() {
                                //     tabData.auth = true;
                                //   });
                                // },userCoins: _controller.userCoins.value,)
                              ]),
                            );
                          },
                        ),
                      ),
                      CustomBottomNavigationBar(
                        tabs: _controller.bottomTabDataList,
                        onTap: (index) async {
                          if (_controller.currentIndex.value == index) {
                            return;
                          }
                          final tabData = _controller.bottomTabDataList[index];
                          _pageController.jumpToPage(index);
                          _controller.currentIndex.value = index;
                          if (!tabData.auth) {
                            _controller.showUnlockMenuDialog(
                              tabData,
                              index,
                              callback: () async {
                                setState(() {
                                  tabData.auth = true;
                                });
                                // _controller.didPopNext();
                                // _preIndex = index;
                              },
                            );
                          } else {
                            if (tabData.action == TabAction.app.value) {
                              /// app 内部跳转
                              _pageController.jumpToPage(index);
                              _controller.currentIndex.value = index;
                              // _controller.didPopNext();
                              // _preIndex = index;
                            } else if (tabData.action ==
                                TabAction.inside.value) {
                              /// 内部浏览器打开 暂时和app内部跳转逻辑一致
                              _pageController.jumpToPage(index);
                              _controller.currentIndex.value = index;
                              // _controller.didPopNext();

                              //_preIndex = index;
                            } else {
                              CommonUtil.launchUrl(
                                tabData.url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          }
                          // _controller.hideFloatingButton(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          //测试按钮
          // floatingActionButton: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     FloatingActionButton(
          //       onPressed: () {
          //         Get.to(() => WebViewInAppScreen(
          //               url: 'https://www.baidu.com',
          //               onLoadFinished: (String? url) {},
          //               onWebTitleLoaded: (String? webTitle) {},
          //             ));
          //       },
          //       child: Text("测试"),
          //     ),
          //     SizedBox(height: 160),
          //   ],
          // ),
        ),
      ),
      onWillPop: () async {
        if (MainPage.webViewController != null &&
            await MainPage.webViewController!.canGoBack()) {
          await MainPage.webViewController!.goBack();
          return false;
        }
        if (_controller.currentIndex.value != 0) {
          _pageController.jumpToPage(0);
          _controller.currentIndex.value = 0;
        }
        if (_controller.canPop()) {
          _controller.lastPopTime = DateTime.now();
          exit(0);
        } else {
          _controller.lastPopTime = DateTime.now();
          showToast('再按一次退出应用');
        }
        return false;
      },
    );
  }
}
