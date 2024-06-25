import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/modules/main/game/game_page_controller.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

class GameClassifyItemListWidget extends StatelessWidget {
  const GameClassifyItemListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GamePageController.to;
    final dataMap = controller.dataMap;
    final currentGameClassify = controller.currentGameClassify.value;
    final dataList = dataMap[currentGameClassify?.id ?? ''] ?? [];
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: dataList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) {
        final itemData = dataList[index];
        return GestureDetector(
          onTap: () {
            Get.toNamed(
              AppRouter.gamePlay,
              parameters: {'code': itemData.code},
            );
            // Get.toNamed(
            //   AppRouter.gameDetails,
            //   arguments: itemData.code,
            // );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RHExtendedImage.network(
                itemData.logo,
                width: Dimens.gap_dp54,
                height: Dimens.gap_dp54,
                borderRadius: BorderRadius.circular(Dimens.gap_dp10),
              ),
              Text(
                itemData.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: Dimens.font_sp12,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
