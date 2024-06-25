import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitSpinningLines(
            size: Dimens.gap_dp42,
            color: const Color(0xff9a9a9a),
          ),
          Gaps.vGap14,
          Text(
            '正在加载中...',
            style: TextStyle(
              color: const Color(0xff9a9a9a),
              fontSize: Dimens.font_sp14,
            ),
          ),
        ],
      ),
    );
  }
}
