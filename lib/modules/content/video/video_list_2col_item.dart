import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/global/widgets/work_tag.dart';
import 'package:flutter_video_community/widgets/image.dart';

//视频布局  2列样式的item

class VideoList2ColItem extends StatelessWidget {
  const VideoList2ColItem({super.key, required this.video});

  final ClassifyContentModel video;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.92,
              child: RHExtendedImage.network(
                video.pic,
                borderRadius: BorderRadius.circular(
                  Dimens.gap_dp6,
                ),
              ),
            ),
            _buildTag(context, video),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 3),
          margin: const EdgeInsets.only(bottom: 3),
          child: Text(
            video.title,
            maxLines: 1,
            style: TextStyle(
              fontSize: Dimens.font_sp16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTag(BuildContext context, ClassifyContentModel work) {
    bool workNeedVip = work.vip;         //作品是否设置了vip专享
    bool workNeedCoin = work.price > 0;     //作品章节是否设置了vip专享
    if (workNeedVip) {
      return  const WorkTag(tag: "VIP");
    } else if(workNeedCoin){
      return  const WorkTag(tag: "金币");
    }
    return Gaps.empty;
  }
}
