import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/enum/launch.dart';
import 'package:flutter_video_community/global/enum/tab.dart';
import 'package:flutter_video_community/global/web/app_webview.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/utils/screen.dart';
import 'package:flutter_video_community/widgets/button/draggable.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/keep_alive_widget.dart';
import 'package:flutter_video_community/widgets/tab_bar.dart';
import 'package:get/get.dart';

import 'community_controller.dart';
import 'escort/escort_page.dart';
import 'hall/hall_page.dart';
import 'peripheral/peripheral_page.dart';
import 'widgets/official_tips_widget.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({
    super.key,
    this.second = true,
  });

  final bool second;

  @override
  State<StatefulWidget> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final _controller = Get.put(CommunityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.second
          ? Theme.of(context).colorScheme.surface
          : Colors.transparent,
      body: Stack(
        children: [
          if (widget.second)
            RHExtendedImage.asset(
              Images.imgBgHeader.assetName,
              width: double.infinity,
              height: Dimens.gap_dp1 * 375,
              fit: BoxFit.fill,
            ),
          if (widget.second)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Dimens.gap_dp1 * 375,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x00FFFFFF),
                      Color(0xFFF9F5F5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          Column(
            children: [
              if (widget.second)
                SizedBox(
                  height: Screen.statusBar,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Obx(
                        () {
                          return StateWidget(
                            state: _controller.loadState.value,
                            child: DefaultTabController(
                              length: _controller.tabList.length,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: Dimens.gap_dp14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            padding: EdgeInsets.only(top: Dimens.gap_dp10).copyWith(left: Dimens.gap_dp2),
                                            child: Row(
                                              children: [
                                                Text(_controller.cityName.value,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: Dimens.font_sp16,
                                                  ),
                                                ),
                                                Gaps.hGap4,
                                                Container(
                                                    padding: const EdgeInsets.only(top: 2),
                                                    child: Icon(Icons.location_on_outlined, size: Dimens.font_sp16,)),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            _controller.selectCity(context);
                                          },
                                        ),
                                        CustomTabBar(
                                          tabs: _controller.tabList
                                              .map((element) =>
                                              Tab(text: element.name))
                                              .toList(),
                                          isScrollable: true,

                                        ),
                                        // Builder(
                                        //   builder: (context) {
                                        //     return GestureDetector(
                                        //       onTap: () {
                                        //         /// search
                                        //       },
                                        //       child: Image(
                                        //         image: Images.iconSearchGrey,
                                        //         width: Dimens.gap_dp20,
                                        //         height: Dimens.gap_dp20,
                                        //       ),
                                        //     );
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ),
                                  const OfficialTipsWidget(
                                    text: '',
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: _controller.tabList.map(
                                        (element) {
                                          if (element.openWay ==
                                              LaunchType.hybrid.value) {
                                            return KeepAliveWidget(
                                              child:  AppWebView(url: element.address),
                                             // child: AppUtil.buildHybridWebView(element.address)
                                            );
                                          }
                                          return KeepAliveWidget(
                                            child: _getPage(element),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!widget.second)
            Obx(
              () {
                final communityFloatingBanner =
                    _controller.adsRsp.value?.communityFloatingBannerValue;
                if (null == communityFloatingBanner) {
                  return Gaps.empty;
                }
                return DraggableButton(data: communityFloatingBanner);
              },
            ),
        ],
      ),
    );
  }

  Widget _getPage(TabModel data) {
    if (data.address.contains(TabEnum.lFengHall.type)) {
      return HallPage(tabData: data);
    } else if (data.address.contains(TabEnum.lFengPeripheral.type)) {
      return PeripheralPage(tabData: data);
    } else if (data.address.contains(TabEnum.lFengEscort.type)) {
      return EscortPage(tabData: data);
    }
    return Container();
  }
}
