import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/community/community.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/image.dart';

class HallListItem extends StatelessWidget {
  const HallListItem({
    super.key,
    required this.data,
  });

  final CommunityModel data;

  @override
  Widget build(BuildContext context) {
    String imgIcon = AppTool.getFirstStr(data.pic);
    
    return Container(
      height: Dimens.gap_dp1 * 108,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(Dimens.gap_dp10),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.margin,
      ).copyWith(
        bottom: Dimens.gap_dp12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RHExtendedImage.network(
            imgIcon,
            width: Dimens.gap_dp80,
            height: Dimens.gap_dp80,
            borderRadius: BorderRadius.circular(Dimens.gap_dp40),
          ),
          Gaps.hGap10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: Dimens.gap_dp14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '妹子数量：1\n服务项目：${data.serviceItems}\n消费情况：${data.situation}',
                  style: TextStyle(
                    fontSize: Dimens.gap_dp12,
                    color: const Color(0xFF626773),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
