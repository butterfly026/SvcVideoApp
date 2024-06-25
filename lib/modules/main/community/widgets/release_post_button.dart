import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

class ReleasePostButton extends StatelessWidget {
  const ReleasePostButton({
    super.key,
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.gap_dp48,
      height: Dimens.gap_dp48,
      decoration: BoxDecoration(
        color: const Color(0xFFF9552A),
        borderRadius: BorderRadius.circular(
          Dimens.gap_dp24,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(
              AppRouter.releasePost,
              arguments: type,
            );
          },
          borderRadius: BorderRadius.circular(
            Dimens.gap_dp24,
          ),
          child: Container(
            padding: EdgeInsets.all(Dimens.gap_dp12),
            child: RHExtendedImage.asset(
              Images.iconEdit.assetName,
              width: Dimens.gap_dp18,
              height: Dimens.gap_dp18,
            ),
          ),
        ),
      ),
    );
  }
}
