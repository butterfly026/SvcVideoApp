import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/community/community.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/image.dart';

class EscortListItem extends StatelessWidget {
  const EscortListItem({
    super.key,
    required this.data,
  });

  final CommunityModel data;

  @override
  Widget build(BuildContext context) {

    String imgIcon = AppTool.getFirstStr(data.pic);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: RHExtendedImage.network(
            imgIcon,
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.circular(
              Dimens.gap_dp10,
            ),
          ),
        ),
        SizedBox(
          height: Dimens.gap_dp54,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                data.title,
                style: TextStyle(
                  fontSize: Dimens.font_sp13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RHExtendedImage.asset(
                    Images.iconLocation.assetName,
                    width: Dimens.gap_dp6,
                    height: Dimens.gap_dp10,
                  ),
                  Gaps.hGap4,
                  Expanded(
                    child: Text(
                      data.area,
                      style: TextStyle(
                        fontSize: Dimens.font_sp12,
                        color: const Color(0xFF626773),
                      ),
                    ),
                  ),
                  Text(
                    '#${data.ageValue} #${data.heightValue}',
                    style: TextStyle(
                      fontSize: Dimens.font_sp10,
                      color: const Color(0xFF626773),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
