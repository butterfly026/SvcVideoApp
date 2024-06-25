import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';

/// 网格
class MyTitleWidget extends StatelessWidget {
  /// 数据
  final String text;

  const MyTitleWidget(this.text,{
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Dimens.gap_dp16,
      ),
      child: Row(
        children: [
          Image(
            image: Images.iconTitle,
            width: Dimens.gap_dp4,
            height: Dimens.gap_dp16,
          ),
          Gaps.hGap6, // 图片和文字之间的间距
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Dimens.font_sp16,
            ),
          ), // 右边的文字
        ],
      ),
    );
  }
}
