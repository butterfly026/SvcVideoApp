import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/global/widgets/theme_tag.dart';
import 'package:flutter_video_community/global/widgets/vip_tag.dart';
import 'package:flutter_video_community/widgets/image.dart';

//视频布局  1列样式的item
class VideoList1ColItem extends StatelessWidget {
  const VideoList1ColItem({super.key, required this.video});

  final ClassifyContentModel video;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.85,
      child: Stack(
        children: [
          RHExtendedImage.network(
            video.pic,
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.circular(
              Dimens.gap_dp6,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 10).copyWith(left: 12, right: 12),

            child: Text.rich(TextSpan(
                children: [
                  WidgetSpan(child: _buildTag(video)),
                  WidgetSpan(child: Gaps.hGap8),
                  TextSpan(text: video.title, style: TextStyle(
                      fontSize: Dimens.font_sp16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                  ))
                ]
            ))),

        ],
      ),
    );
  }

  Widget _buildTag(ClassifyContentModel work) {
    bool workNeedVip = work.vip;         //作品是否设置了vip专享
    bool workNeedCoin = work.price > 0;     //作品章节是否设置了vip专享
    if (workNeedVip) {
      return const VipTag();
    } else if(workNeedCoin){
      return const ThemeTag(tag: "金币");
    }
    return Gaps.empty;
  }
}
