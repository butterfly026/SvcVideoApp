import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/game/game.dart';
import 'package:flutter_video_community/widgets/image.dart';

class GameActivityListItem extends StatelessWidget {
  const GameActivityListItem({
    super.key,
    required this.data,
  });

  final GameActivityModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimens.gap_dp6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RHExtendedImage.asset(
            Images.imgLocalBanner.assetName,
            width: double.infinity,
            height: Dimens.gap_dp10 * 18,
            borderRadius: BorderRadius.circular(
              Dimens.gap_dp10,
            ),
          ),
          Container(
            height: Dimens.gap_dp40,
            alignment: Alignment.centerLeft,
            child: Text(
              data.name,
              maxLines: 2,
              style: TextStyle(
                fontSize: Dimens.font_sp18,
                color: const Color(0xFF191D26),
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }
}
