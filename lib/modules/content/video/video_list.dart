import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/modules/main/widgets/invite_friend_banner.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/widgets/banner.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:get/get.dart';

import 'video_list_1col.dart';
import 'video_list_2col.dart';

//视频列表页,可以嵌入广告等作为header控件
class VideoList extends StatefulWidget {
  const VideoList({super.key, required this.tabData,  this.first = false});

  final TabModel tabData;
  final bool first;

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {

  AdsRsp? adsRsp;
  late List<AdsModel> bannerList;
  late List<AdsModel> homeVideoBannerList;
  late int newUserEquityTime;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      adsRsp = GlobalController.to.adsRsp.value;
      bannerList = adsRsp?.homeBannerList ?? [];
      homeVideoBannerList = adsRsp?.homeVideoBannerList ?? [];
      newUserEquityTime = GlobalController.to.newUserEquityTime.value;
      TabModel tabData = widget.tabData;
      bool video2Col = tabData.address.contains('video_2col');

      SliverPadding header = SliverPadding(
        padding: const EdgeInsets.all(dPadding),
        sliver: SliverList(delegate: SliverChildListDelegate(
            [
              if (bannerList.isNotEmpty) CustomBanner(
                list: bannerList,
              ),
              if (widget.first && newUserEquityTime > 0) InviteFriendBanner(
                duration: Duration(
                  seconds: newUserEquityTime,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                ).copyWith(
                  bottom: Dimens.gap_dp12,
                  top: (widget.first && newUserEquityTime > 0)
                      ? 0
                      : dPadding,
                ),
                child: CustomBanner(
                  list: homeVideoBannerList,
                  onTap: (index) {},
                ),
              ),

            ]
        )),
      );
      return video2Col ? VideoList2Col(header: header, tabData: tabData, onTapVideo: (ClassifyContentModel video){
        Get.toNamed(AppRouter.videoPlayer, parameters: {"id": video.id});
      },) : VideoList1Col(
        header: header, tabData: tabData,
          onTapVideo: (ClassifyContentModel video){
            Get.toNamed(AppRouter.videoPlayer, parameters: {"id": video.id});
          }
      ) ;

    });
  }
}
