import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/widgets/image.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    super.key,
    required this.assetName,
    this.imageSize,
    this.onTap,
  });

  final String assetName;
  final double? imageSize;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Dimens.gap_dp28,
        height: Dimens.gap_dp28,
        alignment: Alignment.center,
        child: RHExtendedImage.asset(
          assetName,
          width: imageSize ?? Dimens.gap_dp28,
          height: imageSize ?? Dimens.gap_dp28,
        ),
      ),
    );
  }
}
