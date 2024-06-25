import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/widgets/image.dart';

class SeriesListItemWidget extends StatelessWidget {
  const SeriesListItemWidget({
    super.key,
    required this.data,
  });

  final ClassifyContentModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RHExtendedImage.network(
            data.pic,
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.circular(
              Dimens.gap_dp10,
            ),
          ),
        ),
        SizedBox(
          height: Dimens.gap_dp50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                data.title,
                maxLines: 1,
                style: TextStyle(
                  fontSize: Dimens.font_sp14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF191D26),
                ),
              ),
              Text(
                data.des,
                maxLines: 1,
                style: TextStyle(
                  fontSize: Dimens.font_sp12,
                  color: const Color(0xFF191D26),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
