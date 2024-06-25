import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/widgets/image.dart';

class AppItemWidget extends StatelessWidget {
  const AppItemWidget({
    super.key,
    this.imageSize,
    this.data,
  });

  final double? imageSize;
  final AdsModel? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RHExtendedImage.network(
          data?.pic ?? AppConfig.randomImage(),
          width: imageSize ?? Dimens.gap_dp60,
          height: imageSize ?? Dimens.gap_dp60,
          borderRadius: BorderRadius.circular(Dimens.gap_dp10),
        ),
        Gaps.vGap6,
        Text(
          data?.name ?? '广告 App',
          style: TextStyle(
            fontSize: Dimens.font_sp12,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}
