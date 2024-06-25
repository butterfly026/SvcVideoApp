import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/global/widgets/work_tag.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';

class WorkChapterItemWidget extends StatelessWidget {
  const WorkChapterItemWidget({
    super.key,
    required this.data,
    required this.workVip,
    this.selected = false, required this.index,
  });

  final ChapterModel data;
  final bool workVip; //作品是否设置了会员专享
  final bool selected;
  final int index;

  @override
  Widget build(BuildContext context) {
    String num = '1';
    if (AppTool.isEmpty(data.number)) {
      num = (index + 1).toString();
    } else {
      num = data.number;
    }
    return Container(
      margin: EdgeInsets.only(right: Dimens.gap_dp6),
      width: Dimens.gap_dp1 * 104,
      height: Dimens.gap_dp66,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFEBE7) : const Color(0xFFEFF2F9),
        borderRadius: BorderRadius.circular(Dimens.gap_dp6),
      ),
      child: Stack(
        children: [
          AppUtil.buildChapterTag(workVip, data),
          Align(
            child: Text(
              '第$num章',
              style: TextStyle(
                fontSize: Dimens.font_sp18,
                fontWeight: FontWeight.bold,
                color: selected
                    ? const Color(0xFFF9552A)
                    : const Color(0xFF191D26),
              ),
            ),
          ),
        ],
      ),
    );
  }



}
