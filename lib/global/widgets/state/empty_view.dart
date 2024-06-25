import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/image.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.text, this.style});

  final String? text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RHExtendedImage.asset(
            Images.imgEmpty.assetName,
            width: Dimens.gap_dp10 * 25,
            height: Dimens.gap_dp10 * 25,
          ),
          Text(
            text ?? '暂无数据',
            style: style ??
                TextStyle(
                  color: const Color(0xff626773),
                  fontSize: Dimens.font_sp14,
                ),
          ),
        ],
      ),
    );
  }
}
