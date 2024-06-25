import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';

class VideoAnthologyItemWidget extends StatelessWidget {
  const VideoAnthologyItemWidget({
    super.key,
    required this.data,
    this.selected = false,
  });

  final ChapterModel data;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.gap_dp64,
      height: Dimens.gap_dp64,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFEBE7) : const Color(0xFFEFF2F9),
        borderRadius: BorderRadius.circular(Dimens.gap_dp6),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.gap_dp6),
                  bottomRight: Radius.circular(Dimens.gap_dp6),
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF0000),
                    Color(0xFFFF9900),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.gap_dp6,
                  vertical: Dimens.gap_dp1,
                ),
                child: Text(
                  'VIP',
                  style: TextStyle(
                    fontSize: Dimens.font_sp10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
          Align(
            child: Text(
              data.number,
              style: TextStyle(
                fontSize: Dimens.font_sp18,
                fontWeight: FontWeight.bold,
                color: selected ? const Color(0xFFF9552A) : const Color(0xFF191D26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
