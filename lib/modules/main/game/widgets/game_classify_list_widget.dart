import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/modules/main/game/game_page_controller.dart';
import 'package:flutter_video_community/widgets/image.dart';

class GameClassifyListWidget extends StatelessWidget {
  const GameClassifyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GamePageController.to;
    final dataList = controller.gameClassifyList;
    final currentGameClassify = controller.currentGameClassify.value;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final itemData = dataList[index];
        final checked = itemData.id == currentGameClassify?.id;
        return GestureDetector(
          onTap: () {
            controller.switchGameMenu(itemData);
          },
          child: Container(
            width: Dimens.gap_dp1 * 78,
            height: Dimens.gap_dp1 * 68,
            color: checked ? const Color(0xFFFFEDE6) : const Color(0xFFFAF7F7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RHExtendedImage.network(
                  itemData.pic,
                  width: Dimens.gap_dp24,
                  height: Dimens.gap_dp24,
                ),
                Text(
                  itemData.name,
                  style: TextStyle(
                    color: checked ? const Color(0xFFFA6520) : const Color(0xFF848077),
                    fontSize: Dimens.font_sp12,
                    fontFamily: 'PingFang SC',
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
