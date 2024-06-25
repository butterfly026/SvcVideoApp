import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/widgets/image.dart';

class VideoLiveItemWidget extends StatelessWidget {
  const VideoLiveItemWidget({
    super.key,
    required this.data,
  });

  final ClassifyContentModel data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Dimens.gap_dp10 * 24,
      child: Stack(
        children: [
          RHExtendedImage.network(
            data.pic,
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.circular(
              Dimens.gap_dp12,
            ),
            fit: BoxFit.cover,
          ),
          Positioned(
            top: Dimens.gap_dp12,
            left: Dimens.gap_dp12,
            child: _VideoLabelWidget(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(
                left: Dimens.gap_dp12,
                bottom: Dimens.gap_dp12,
                right: Dimens.gap_dp12,
              ),
              child: Text(
                data.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Dimens.font_sp12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoLabelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.gap_dp8,
        vertical: Dimens.gap_dp1,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF0000),
            Color(0xFFFF9900),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.gap_dp10),
          bottomLeft: Radius.circular(Dimens.gap_dp10),
          bottomRight: Radius.circular(Dimens.gap_dp10),
        ),
      ),
      child: Text(
        '进入直播间',
        style: TextStyle(
          fontSize: Dimens.font_sp1 * 13,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
