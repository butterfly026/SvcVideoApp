import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/live/live_anchor.dart';
import 'package:flutter_video_community/widgets/image.dart';

class VideoListItem extends StatelessWidget {
  const VideoListItem({
    super.key, required this.cover, required this.title,
  });

  final String cover;
  final String title;

  @override
  Widget build(BuildContext context) {
    return
      Stack(
          children: [
            RHExtendedImage.network(
              cover,
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.circular(
                Dimens.gap_dp12,
              ),
            ),
            // if (data.vip)
            //   const Align(
            //     alignment: Alignment.topLeft,
            //     child: VideoLabelWidget(text: 'VIP'),
            //   ),
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
                      title,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: Dimens.font_sp14,
                        fontWeight: FontWeight.bold,
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
