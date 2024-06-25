import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/widgets/image.dart';

class WorkCatItemWidget extends StatelessWidget {
  const WorkCatItemWidget({
    super.key,
    required this.data,
  });

  final ClassifyContentModel data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          child: RHExtendedImage.network(
            data.pic,
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.circular(
              Dimens.gap_dp10,
            ),
          ),
        ),
        Align(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0x00181232),
                  Color(0x80181232),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(
                Dimens.gap_dp10,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: Dimens.gap_dp60,
            margin: EdgeInsets.symmetric(
              horizontal: Dimens.gap_dp12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: Dimens.font_sp14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  data.des,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: Dimens.font_sp12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
