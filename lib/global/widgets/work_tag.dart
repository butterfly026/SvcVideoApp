
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';

//作品vip标签
class WorkTag extends StatelessWidget {
  const WorkTag({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Align(
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
            tag,
            style: TextStyle(
              fontSize: Dimens.font_sp10,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }
}
