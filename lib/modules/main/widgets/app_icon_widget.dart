import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';
import 'package:flutter_video_community/widgets/image.dart';

class AppIconWidget extends StatelessWidget {
  const AppIconWidget({
    super.key,
    this.imageSize,
    this.data,
  });

  final double? imageSize;
  final AppIconModel? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RHExtendedImage.asset(
          AssetImage(data!.icon).assetName,
          width: Dimens.gap_dp56,
          height: Dimens.gap_dp56,
          borderRadius: BorderRadius.circular(Dimens.gap_dp10),
        ),
        Gaps.vGap6,
        Text(
          data?.title ?? '桌面图标',
          style: TextStyle(
            fontSize: Dimens.font_sp12,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}
