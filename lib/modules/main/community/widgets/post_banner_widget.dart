import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/widgets/image.dart';

class PostBannerWidget extends StatelessWidget {
  const PostBannerWidget({
    super.key,
    required this.list,
    this.height,
    this.onTap,
  });

  final List<String> list;
  final double? height;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Dimens.gap_dp10 * 34,
      child: Swiper(
        autoplay: true,
        autoplayDelay: 2000,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return RHExtendedImage.network(
            list[index],
            // AppConfig.randomImage(),
            width: double.infinity,
            height: height ?? Dimens.gap_dp10 * 34,
            borderRadius: BorderRadius.circular(
              Dimens.gap_dp10,
            ),
          );
        },
        onTap: onTap,
      ),
    );
  }
}
