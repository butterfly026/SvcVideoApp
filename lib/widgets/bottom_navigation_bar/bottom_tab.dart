import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/widgets/image.dart';

import 'bottom_tab_model.dart';

class BottomTab extends StatelessWidget {
  const BottomTab({
    super.key,
    required this.data,
    this.selected = false,
    this.encrypted = false,
    this.width,
    this.height,
    this.onTap,
  });

  final BottomTabModel data;
  final bool? selected;
  final bool encrypted;
  final double? width;
  final double? height;
  final Function(BottomTabModel)? onTap;

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    const double imageSize = 20;
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: () => onTap?.call(data),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: Stack(
              children: [
                RHExtendedImage.network(
                  selected ?? false ? data.unselectedIcon : data.icon,
                  width: imageSize,
                  height: imageSize,
                  cacheWidth: (imageSize * devicePixelRatio).round(),
                  cacheHeight: (imageSize * devicePixelRatio).round(),
                ),
                RHExtendedImage.network(
                  selected ?? false ? data.icon : data.unselectedIcon,
                  width: imageSize,
                  height: imageSize,
                  cacheWidth: (imageSize * devicePixelRatio).round(),
                  cacheHeight: (imageSize * devicePixelRatio).round(),
                ),
                if (!data.auth)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: RHExtendedImage.asset(
                      Images.iconTabMenuLock.assetName,
                      width: Dimens.gap_dp12,
                      height: Dimens.gap_dp12,
                    ),
                  ),
              ],
            ),
          ),
          Gaps.vGap4,
          Text(
            data.name,
            style: TextStyle(
              color: selected ?? false
                  ? const Color(0xFFFF0000)
                  : const Color(0xFF858078),
              fontSize: Dimens.font_sp11,
            ),
          ),
        ],
      ),
    );
  }
}
