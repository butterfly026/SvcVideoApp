import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/launch.dart';
import 'package:flutter_video_community/utils/umeng_util.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'image.dart';

class CustomBanner extends StatelessWidget {
  const CustomBanner({
    super.key,
    required this.list,
    this.height,
    this.onTap,
  });

  final List<AdsModel> list;
  final double? height;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Dimens.gap_dp10 * 20,
      child: Swiper(
        autoplay: true,
        autoplayDelay: 2000,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return RHExtendedImage.network(
            list[index].pic,
            fit: BoxFit.fill,
            width: double.infinity,
            height: height ?? Dimens.gap_dp10 * 20,
            borderRadius: BorderRadius.circular(
              Dimens.gap_dp10,
            ),
          );
        },
        onTap: (index) {
          UmengUtil.upPoint(UMengType.buttonClick,
              {'name': UMengEvent.advPv, 'desc': '广告查看'});
          GlobalController.to.launch(
            list[index],
          );
        },
      ),
    );
  }
}
