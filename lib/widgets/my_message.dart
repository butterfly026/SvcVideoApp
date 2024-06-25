import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';

/// 消息
class MyMessageWidget extends StatelessWidget {
  /// 数据
  final String text;

  // 右箭头点击回调
  final Function()? onclick;

  const MyMessageWidget(this.text, {Key? key, this.onclick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.gap_dp1 * 37,
      width: ScreenUtil().screenWidth,
      color: const Color(0xFFFFF3E8),
      child: Row(
        children: [
          Gaps.hGap18,
          Image(
            image: Images.iconOfficialReminder,
            width: Dimens.gap_dp24,
            height: Dimens.gap_dp1 * 23,
          ),
          Gaps.hGap18,
          Container(
            alignment: Alignment.center,
            width: Dimens.gap_dp30,
            height: Dimens.gap_dp18,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF0000), Color(0xFFFF9900)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              "最新",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Dimens.font_sp11,
                  color: Colors.white),
            ),
          ),
          Gaps.hGap12,
          SizedBox(
            width: Dimens.font_sp1 * 241,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: Dimens.font_sp12, color: const Color(0xFFFB6621)),
              overflow: TextOverflow.ellipsis, // 使用省略号来表示超出部分
              maxLines: 1, // 设置最大行数为 1
            ),
          ),
          Gaps.hGap48,
          onclick == null
              ? Container()
              : InkWell(
                  onTap: onclick,
                  child: Image(
                    image: Images.iconArrowRight,
                    color: const Color(0xFFFB6621),
                    width: Dimens.gap_dp24,
                    height: Dimens.gap_dp24,
                  ))
        ],
      ),
    );
  }
}
